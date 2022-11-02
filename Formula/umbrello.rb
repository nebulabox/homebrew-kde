require_relative "../lib/cmake"

class Umbrello < Formula
  desc "UML modeller"
  homepage "https://umbrello.kde.org/"
  url "https://download.kde.org/stable/release-service/22.08.2/src/umbrello-22.08.2.tar.xz"
  sha256 "b3d1cb413ea859a1dd5c2fb92be5b1cd669eb22e0e5a675f769b82219c1d78b2"
  head "https://invent.kde.org/sdk/umbrello.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "kde-mac/kde/kdevelop-pg-qt" => :build
  depends_on "kde-mac/kde/kf5-kdesignerplugin" => :build
  depends_on "kde-mac/kde/kf5-kinit" => :build
  depends_on "kdoctools" => :build
  depends_on "ninja" => :build

  depends_on "hicolor-icon-theme"
  depends_on "kde-mac/kde/kdevelop"
  depends_on "kde-mac/kde/kf5-breeze-icons"
  depends_on "kde-mac/kde/kf5-kdelibs4support"
  depends_on "kde-mac/kde/qt-webkit"

  depends_on "kdev-php" => :recommended

  def install
    args = %W[
      -DBUILD_KF5=ON
      -DQt5WebKitWidgets_DIR=#{Formula["qt-webkit"].opt_prefix}/lib/cmake/Qt5WebKitWidgets
    ]

    system "cmake", *args, *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
    # Extract Qt plugin path
    qtpp = `#{Formula["qt@5"].bin}/qtpaths --plugin-dir`.chomp
    system "/usr/libexec/PlistBuddy",
           "-c", "Add :LSEnvironment:QT_PLUGIN_PATH string \"#{qtpp}\:#{HOMEBREW_PREFIX}/lib/qt5/plugins\"",
           "#{bin}/umbrello5.app/Contents/Info.plist"
  end

  def post_install
    system HOMEBREW_PREFIX/"bin/update-mime-database", HOMEBREW_PREFIX/"share/mime"
    mkdir_p HOMEBREW_PREFIX/"share/umbrello5"
    ln_sf HOMEBREW_PREFIX/"share/icons/breeze/breeze-icons.rcc", HOMEBREW_PREFIX/"share/umbrello5/icontheme.rcc"
  end

  def caveats
    <<~EOS
      You need to take some manual steps in order to make this formula work:
        "$(brew --repo kde-mac/kde)/tools/do-caveats.sh"
    EOS
  end

  test do
    assert_match "help", shell_output("#{bin}/umbrello5.app/Contents/MacOS/umbrello5 --help")
  end
end
