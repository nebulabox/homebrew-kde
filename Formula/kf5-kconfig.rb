require_relative "../lib/cmake"

class Kf5Kconfig < Formula
  desc "Persistent platform-independent application settings"
  homepage "https://api.kde.org/frameworks/kconfig/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.80/kconfig-5.80.0.tar.xz"
  sha256 "2600449e6a6ccf2d9f61ba33abff7ed29c1f975b33bfe6cc7e6d8993dddd19b2"
  head "https://invent.kde.org/frameworks/kconfig.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "ninja" => :build

  depends_on "qt@5"

  def install
    args = kde_cmake_args

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5Config REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
