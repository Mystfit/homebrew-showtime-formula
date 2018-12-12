class Showtime < Formula
  desc "Node graph communication library"
  homepage "http://github.com/mystfit/Showtime-Cpp"
  url "https://github.com/Mystfit/Showtime-Cpp/archive/develop.zip"
  version "0.16.1"
  #sha256 "1fa7efa8a5926d59e5861913778c06b634d6f055e3ded0e282d6058350996c75"

  option "with-drafts"
  option "with-static"

  draft_args = []
  draft_args << "with-drafts" if build.with? "drafts"

  depends_on "cmake" => :build
  depends_on "msgpack"
  depends_on "fmt"
  depends_on "swig"
  depends_on "boost"
  depends_on "nlohmann/json/nlohmann_json" => "with-cmake"
  depends_on "zeromq" => draft_args
  depends_on "czmq" => draft_args

  def install
    args = ["-DBUILD_SHARED=ON", "-DCMAKE_PREFIX_PATH=#{HOMEBREW_PREFIX}"]
    args << "-DBUILD_DRAFTS=ON" if build.with? "drafts"
    args << "-DBUILD_STATIC=ON" if build.with? "static"
    system "cmake", args , *std_cmake_args, "."
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <Showtime.h>
      zst_init("homebrew_test", true);
      zst_destroy();
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-o", "test"
    system "./test"
  end
end
