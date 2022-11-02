require_relative "../lib/cmake"

class Kf5Kpackage < Formula
  desc "Lets applications manage user installable packages"
  homepage "https://api.kde.org/frameworks/kpackage/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.99/kpackage-5.99.0.tar.xz"
  sha256 "d8cb70f0abde1ab0b1968e7726b67e9843d7937cbae9440eda0f50f06a2ae417"
  head "https://invent.kde.org/frameworks/kpackage.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "gettext" => :build
  depends_on "graphviz" => :build
  depends_on "kdoctools" => :build
  depends_on "ninja" => :build

  depends_on "karchive"
  depends_on "kde-mac/kde/kf5-kcoreaddons"
  depends_on "ki18n"

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  def caveats
    <<~EOS
      You need to take some manual steps in order to make this formula work:
        "$(brew --repo kde-mac/kde)/tools/do-caveats.sh"
    EOS
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5Package REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
