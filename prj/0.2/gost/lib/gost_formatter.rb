require 'RedCloth'

module RedCloth::Formatters::LatexExport
  include RedCloth::Formatters::LATEX

end


module GostExportExtension
  class TextileDocGost < RedCloth::TextileDoc
  #  attr_accessor :draw_table_border_latex

    attr_accessor :title, :standard, :abstracts, :latex, :latex_definitions, :bibliography
    attr_accessor :wikipage
    cattr_accessor :definitions, :latex_definitions



    def gost_template?(text=self)
    text =~ /\{\{gost\|(.*?)\|(.*?)\}\}\s+/ or return false
    template, @title, @standard= $~[0..2]
    text.gsub! template, ''
      true
    end

     def gost_definitions?(text=self)
       text =~ /\{\{gost-definitions\}\}\s+/
     end

    def gost_bibliography?(text=self)
      text =~ /\{\{gost-bibliography\}\}\s+/
    end

    def extract_bibliography(text=self)
      text.gsub! '{{gost-bibliography}}', ''
    end


    def extract_definitions(text=self)
      @@definitions = Hash.new if @@definitions == nil
      @@latex_definitions = Hash.new if @@latex_definitions == nil
      text.scan(/(\{\{define\|(.*?)\|(.*?)\}\})/m) do |t, k, v|
        if k[0] == '\\'
          @@latex_definitions[k] = v
        else
          @@definitions[k] = v
        end
      end
    end

    def sub_defintions(text)
      @@definitions.each_pair do |k, v|
        text.gsub! "{{#{k}}}", v
      end
    end

I

    def remove_macros(text)
      text.gsub! /\{\{\w.*?\}\}/m , ''
    end

    def gost_abstracts(text)
      if text =~ /\A(.*?)h1\./m
        @abstracts = $1
        text.gsub! @abstracts, ''
        @abstracts = RedCloth::TextileDoc.new(@abstracts).to_latex
      else
        @abstracts = ''
      end
    end

    def initialize(wikipage)
      @@definitions = Hash.new if @@definitions == nil
      @@latex_definitions = Hash.new if @@latex_definitions == nil
      @wikipage = wikipage
      @title = wikipage.title
      @bibliography = nil
      super(wikipage.text)
    end

    def to_gost
      gost_template? or raise ParseError
      apply_rules([:extract_definitions, :sub_defintions,  :quotations, :remove_macros,
                   :gost_abstracts,])
      @latex = to(RedCloth::Formatters::LatexExport)
      self
    end
  end
end


RedCloth.include(GostExportExtension)