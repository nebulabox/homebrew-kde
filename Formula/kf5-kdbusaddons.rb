require_relative "../lib/cmake"

class Kf5Kdbusaddons < Formula
  desc "Addons to QtDBus"
  homepage "https://api.kde.org/frameworks/kdbusaddons/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.94/kdbusaddons-5.94.0.tar.xz"
  sha256 "0a1530117ccad6f1ea7b9db653bdf99adfe7f15f3f9394c3d885028f3ff4dae8"
  head "https://invent.kde.org/frameworks/kdbusaddons.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "ninja" => :build

  depends_on "dbus"
  depends_on "qt@5"

  def install
    args = kde_cmake_args

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5DBusAddons REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
