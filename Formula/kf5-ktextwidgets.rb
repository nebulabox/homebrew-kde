require_relative "../lib/cmake"

class Kf5Ktextwidgets < Formula
  desc "Advanced text editing widgets"
  homepage "https://api.kde.org/frameworks/ktextwidgets/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.99/ktextwidgets-5.99.0.tar.xz"
  sha256 "31e8dff053f866f0972febd7f78b680e8a015d0e17cef4e2dfdc446892b469a8"
  head "https://invent.kde.org/frameworks/ktextwidgets.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-kcompletion"
  depends_on "kde-mac/kde/kf5-kiconthemes"
  depends_on "kde-mac/kde/kf5-kservice"
  depends_on "kde-mac/kde/kf5-sonnet"
  depends_on "qt@5"

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
    (testpath/"CMakeLists.txt").write("find_package(KF5TextWidgets REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
