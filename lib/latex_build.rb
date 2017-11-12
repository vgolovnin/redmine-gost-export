class LatexBuild
   attr_accessor :binary, :build_directory, :options, :log

   class LatexView < ActionView::Base

     def latex(text, options = {})
       rules = [:code_file, :code_repo, :cite, :label, :ref, :gost_macros]
      # rules << :no_headers unless options[:headers]
       rc = RedCloth::TextileDoc.new(text || '', [:filter_html])
       rc.files = options[:files] || []
       rc.project = @project
       rc.macros = @project.macros
       rc.bibliography = @document.has_bibliography
       rc.to_gost_latex(*rules).chomp('')
     end
   end

   module RedCloth::Formatters::GostLatex
     include RedCloth::Formatters::LATEX

     def image(opts)
       return "" if opts[:src] =~ /^\w+\:\/\//
       img = self.files.find {|i| i[:filename] == opts[:src]}
       return '' unless img
       opts[:id] = File.basename(img[:filename]) unless opts[:id]
       opts[:title] = img[:title]  unless opts[:title]
       opts[:title] ||= ''
       # Build latex code
       [ "\\begin{figure}[H]",
         "  \\centering",
         "  \\includegraphics[width=1.0\\textwidth]{#{opts[:src]}}",
         ("  \\caption{#{escape opts[:title]}}" if opts[:title]),
         ("  \\label{#{escape opts[:id]}}" if opts[:id]),
         "\\end{figure}",
       ].compact.join "\n"
     end

     def table_open(opts)
       @table_label = opts[:id]
       @table_columns = nil
       @table = []
       @table_multirow = {}
       @table_multirow_next = {}
       return ''
     end

     def tr_open(opts)
       @table_row = []
       return ''
     end

     def td(opts)
       column = @table_row.size
       while @table_multirow.has_key?(column) && @table_multirow[column] > 0 do
         @table_row.push("")
         @table_multirow[column] -= 1
         column += 1
       end

       if opts[:th]
         opts[:text] = "\\textbf{#{opts[:text]}}"
       end

       if opts[:colspan]
         opts[:text] = "\\multicolumn{#{opts[:colspan]}}{ #{"X " * opts[:colspan].to_i}}{#{opts[:text]}}"
       end
       if opts[:rowspan]
         @table_multirow_next[column] = opts[:rowspan].to_i - 1
         opts[:text] = "\\multirow{#{opts[:rowspan]}}{\\linewidth}{#{opts[:text]}}"
       end
       @table_row.push(opts[:text])
       return ""
     end

     def tr_close(opts)
       @table_columns ||= @table_row.size
       @table_multirow.merge!(@table_multirow_next)
       @table_multirow_next = {}
       clines = (1..@table_columns).select {|i| @table_multirow[i-1].nil? || @table_multirow[i-1].zero?}
           .slice_when {|i, j| i+1 != j}.map {|a| "\\cline{#{a.first}-#{a.last}}"}.join ' '
       clines.empty? || clines << "\n"

       @table.push(@table_row.join(" & ") + "\\\\\n#{clines}")
       return ""
     end

     def table_close(opts)
       output = "\\begin{table}[h!]\n"
       output << "\\begin{tabularx}{\\linewidth}{ |#{" X |" * @table_columns }}\n"
       output << "\\hline\n"
       output << @table.join
       output << "\\hline\n"
       output << "\\end{tabularx}\n"
       output << "\\label{#{@table_label}}\n" if @table_label.present?
       output << "\\end{table}"
       output
     end
   end

   module GostLatexExtension
     attr_accessor :macros, :bibliography, :files, :project

     [:cite, :ref, :label].each do |command|
        define_method(command) do |text|
          text.gsub!(/\{\{#{command}\((.*?)\)\}\}/, "==\\#{command}{\\1}==")
          end
     end

     def code_file(text)
       text.gsub! /\{\{code_file\((.*?)\)\}\}/ do
         codefile = $1
         return $0 unless self.files.find{|f| f[:filename] == codefile}
         out = '<notextile>'
         out << "\\lstinputlisting{#{codefile}}"
         out << '</notextile>'
       end
     end

     def code_repo(text)
       text.gsub! /\{\{code_repo\((.*?)\)\}\}/ do
         repository = self.project.repository
         filename = $1
         return $0 unless repository
         filecontent = Redmine::CodesetUtil.to_utf8_by_setting(repository.cat(filename))
         return $0 unless filecontent
         out = '<notextile>'
           out << "\\begin{lstlisting}\n"
         out << filecontent
          out << "\\end{lstlisting}\n\n"
         out << '</notextile>'
       end
     end

     def gost_macros(text)
       self.macros.each do |macro|
         text.gsub! /\{\{#{macro.title}\}\}/, macro.text
       end
       text
     end

     def no_headers(text)
       text.gsub! /^\s*(h\d\.)/, "==\\1=="
     end

     def to_gost_latex(*rules)
       rules.each do |r|
         method(r).call(self) if self.respond_to?(r)
         end
       to(RedCloth::Formatters::GostLatex).chomp
     end
   end

   def initialize(project, bibs)
     @project = project
     self.binary = "latexmk"
     self.build_directory = File.join(Rails.root, 'tmp', 'gost', 'build', @project.identifier)
     self.options = "-xelatex -interaction=nonstopmode -halt-on-error"
     @view = LatexView.new('plugins/gost/app/views', project: @project,
                           info: @project.gost_info, bibs: bibs)
     self.clean

     RedCloth::TextileDoc.send(:include, GostLatexExtension)
   end

   def build(document)
     pwd = Dir.pwd
     directory = File.join(self.build_directory, "#{document.title}_#{Time.now.to_i}")
     FileUtils.mkdir_p directory
     Dir.chdir directory

     @view.assign document: document, directory: directory

     File.write(File.join(directory, "#{document.id}.tex"),
                @view.render(file: 'export/document.tex.erb'))
     Dir.chdir directory
     @errors = []
     begin
     f = IO.popen("#{self.binary} #{self.options} #{document.id}.tex")
     f.readlines.each do |line|
        if line.match(/^!\s/i)
          @errors << line
        end
     end
     rescue Errno::ENOENT => e
      raise
     rescue StandardError => e
      @errors << e
     ensure
       f.close unless f.nil?
      Dir.chdir pwd
     end
     File.join(directory, "#{document.id}.pdf")
   end

   def clean
     FileUtils.rm_rf Dir.glob("#{self.build_directory}/*")
   end

   def errors
     @errors
   end

end
