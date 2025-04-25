#!/bin/bash

set -e

edksetup_sh() {
  export WORKSPACE="$(pwd)"
  export EDK_TOOLS_PATH="$WORKSPACE/BaseTools"
  export CONF_PATH="$WORKSPACE/Conf"
  export PATH="$EDK_TOOLS_PATH/Source/C/bin:$PATH"
  export PYTHON_COMMAND="python3"
  export PYTHONHASHSEED=1

  if [[ ! -f "$EDK_TOOLS_PATH/BuildEnv" ]]; then
    echo "❌ BaseTools/BuildEnv not found."
    return 1
  fi

  source "$EDK_TOOLS_PATH/BuildEnv" || return 1
}

install_tools() {
  if [[ "$(uname)" == "Darwin" ]]; then
    export HOMEBREW_NO_AUTO_UPDATE="1"
    export GCC5_AARCH64_PREFIX=/opt/homebrew/bin/aarch64-elf-

    # macOS-specific required tools for EDK2/OVMF
    for pkg in acpica mtoc nasm cmake ninja qemu lld; do
      if ! grep -qx "$pkg" < <(brew ls); then
        echo "📦 Installing $pkg..."
        brew install "$pkg"
      else
        echo "✅ $pkg already installed"
      fi
    done

    # Xcode CLI tools (required for clang, lldb, make)
    xcode-select --install 2>/dev/null || true

    # Optional: XQuartz, needed only for EmulatorPkg graphics
    # brew install --cask xquartz

    echo "✅ Verifying tools..."
    for tool in iasl mtoc nasm cmake ninja python3 qemu-system-x86_64 make clang lldb; do
      if ! command -v "$tool" >/dev/null 2>&1; then
        echo "❌ Missing tool: $tool" >&2
        exit 1
      else
        echo "✔️  Found: $tool → $(command -v $tool)"
      fi
    done

    echo ""
    echo "🔍 Versions:"
    nasm -v
    iasl -v
    qemu-system-x86_64 --version
    mtoc --version || echo "mtoc: no version output (expected)"

    export PATH="$(brew --prefix llvm)/bin:$PATH"
  fi
}

setup_edk2_repo() {
  EDK2_DIR="$HOME/edk2"

  if [[ -d "$EDK2_DIR" ]]; then
    cd "$EDK2_DIR"
    git pull
  else
    git clone https://github.com/tianocore/edk2.git "$EDK2_DIR"
    cd "$EDK2_DIR"
  fi

  cd "${EDK2_DIR}"
  git submodule update --init
  make -C BaseTools
}

build_target() {
  local arch="$1"
  local platform="$2"
  local outdir="$3"
  local toolchain="${4:-GCC5}"
  local buildtype="${5:-DEBUG}"

  echo "🚀 Building for ARCH=$arch PLATFORM=$platform"

  cat > Conf/target.txt <<EOF
ACTIVE_PLATFORM       = $platform
TARGET_ARCH           = $arch
TOOL_CHAIN_TAG        = $toolchain
TOOL_CHAIN_CONF       = Conf/tools_def.txt
BUILD_RULE_CONF       = Conf/build_rule.txt
EOF

  edksetup_sh || exit 1
  make -C BaseTools
  build -a "$arch" -t "$toolchain" -p "$platform" -b "$buildtype"

  mkdir -p "$outdir"
  cp -v Build/*/"${buildtype}_${toolchain}"/FV/*.fd "$outdir/"
}

OUTPUT_DIR=${OUTPUT_DIR:-"$HOME/ovmf"}
TOOLCHAIN_TAG=${TOOLCHAIN_TAG:-GCC5}ss

install_tools
setup_edk2_repo
build_target "AARCH64" "ArmVirtPkg/ArmVirtQemu.dsc" "$OUTPUT_DIR/aarch64"
build_target "X64" "OvmfPkg/OvmfPkgX64.dsc" "$OUTPUT_DIR/x64"
