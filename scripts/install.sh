#!/bin/sh
set -eu

VERSION="${ELVORA_VERSION:-latest}"
PREFIX="${ELVORA_PREFIX:-/usr/local/bin}"
SERVER="${ELVORA_SERVER:-}"
ENROLL_TOKEN="${ELVORA_ENROLL_TOKEN:-}"
LABELS="${ELVORA_LABELS:-}"
REPO="${ELVORA_REPO:-zyvorai/elvora}"

need() { command -v "$1" >/dev/null 2>&1 || { echo "missing required command: $1" >&2; exit 1; }; }
need uname

os=$(uname -s | tr '[:upper:]' '[:lower:]')
arch=$(uname -m)
case "$arch" in arm64|aarch64) arch=arm64;; x86_64|amd64) arch=amd64;; *) echo "unsupported architecture: $arch" >&2; exit 1;; esac
case "$os" in darwin|linux) :;; *) echo "unsupported OS: $os" >&2; exit 1;; esac

asset="elvora-$os-$arch.tar.gz"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT INT TERM

# A private repository's release assets 404 without credentials, so prefer an
# authenticated GitHub CLI (gh auth login, or GH_TOKEN) and fall back to plain curl for
# public mirrors and ELVORA_RELEASE_BASE_URL.
if [ -n "${ELVORA_RELEASE_BASE_URL:-}" ]; then
  need curl
  curl -fL --retry 3 "$ELVORA_RELEASE_BASE_URL/$asset" -o "$tmp/elvora.tgz"
elif command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  if [ "$VERSION" = latest ]; then
    gh release download -R "$REPO" -p "$asset" -O "$tmp/elvora.tgz"
  else
    gh release download "$VERSION" -R "$REPO" -p "$asset" -O "$tmp/elvora.tgz"
  fi
else
  need curl
  if [ "$VERSION" = latest ]; then
    url="https://github.com/$REPO/releases/latest/download/$asset"
  else
    url="https://github.com/$REPO/releases/download/$VERSION/$asset"
  fi
  curl -fL --retry 3 "$url" -o "$tmp/elvora.tgz" || {
    echo "download failed. If $REPO is private, install the GitHub CLI and run 'gh auth login', or set ELVORA_RELEASE_BASE_URL to an internal mirror." >&2
    exit 1
  }
fi
tar -xzf "$tmp/elvora.tgz" -C "$tmp"
install -d "$PREFIX"
for b in elvora-agent elvoractl; do
  [ -f "$tmp/$b" ] && install -m 0755 "$tmp/$b" "$PREFIX/$b"
done

# The FluxVM runner (ELVORA_VM_RUNNER, docs/INTEGRATIONS.md) ships in the macOS tarball only.
# It goes to $LIBEXEC, not $PREFIX: it is run by the agent, never typed.
LIBEXEC="${ELVORA_LIBEXEC:-/usr/local/libexec}"
if [ -f "$tmp/elvora-fluxvm-runner" ]; then
  install -d "$LIBEXEC"
  install -m 0755 "$tmp/elvora-fluxvm-runner" "$LIBEXEC/elvora-fluxvm-runner"
  echo "Installed the FluxVM runner to $LIBEXEC/elvora-fluxvm-runner (set ELVORA_VM_RUNNER to use it)"
fi

echo "Installed Elvora binaries to $PREFIX"

if [ "$os" = darwin ] && [ -n "$SERVER" ]; then
  state="/Library/Application Support/Elvora"
  sudo mkdir -p "$state"
  sudo chmod 750 "$state"
  secret="$state/agent.secret"
  plist="/Library/LaunchDaemons/com.zyvor.elvora-agent.plist"
  args=""
  [ -n "$ENROLL_TOKEN" ] && args="<string>--enroll-token</string><string>$ENROLL_TOKEN</string>"
  [ -n "$LABELS" ] && args="$args<string>--labels</string><string>$LABELS</string>"
  cat > "$tmp/plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>Label</key><string>com.zyvor.elvora-agent</string>
<key>ProgramArguments</key><array><string>$PREFIX/elvora-agent</string><string>--server</string><string>$SERVER</string><string>--secret-file</string><string>$secret</string>$args</array>
<key>RunAtLoad</key><true/><key>KeepAlive</key><true/>
<key>StandardOutPath</key><string>/var/log/elvora-agent.log</string>
<key>StandardErrorPath</key><string>/var/log/elvora-agent.log</string>
</dict></plist>
PLIST
  sudo install -m 0644 "$tmp/plist" "$plist"
  sudo launchctl bootout system/com.zyvor.elvora-agent >/dev/null 2>&1 || true
  sudo launchctl bootstrap system "$plist"
  echo "Elvora agent installed and started via launchd"
fi
