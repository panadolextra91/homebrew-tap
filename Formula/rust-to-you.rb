class RustToYou < Formula
  desc "🦀 Ferris rushes to a GitHub repo so you don't have to — a playful bilingual (VI+EN) CLI/TUI repository investigation report."
  homepage "https://github.com/panadolextra91/rust-to-you"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panadolextra91/rust-to-you/releases/download/v1.2.0/rust-to-you-aarch64-apple-darwin.tar.xz"
      sha256 "4a80f2505028ad80f25875e34909e95084cf4f6973643eb994f0709bc6fcca42"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panadolextra91/rust-to-you/releases/download/v1.2.0/rust-to-you-x86_64-apple-darwin.tar.xz"
      sha256 "d66dfff9a9467bc2a6cce5df297c1a5026ff1fa96f9c5a2afb4656e052007e95"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/panadolextra91/rust-to-you/releases/download/v1.2.0/rust-to-you-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "af50629ea5f0eaf9f2fce788de0d6b79eb3d5756f3fc9bbb7cd837e9151f02f0"
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "rust-to-you" if OS.mac? && Hardware::CPU.arm?
    bin.install "rust-to-you" if OS.mac? && Hardware::CPU.intel?
    bin.install "rust-to-you" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
