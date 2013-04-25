require File.expand_path "../test_helper", __FILE__

context "wordsmith css tests" do

  def wordsmith
    Wordsmith.new
  end

  test "includes all stylesheets into html" do
    in_temp_dir do
      wordsmith.init('w')
      FileUtils.cp("w/assets/stylesheets/default.css",
        "w/assets/stylesheets/other.css")
      Dir.chdir("w") { wordsmith.generate ["html"] }
      files = Dir.glob('w/**/*')
      assert files.include? "w/final/w/assets/stylesheets/default.css"
      assert files.include? "w/final/w/assets/stylesheets/other.css"
      html_contents = File.read("w/final/w/index.html")
      assert html_contents =~ /default.css/
      assert html_contents =~ /other.css/
    end
  end

  test "ignores css files starting with _" do
    in_temp_dir do
      wordsmith.init('w')
      FileUtils.cp("w/assets/stylesheets/default.css",
        "w/assets/stylesheets/_other.css")
      Dir.chdir("w") { wordsmith.generate ["html"] }
      files = Dir.glob('w/**/*')
      assert files.include? "w/final/w/assets/stylesheets/default.css"
      assert files.include? "w/final/w/assets/stylesheets/_other.css"
      html_contents = File.read("w/final/w/index.html")
      assert html_contents =~ /default.css/
      assert !(html_contents =~ /_other.css/)
    end
  end

  test "ignores epub.css in html" do
    in_temp_dir do
      wordsmith.init('w')
      FileUtils.cp("w/assets/stylesheets/default.css",
        "w/assets/stylesheets/epub.css")
      Dir.chdir("w") { wordsmith.generate ["html"] }
      files = Dir.glob('w/**/*')
      assert !files.include?("w/final/w/assets/stylesheets/epub.css")
      html_contents = File.read("w/final/w/index.html")
      assert !(html_contents =~ /epub.css/)
    end
  end

end