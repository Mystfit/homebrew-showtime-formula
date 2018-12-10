class Showtime < Formula
  desc "Node graph communication library"
  homepage "http://github.com/mystfit/Showtime-Cpp"
  url "https://github.com/Mystfit/Showtime-Cpp/archive/develop.zip"
  version "0.16.1"
  #sha256 "1fa7efa8a5926d59e5861913778c06b634d6f055e3ded0e282d6058350996c75"

  option "with-drafts"
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
    args = ["-DBUILD_STATIC=ON", "-DBUILD_SHARED=ON", "-DCMAKE_PREFIX_PATH=#{HOMEBREW_PREFIX}"]
    args << "-DBUILD_DRAFTS=ON" if build.with? "drafts"
    system "cmake", args , *std_cmake_args, "."
    system "make"
    system "make", "install"
  end

  test do
    system "ctest", "-C", "Release"
  end
end
