require_relative "../lib/cmake"

class Kf5Kdewebkit < Formula
  desc "KDE Integration for QtWebKit"
  homepage "https://api.kde.org/frameworks/kdewebkit/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.80/portingAids/kdewebkit-5.80.0.tar.xz"
  sha256 "917defa04b29407e8b89daedb16e1fe5dfdc1b116811b5b9815faa2a78ea0687"
  head "https://invent.kde.org/frameworks/kdewebkit.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-kparts"
  depends_on "kde-mac/kde/qt-webkit"

  def install
    args = kde_cmake_args
    args << "-DQt5WebKitWidgets_DIR=" + Formula["qt-webkit"].opt_prefix + "/lib/cmake/Qt5WebKitWidgets"

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5WebKit REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
