require_relative "../lib/cmake"

class Kcalc < Formula
  desc "Calculator offering everything a scientific calculator does, and more"
  homepage "https://utils.kde.org/projects/kcalc/"
  url "https://download.kde.org/stable/release-service/22.08.2/src/kcalc-22.08.2.tar.xz"
  sha256 "8925bc54986b22886e17a6cd332bf5704877cdad3bae3d5e25e6917d6052c427"
  head "https://invent.kde.org/utilities/kcalc.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "gettext" => :build
  depends_on "kdoctools" => :build
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-breeze-icons"
  depends_on "kde-mac/kde/kf5-kinit"
  depends_on "mpfr"

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
    # Extract Qt plugin path
    qtpp = `#{Formula["qt@5"].bin}/qtpaths --plugin-dir`.chomp
    system "/usr/libexec/PlistBuddy",
      "-c", "Add :LSEnvironment:QT_PLUGIN_PATH string \"#{qtpp}\:#{HOMEBREW_PREFIX}/lib/qt5/plugins\"",
      "#{bin}/kcalc.app/Contents/Info.plist"
  end

  def post_install
    mkdir_p HOMEBREW_PREFIX/"share/kcalc"
    ln_sf HOMEBREW_PREFIX/"share/icons/breeze/breeze-icons.rcc", HOMEBREW_PREFIX/"share/kcalc/icontheme.rcc"
  end

  def caveats
    <<~EOS
      You need to take some manual steps in order to make this formula work:
        "$(brew --repo kde-mac/kde)/tools/do-caveats.sh"
    EOS
  end

  test do
    assert_match "help", shell_output("#{bin}/kcalc.app/Contents/MacOS/kcalc --help")
  end
end
