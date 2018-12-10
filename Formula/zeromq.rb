class Zeromq < Formula
  desc "High-performance, asynchronous messaging library"
  homepage "http://www.zeromq.org/"
  url "https://github.com/zeromq/libzmq/releases/download/v4.3.0/zeromq-4.3.0.tar.gz"
  sha256 "8e9c3af6dc5a8540b356697081303be392ade3f014615028b3c896d0148397fd"

  head do
    url "https://github.com/zeromq/libzmq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "asciidoc" => :build
  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build

  def install
    # Work around "error: no member named 'signbit' in the global namespace"
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :high_sierra

    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    ENV["LIBUNWIND_LIBS"] = "-framework System"
    sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path
    ENV["LIBUNWIND_CFLAGS"] = "-I#{sdk}/usr/include"

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking", "--enable-drafts", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <zmq.h>

      int main()
      {
        zmq_msg_t query;
        assert(0 == zmq_msg_init_size(&query, 1));
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lzmq", "-o", "test"
    system "./test"
  end
end
