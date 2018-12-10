class Showtime < Formula
  desc "Node graph communication library"
  homepage "http://github.com/mystfit/Showtime-Cpp"
  url "https://github.com/Mystfit/Showtime-Cpp/archive/develop.zip"
  version "0.16.1"
  #sha256 "1fa7efa8a5926d59e5861913778c06b634d6f055e3ded0e282d6058350996c75"

  option "with-drafts"
  
  depends_on "cmake" => :build
  depends_on "msgpack"
  depends_on "fmt"
  depends_on "swig"
  depends_on "boost"
  depends_on "nlohmann/json/nlohmann_json" => "with-cmake"
  
  args = []
  if build.with? "drafts"
    args << "with-drafts"
  end

  depends_on "zeromq" => args
  depends_on "czmq" => args  

  def install
    system "cmake", "-DBUILD_DRAFTS=ON", "-DBUILD_STATIC=ON", "-DBUILD_SHARED=ON", "-DCMAKE_PREFIX_PATH=#{HOMEBREW_PREFIX}", *std_cmake_args, "."
    system "make"
    system "make", "install"
  end

  test do
    system "ctest", "-C", "Release"
  end
end
