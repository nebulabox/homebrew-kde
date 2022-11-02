require_relative "../lib/cmake"

class Kf5Kimageformats < Formula
  desc "Image format plugins for Qt5"
  homepage "https://api.kde.org/frameworks/kimageformats/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.99/kimageformats-5.99.0.tar.xz"
  sha256 "06e636d4fe03d8d1b0bfed728d00c83fa639e2990fd5664a7101bd77621db1ee"
  head "https://invent.kde.org/frameworks/kimageformats.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "jasper"
  depends_on "karchive"
  depends_on "openexr"
  depends_on "qt@5"

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end
  
  patch :DATA

  def caveats
    <<~EOS
      You need to take some manual steps in order to make this formula work:
        "$(brew --repo kde-mac/kde)/tools/do-caveats.sh"
    EOS
  end

  test do
    assert_predicate lib/"qt5/plugins/imageformats/kimg_eps.so", :exist?
    assert_predicate share/"kservices5/qimageioplugins/eps.desktop", :exist?
  end
end

__END__
diff --git a/src/imageformats/avif.cpp b/src/imageformats/avif.cpp
index ccb4c56..1f5789b 100644
--- a/src/imageformats/avif.cpp
+++ b/src/imageformats/avif.cpp
@@ -351,12 +351,12 @@ bool QAVIFHandler::decode_one_frame()
     rgb.rowBytes = result.bytesPerLine();
     rgb.pixels = result.bits();
 
-#if AVIF_VERSION >= 100101
-    // use faster decoding for animations
-    avifResult res = avifImageYUVToRGB(m_decoder->image, &rgb, (m_decoder->imageCount > 1) ? AVIF_CHROMA_UPSAMPLING_NEAREST : AVIF_YUV_TO_RGB_DEFAULT);
-#else
+// #if AVIF_VERSION >= 100101
+//     // use faster decoding for animations
+//     avifResult res = avifImageYUVToRGB(m_decoder->image, &rgb, (m_decoder->imageCount > 1) ? AVIF_CHROMA_UPSAMPLING_NEAREST : AVIF_YUV_TO_RGB_DEFAULT);
+// #else
     avifResult res = avifImageYUVToRGB(m_decoder->image, &rgb);
-#endif
+// #endif
     if (res != AVIF_RESULT_OK) {
         qWarning("ERROR in avifImageYUVToRGB: %s", avifResultToString(res));
         return false;
@@ -782,11 +782,11 @@ bool QAVIFHandler::write(const QImage &image)
             }
         }
 
-#if AVIF_VERSION >= 100101
-        res = avifImageRGBToYUV(avif, &rgb, AVIF_RGB_TO_YUV_DEFAULT);
-#else
+// #if AVIF_VERSION >= 100101
+//         res = avifImageRGBToYUV(avif, &rgb, AVIF_RGB_TO_YUV_DEFAULT);
+// #else
         res = avifImageRGBToYUV(avif, &rgb);
-#endif
+// #endif
         if (res != AVIF_RESULT_OK) {
             qWarning("ERROR in avifImageRGBToYUV: %s", avifResultToString(res));
             return false;

