class Kolourpaint < Formula
  desc "Paint Program"
  homepage "https://kde.org/applications/graphics/kolourpaint/"
  url "https://download.kde.org/stable/applications/19.08.2/src/kolourpaint-19.08.2.tar.xz"
  sha256 "e8bde8d516159ae93dfe56565eea2919d2154606fd1814202f30caf21f659cda"

  head "git://anongit.kde.org/kolourpaint.git"

  depends_on "cmake" => :build
  depends_on "KDE-mac/kde/kf5-extra-cmake-modules" => :build
  depends_on "KDE-mac/kde/kf5-kdesignerplugin" => :build
  depends_on "KDE-mac/kde/kf5-kdoctools" => :build
  depends_on "ninja" => :build

  depends_on "KDE-mac/kde/kf5-breeze-icons"
  depends_on "KDE-mac/kde/kf5-kdelibs4support"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DKDE_INSTALL_QMLDIR=lib/qt5/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt5/plugins"
    args << "-DCMAKE_INSTALL_BUNDLEDIR=#{bin}"

    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *args
      system "ninja"
      system "ninja", "install"
      prefix.install "install_manifest.txt"
    end
    # Extract Qt plugin path
    qtpp = `#{Formula["qt"].bin}/qtpaths --plugin-dir`.chomp
    system "/usr/libexec/PlistBuddy",
      "-c", "Add :LSEnvironment:QT_PLUGIN_PATH string \"#{qtpp}\:#{HOMEBREW_PREFIX}/lib/qt5/plugins\"",
      "#{bin}/kolourpaint.app/Contents/Info.plist"
  end

  def post_install
    mkdir_p HOMEBREW_PREFIX/"share/kolourpaint"
    ln_sf HOMEBREW_PREFIX/"share/icons/breeze/breeze-icons.rcc", HOMEBREW_PREFIX/"share/kolourpaint/icontheme.rcc"
  end

  def caveats; <<~EOS
    You need to take some manual steps in order to make this formula work:
      "$(brew --repo kde-mac/kde)/tools/do-caveats.sh"
  EOS
  end

  test do
    assert `"#{bin}/kolourpaint.app/Contents/MacOS/kolourpaint" --help | grep -- --help` =~ /--help/
  end
end
