require_relative "../lib/cmake"

class Kf5Kcmutils < Formula
  desc "Utilities for KDE System Settings modules"
  homepage "https://api.kde.org/frameworks/kcmutils/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.99/kcmutils-5.99.0.tar.xz"
  sha256 "757bcd8ea8ca1882612fdb4d4537e1932cfd23150f59931910e70b253bfa4ad2"
  head "https://invent.kde.org/frameworks/kcmutils.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-kdeclarative"

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
    (testpath/"CMakeLists.txt").write("find_package(KF5KCMUtils REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
