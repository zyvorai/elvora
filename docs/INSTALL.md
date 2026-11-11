# Install Elvora

Apple silicon Mac (agent / menu bar) or Linux (control plane). Builds are **Developer ID signed and notarized**.

## Mac: Homebrew (recommended)

```bash
brew install zyvorai/tap/elvora          # agent, elvoractl, FluxVM runner
brew install --cask zyvorai/tap/elvora   # menu-bar app
export ELVORA_VM_RUNNER="$(brew --prefix elvora)/libexec/elvora-fluxvm-runner"
```

FluxVM on the Mac should be **≥ 0.4.18** (prefer 0.4.19): `brew install zyvorai/tap/fluxvm`.

Licence: **$49 / enrolled Mac / year** on [Cashfree](https://payments.cashfree.com/forms/zyvor-elvora) (India + international cards).

## Mac: tarball or DMG

```bash
curl -fsSL https://raw.githubusercontent.com/zyvorai/elvora/v0.4.1/scripts/install.sh | ELVORA_VERSION=v0.4.1 sh
```

Or download [`elvora-darwin-arm64.tar.gz`](https://github.com/zyvorai/elvora/releases/download/v0.4.1/elvora-darwin-arm64.tar.gz), verify the `.sha256`, then:

```bash
tar -xzf elvora-darwin-arm64.tar.gz
sudo install -m 0755 elvora-agent elvoractl /usr/local/bin/
sudo install -d /usr/local/libexec
sudo install -m 0755 elvora-fluxvm-runner /usr/local/libexec/
```

Set `ELVORA_VM_RUNNER=/usr/local/libexec/elvora-fluxvm-runner` on agents that run `macos-vm` workloads.

### Menu-bar app

Download [`Elvora-0.4.1.dmg`](https://github.com/zyvorai/elvora/releases/download/v0.4.1/Elvora-0.4.1.dmg), open it, drag **Elvora** to Applications — or `brew install --cask zyvorai/tap/elvora`. It shows control-plane status from `ELVORA_SERVER` / `ELVORA_API_TOKEN`.

## Linux: control plane

Download [`elvora-linux-amd64.tar.gz`](https://github.com/zyvorai/elvora/releases/download/v0.4.1/elvora-linux-amd64.tar.gz) or the arm64 build, verify against `SHA256SUMS`, then run `elvora-server` with operator tokens and an agent secret (see the [website quick start](https://zyvorai.github.io/elvora/#quickstart)).

## Verify

```bash
elvoractl --version          # v0.4.1
elvora-fluxvm-runner --version
spctl -a -vv /Applications/Elvora.app   # Notarized Developer ID
```

## All releases

https://github.com/zyvorai/elvora/releases
