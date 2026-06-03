class RustToYou < Formula
  desc "🦀 Ferris rushes to a GitHub repo so you don't have to — a playful bilingual (VI+EN) CLI/TUI repository investigation report."
  homepage "https://github.com/panadolextra91/rust-to-you"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/panadolextra91/rust-to-you/releases/download/v1.1.0/rust-to-you-aarch64-apple-darwin.tar.xz"
      sha256 "6b657d53db024a6e4ac9e003f7ad3b12e452f96740daa78e41c462d79b675e98"
    end
    if Hardware::CPU.intel?
      url "https://github.com/panadolextra91/rust-to-you/releases/download/v1.1.0/rust-to-you-x86_64-apple-darwin.tar.xz"
      sha256 "22dbb8e8707474d55dfd0ecbc3a33128ba35b81b85b34153643c614652f9c0a1"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/panadolextra91/rust-to-you/releases/download/v1.1.0/rust-to-you-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "6546b2a30474a5d183b637343c5c77b665c9ae718575e79cb16d8438c236201b"
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
