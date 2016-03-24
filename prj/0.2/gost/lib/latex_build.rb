module GostExportExtension

  class LatexBuild
    attr_accessor :binary, :directory, :options, :log


    def initialize
      self.binary = "latexmk"
      self.directory = BUILD_DIR
      self.options = "-xelatex -interaction=nonstopmode"
    end

    def build(name="export")

      pwd = Dir.pwd
      log = ""
      Dir.chdir self.directory

      f = IO.popen(self.binary + " " + self.options + " " + name)
        log << f.readlines.join
      f.close


      Dir.chdir pwd
      self.log = log
      self.directory + "/" + name + ".pdf"
    end

    def clean

    end
  end
end