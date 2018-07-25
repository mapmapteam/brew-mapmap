class Mapmap < Formula
  desc "Video mapping software"
  homepage "https://mapmapteam.github.io/"
  url "https://github.com/mapmapteam/mapmap/archive/0.6.1.tar.gz"
  sha256 "01a6be81ccf56daba94268877fb8b89c76c896b07dd5280523e1aacaefcf3f5f"
  head "https://github.com/mapmapteam/mapmap.git"

  depends_on "pkg-config" => :build
  depends_on "gst-plugins-base"
  depends_on "gstreamer"
  depends_on "liblo"
  depends_on "qt"
  depends_on "gst-libav" => :recommended
  depends_on "gst-plugins-good" => :recommended

  def install
    inreplace "src/src.pri" do |s|
      s.gsub! "INCLUDEPATH += /Library/Frameworks/GStreamer.framework/Versions/1.0/Headers",
              "QMAKE_CXXFLAGS += #{`pkg-config --cflags gstreamer-1.0 gstreamer-app-1.0 gstreamer-pbutils-1.0`.chomp!}"
      s.gsub! "LIBS += -F /Library/Frameworks/ -framework GStreamer",
              "LIBS += #{`pkg-config --libs gstreamer-1.0 gstreamer-app-1.0 gstreamer-pbutils-1.0`.chomp!}"
      s.gsub! "# CONFIG-=app_bundle",
              "CONFIG-=app_bundle"
    end

    system "qmake", "-config", "release"
    system "make"
    bin.install "MapMap"
  end

  test do
    system "#{bin}/MapMap", "--version"
  end
end
