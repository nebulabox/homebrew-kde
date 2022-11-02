require_relative "../lib/cmake"

class Konsole < Formula
  desc "KDE's terminal emulator"
  homepage "https://konsole.kde.org/"
  url "https://download.kde.org/stable/release-service/22.08.2/src/konsole-22.08.2.tar.xz"
  sha256 "9e3574e23232a6aa38441d043ba3c624f0b4d275111a0c6eb1b7840caabde96c"
  head "https://invent.kde.org/utilities/konsole.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "kdoctools" => :build
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-breeze-icons"
  depends_on "kde-mac/kde/kf5-kinit"
  depends_on "kde-mac/kde/kf5-knewstuff"
  depends_on "kde-mac/kde/kf5-knotifyconfig"
  depends_on "kde-mac/kde/kf5-kparts"
  depends_on "kde-mac/kde/kf5-kpty"

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
    # Extract Qt plugin path
    qtpp = `#{Formula["qt@5"].bin}/qtpaths --plugin-dir`.chomp
    system "/usr/libexec/PlistBuddy",
      "-c", "Add :LSEnvironment:QT_PLUGIN_PATH string \"#{qtpp}\:#{HOMEBREW_PREFIX}/lib/qt5/plugins\"",
      "#{bin}/konsole.app/Contents/Info.plist"
  end

  def post_install
    mkdir_p HOMEBREW_PREFIX/"share/konsole"
    ln_sf HOMEBREW_PREFIX/"share/icons/breeze/breeze-icons.rcc", HOMEBREW_PREFIX/"share/konsole/icontheme.rcc"
  end

  def caveats
    <<~EOS
      You need to take some manual steps in order to make this formula work:
        "$(brew --repo kde-mac/kde)/tools/do-caveats.sh"
    EOS
  end

  test do
    assert_match "help", shell_output("#{bin}/konsole.app/Contents/MacOS/konsole --help")
  end
end
