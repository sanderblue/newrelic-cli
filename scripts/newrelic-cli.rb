class NewrelicCli < Formula
  desc "The New Relic Command-line Interface"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.6.56.tar.gz"
  sha256 "b0c511974cc6cfff6882f4dbe58291fc2116ce6ae21bac2fcd9e15d2fee12543"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9cd95686d267584b528169179e29f66b56a684fd14d013aa42c8980c8a195dd" => :catalina
    sha256 "5694ffd5282fe77c9378ec5a438933a47f5396b8b74c4d87569a3ddee2e83063" => :mojave
    sha256 "8e0d8ddd56417ff14599f2cddd342c2d75a5d17279cde237be8aebe5c8d6416d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/darwin/newrelic"

    output = Utils.popen_read("#{bin}/newrelic completion --shell bash")
    (bash_completion/"newrelic").write output
    output = Utils.popen_read("#{bin}/newrelic completion --shell zsh")
    (zsh_completion/"_newrelic").write output
  end

  test do
    assert_match /pluginDir/, shell_output("#{bin}/newrelic config list")
    assert_match /logLevel/, shell_output("#{bin}/newrelic config list")
    assert_match /sendUsageData/, shell_output("#{bin}/newrelic config list")
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
