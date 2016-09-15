 class LatexBuild
    attr_accessor :binary, :directory, :options, :log


    def initialize
      self.binary = "latexmk"
      self.directory = Rails.root.to_s + "/plugins/gost/lib/build"
      self.options = "-xelatex"
      FileUtils.rm_f Dir.glob("#{self.directory}/*")
    end

    def build(tex, name="export")


      pwd = Dir.pwd
      log = ""
      Dir.chdir self.directory

      File.write("#{name}.tex", tex)

      f = IO.popen(self.binary + " " + self.options + " " + name)
        log << f.readlines.join
      f.close


      Dir.chdir pwd
    #  self.log = log
      self.directory + "/" + name + ".pdf"
    end

    def clean

    end
  end
