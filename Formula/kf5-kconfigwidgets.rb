require_relative "../lib/cmake"

class Kf5Kconfigwidgets < Formula
  desc "Widgets for configuration dialogs"
  homepage "https://api.kde.org/frameworks/kconfigwidgets/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.99/kconfigwidgets-5.99.0.tar.xz"
  sha256 "8579be2a4301071fb0485fccc733083b58330ac92d776be1b73e6f377a7dbf1f"
  head "https://invent.kde.org/frameworks/kconfigwidgets.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "gettext" => :build
  depends_on "graphviz" => :build
  depends_on "kdoctools" => :build
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-kauth"
  depends_on "kde-mac/kde/kf5-kcodecs"
  depends_on "kde-mac/kde/kf5-kconfig"
  depends_on "kde-mac/kde/kf5-kguiaddons"
  depends_on "kde-mac/kde/kf5-kwidgetsaddons"
  depends_on "ki18n"

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5ConfigWidgets REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
