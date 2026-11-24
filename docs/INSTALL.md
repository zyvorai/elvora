# Install Elvora

Apple silicon Mac (agent / menu bar) or Linux (control plane). Builds are **Developer ID signed and notarized**.

## Mac: Homebrew (recommended)

```bash
brew install zyvorai/tap/elvora          # agent, elvoractl, FluxVM runner
brew install --cask zyvorai/tap/elvora   # menu-bar app
export ELVORA_VM_RUNNER="$(brew --prefix elvora)/libexec/elvora-fluxvm-runner"
```

FluxVM on the Mac should be **≥ 0.4.18** (prefer 0.4.19): `brew install zyvorai/tap/fluxvm`.

Licence: **INR 19,942 per enrolled Mac per year incl. GST in India (about US$201 excl. tax outside India)**. [Buy](https://zyvor.dev/buy#elvora). Prices: INR incl. 18% GST in India; US dollars excl. tax elsewhere (VAT, GST or sales tax added where applicable). Pay online by UPI, card or netbanking; international cards work (charged in rupees); or request a US-dollar invoice by bank transfer. Custom pricing: contact sales@zyvor.dev. The app runs without a key. For a free 30-day trial key, email sales@zyvor.dev.

## Mac: tarball or DMG

```bash
curl -fsSL https://raw.githubusercontent.com/zyvorai/elvora/v0.5.0/scripts/install.sh | ELVORA_VERSION=v0.5.0 sh
```

Or download [`elvora-darwin-arm64.tar.gz`](https://github.com/zyvorai/elvora/releases/download/v0.5.0/elvora-darwin-arm64.tar.gz), verify the `.sha256`, then:

```bash
tar -xzf elvora-darwin-arm64.tar.gz
sudo install -m 0755 elvora-agent elvoractl /usr/local/bin/
sudo install -d /usr/local/libexec
sudo install -m 0755 elvora-fluxvm-runner /usr/local/libexec/
```

Set `ELVORA_VM_RUNNER=/usr/local/libexec/elvora-fluxvm-runner` on agents that run `macos-vm` workloads.

### Menu-bar app

Download [`Elvora-0.5.0.dmg`](https://github.com/zyvorai/elvora/releases/download/v0.5.0/Elvora-0.5.0.dmg) (macOS 14 or later), open it, drag **Elvora** to Applications — or `brew install --cask zyvorai/tap/elvora`. It shows control-plane status from `ELVORA_SERVER` / `ELVORA_API_TOKEN`.

**First start (one Mac, no setup).** Elvora lives in the menu bar and opens no window. Click its icon and choose **Start local Elvora server**. Elvora creates a private data folder (`~/Library/Application Support/Elvora`), starts the control plane on this Mac only, on a random free port that it remembers (port 8080 is often taken, so it is not used), and opens the dashboard already signed in. The same app contains `elvora-server`, `elvora-agent` and `elvoractl`; with a local server running, `elvoractl` and `elvora-agent` find it without any `--server` flag. For a fleet of Macs, run `elvora-server` with your own secrets as described below.

## Linux: control plane

Download [`elvora-linux-amd64.tar.gz`](https://github.com/zyvorai/elvora/releases/download/v0.5.0/elvora-linux-amd64.tar.gz) or the arm64 build, verify against `SHA256SUMS`, then run `elvora-server` with operator tokens and an agent secret (see the [website quick start](https://zyvorai.github.io/elvora/#quickstart)).

## Verify

```bash
elvoractl --version          # v0.5.0
elvora-fluxvm-runner --version
spctl -a -vv /Applications/Elvora.app   # Notarized Developer ID
```

## All releases

https://github.com/zyvorai/elvora/releases
