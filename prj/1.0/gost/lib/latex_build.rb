
class LatexBuild
   attr_accessor :binary, :build_directory, :options, :log


   class LatexView < ActionView::Base

     def latex(text, options = {})
       rules = [:citation, :ref, :gost_macros]
       rules << :no_headers unless options[:headers]
       rc = RedCloth::TextileDoc.new(text || '', [:filter_html])
       rc.macros = @project.macros
       rc.to_gost_latex(*rules).chomp('')
     end
   end

   module RedCloth::Formatters::GostLatex
     include RedCloth::Formatters::LATEX

     def image(opts)
       # Don't know how to use remote links, plus can we trust them?
       return "" if opts[:src] =~ /^\w+\:\/\//
       # Resolve CSS styles if any have been set
       styling = opts[:class].to_s.split(/\s+/).collect { |style| latex_image_styles[style] }.compact.join ','
       # Build latex code
       [ "\\begin{figure}",
         "  \\centering",
         "  \\includegraphics[#{styling}]{#{opts[:src]}}",
         ("  \\caption{#{escape opts[:title]}}" if opts[:title]),
         ("  \\label{#{escape opts[:id]}}" if opts[:id]),
         "\\end{figure}",
       ].compact.join "\n"
     end

     def table_open(opts)
       @table_label = opts[:id]
       @table = []
       @table_multirow = {}
       @table_multirow_next = {}
       return  ''
     end

     def tr_open(opts)
       @table_row = []
       return ''
     end

     def table_close(opts)
       output  = "\\begin{table}\n"
       output << "  \\centering\n"
       output << "  \\begin{tabular}{ #{"l " * @table[0].size }}\n"
       @table.each do |row|
         output << "    #{row.join(" & ")} \\\\\n"
       end
       output << "  \\end{tabular}\n"
       output << "\\end{table}\n"
       output
     end

   end

   module GostLatexExtension
     attr_accessor :macros

     def citation(text)
       text.gsub! /\{\{cite\((.*?)\)\}\}/, "==\\cite{\\1}=="
     end

     def ref(text)
        text.gsub! /\{\{ref\((.*?)\)\}\}/, "==\\ref{\\1}=="
     end

     def gost_macros(text)
       self.macros.each do |macro|
         text.gsub! /\{\{#{macro.title}\}\}/, macro.text
       end
       text
     end

     def no_headers(text)
       text.gsub! /(h\d\.)/, "==\\1=="
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
     self.build_directory = File.join(Rails.root, 'tmp', 'gost', 'build')
     self.options = "-xelatex -interaction=nonstopmode"
     @view = LatexView.new('plugins/gost/app/views', project: @project,
                           info: @project.gost_info, bibs: bibs)
     self.clean #fixme multuthread

     RedCloth::TextileDoc.send(:include, GostLatexExtension)
   end

   def build(document)
     pwd = Dir.pwd
     directory = File.join(self.build_directory, document.title)
     FileUtils.mkdir_p directory
     Dir.chdir directory

     name="export"

     log = ""

     @view.assign document: document, directory: directory

     File.write(File.join(directory, "#{name}.tex"),
                @view.render(file: 'export/document.tex.erb'))
     Dir.chdir directory

     f = IO.popen(self.binary + " " + self.options + " " + name)
     log << f.readlines.join
     f.close

     Dir.chdir pwd
     self.log = log
     File.join(directory, name + ".pdf")
   end

   def clean
     FileUtils.rm_rf Dir.glob("#{self.build_directory}/*")
   end

   def errors(name)
     @errors = []
     File.readlines(File.join(self.build_directory, name, 'export.log')).each do |line|
       @errors << line if line.match(/(^!\s)|(\serror(\s|:))/i)
     end
     @errors
   end

end
