require_relative "../lib/cmake"

class Kf5Kpty < Formula
  desc "Pty abstraction"
  homepage "https://api.kde.org/frameworks/kpty/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.99/kpty-5.99.0.tar.xz"
  sha256 "a08489301dba85a766e2e6acbd62bf7faedd3d68279e0b2b1637541bebd0e86d"
  head "https://invent.kde.org/frameworks/kpty.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "gettext" => :build
  depends_on "graphviz" => :build
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-kcoreaddons"
  depends_on "ki18n"

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5Pty REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
