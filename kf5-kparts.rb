require "formula"

class Kf5Kparts < Formula
  desc "Document centric plugin system"
  homepage "http://www.kde.org/"
  url "https://download.kde.org/stable/frameworks/5.39/kparts-5.39.0.tar.xz"
  sha256 "26ebb165f82e8caacaadc70c7c996d2c68d3a40296389760940dc385859362e4"

  head "git://anongit.kde.org/kparts.git"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "KDE-mac/kde/kf5-extra-cmake-modules" => :build

  depends_on "qt"
  depends_on "KDE-mac/kde/kf5-kio"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      prefix.install "install_manifest.txt"
    end
  end
end
