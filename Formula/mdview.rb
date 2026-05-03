class Mdview < Formula
  include Language::Python::Virtualenv

  desc "GitHub-style Markdown previewer with auto-reload"
  homepage "https://gitlab.com/jweisner/mdview"
  url "https://gitlab.com/jweisner/mdview/-/archive/v0.1.0/mdview-v0.1.0.tar.gz"
  sha256 "5c98c1adeae64833aef9dfc02361df645666d44184543bd19b4dd764803b7e07"
  license "MIT"

  depends_on "python@3.13"

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/2b/f4/69fa6ed85ae003c2378ffa8f6d2e3234662abd02c10d216c0ba96081a238/markdown-3.10.2.tar.gz"
    sha256 "994d51325d25ad8aa7ce4ebaec003febcce822c3f8c911e3b17c52f7f589f950"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/db/7d/7f3d619e951c88ed75c6037b246ddcf2d322812ee8ea189be89511721d54/watchdog-6.0.0.tar.gz"
    sha256 "9ddf7c82fda3ae8e24decda1338ede66e1c99883db93711d8fb941eaa2d8c282"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write("# Hello\n\nWorld\n")
    port = free_port
    pid = fork do
      exec bin/"mdview", "test.md", "--port", port.to_s, "--no-open"
    end
    sleep 2
    output = shell_output("curl -s http://127.0.0.1:#{port}/content")
    assert_match "Hello", output
  ensure
    Process.kill("TERM", pid) if pid
  end
end
