require_relative "../lib/cmake"

class Kf5Kactivities < Formula
  desc "Core components for the KDE Activity concept"
  homepage "https://api.kde.org/frameworks/kactivities/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.99/kactivities-5.99.0.tar.xz"
  sha256 "69e8859509564a5993241cd6e6b7480c344dfe7c691710705cd5316d87fcf2d0"
  head "https://invent.kde.org/frameworks/kactivities.git", branch: "master"

  depends_on "boost" => :build
  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-kconfig"
  depends_on "kde-mac/kde/kf5-kcoreaddons"
  depends_on "kde-mac/kde/kf5-kwindowsystem"

  patch :DATA

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5Activities REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end

# Mark executables as nongui type

__END__
diff --git a/src/cli/CMakeLists.txt b/src/cli/CMakeLists.txt
index d0e13be..479031b 100644
--- a/src/cli/CMakeLists.txt
+++ b/src/cli/CMakeLists.txt
@@ -30,6 +30,8 @@ target_link_libraries (
    KF5::Activities
    )
 
+ecm_mark_nongui_executable(kactivities-cli)
+
 install (TARGETS
    kactivities-cli
    ${KF5_INSTALL_TARGETS_DEFAULT_ARGS}
