class Zstd < Formula
  desc "Zstandard is a real-time compression algorithm"
  homepage "https://facebook.github.io/zstd/"
  url "https://github.com/facebook/zstd/archive/v1.5.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/zstd-1.5.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/zstd-1.5.1.tar.gz"
  sha256 "dc05773342b28f11658604381afd22cb0a13e8ba17ff2bd7516df377060c18dd"
  license "BSD-3-Clause"
  head "https://github.com/facebook/zstd.git", branch: "dev"

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    cd "build/cmake" do
      system "cmake", "-S", ".", "-B", "builddir",
                      "-DZSTD_BUILD_CONTRIB=ON",
                      "-DCMAKE_INSTALL_RPATH=#{rpath}",
                      *std_cmake_args
      system "cmake", "--build", "builddir"
      system "cmake", "--install", "builddir"
    end
  end

  test do
    assert_equal "hello\n",
      pipe_output("#{bin}/zstd | #{bin}/zstd -d", "hello\n", 0)

    assert_equal "hello\n",
      pipe_output("#{bin}/pzstd | #{bin}/pzstd -d", "hello\n", 0)
  end
end
