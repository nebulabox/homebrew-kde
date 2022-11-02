require_relative "../lib/cmake"

class Kf5Kwallet < Formula
  desc "Secure and unified container for user passwords"
  homepage "https://api.kde.org/frameworks/kwallet/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.99/kwallet-5.99.0.tar.xz"
  sha256 "d2c66b736872563a7ce4db5765325ecf5ec07c8f296e7160946bccefcce02a07"
  head "https://invent.kde.org/frameworks/kwallet.git", branch: "master"

  depends_on "boost" => :build
  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "gettext" => :build
  depends_on "graphviz" => :build
  depends_on "kdoctools" => :build
  depends_on "ninja" => :build

  depends_on "gpgme"
  depends_on "kde-mac/kde/kf5-kiconthemes"
  depends_on "kde-mac/kde/kf5-knotifications"
  depends_on "kde-mac/kde/kf5-kservice"
  depends_on "libgcrypt"
  depends_on "qca"

  patch :DATA

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
    (testpath/"CMakeLists.txt").write("find_package(KF5Wallet REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end

# Mark executables as nongui type

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 6f1d918..0dbc257 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -22,6 +22,7 @@ include(KDECMakeSettings)
 include(ECMAddQch)
 include(ECMSetupVersion)
 include(ECMQtDeclareLoggingCategory)
+include(ECMMarkNonGuiExecutable)
 
 option(BUILD_KWALLETD "Build the kwallet daemon" ON)
 option(BUILD_KWALLET_QUERY "Build kwallet-query tool" ON)
diff --git a/src/runtime/kwallet-query/src/CMakeLists.txt b/src/runtime/kwallet-query/src/CMakeLists.txt
index 9aa167b..9a98eb4 100644
--- a/src/runtime/kwallet-query/src/CMakeLists.txt
+++ b/src/runtime/kwallet-query/src/CMakeLists.txt
@@ -12,4 +12,5 @@ TARGET_LINK_LIBRARIES(kwallet-query
     Qt5::Widgets
 )
 
+ecm_mark_nongui_executable(kwallet-query)
 install( TARGETS kwallet-query DESTINATION ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
diff --git a/src/runtime/kwalletd/CMakeLists.txt b/src/runtime/kwalletd/CMakeLists.txt
index 918ba5d..7ee4462 100644
--- a/src/runtime/kwalletd/CMakeLists.txt
+++ b/src/runtime/kwalletd/CMakeLists.txt
@@ -119,6 +119,7 @@ if (Gpgmepp_FOUND)
     kde_target_enable_exceptions(kwalletd5 PRIVATE)
 endif(Gpgmepp_FOUND)
 
+ecm_mark_nongui_executable(kwalletd5)
 install(TARGETS kwalletd5  ${KF5_INSTALL_TARGETS_DEFAULT_ARGS})
 
 ########### install files ###############
