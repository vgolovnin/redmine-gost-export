# encoding: utf-8
module GostDocumentsHelper
  def latex_header(level)
    case level
      when 1
        'section'
      when 2
        'subsection'
      when 3
        'subsubsection'
      when 4
        'paragraph'
      when 5
        'subparagraph'
    end
  end

  def latex_textile_prepare(text)
    text = latex_citation(text)
    text = latex_code_listing(text)
    text
  end

  def latex_code_listing(text)
   text.gsub /<code(\s+class="(?'language'\w+)")?>(?'code'.*?)<\/code>/m do
     language = $~[:language].nil? ? '' : "[language=#{$~[:language]}]"
     "<notextile>\\begin{lstlisting}" + language + "\n" + $~[:code] + "\n\\end{lstlisting}</notextile>"
   end
  end


  def latex_citation(text)
    text.gsub /\{\{cite\((.*?)\)\}\}/, "<notextile>\\cite{\\1}</notextile>"
  end

  def functional_requirments
    @project.issues.inspect
  end

  def latex(text)
    RedCloth.new(latex_textile_prepare(text || ''), [:filter_html]).to_latex.chomp('')
  end
end
