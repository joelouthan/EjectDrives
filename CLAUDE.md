# ElgatoStreamDeck-EjectDrives-macOS

## Project Overview

A simple one-button Stream Deck automation that ejects multiple external drives by name on macOS. Built for Joseph Louthan to safely eject his "Media" and "Archives" drives before unplugging and leaving with his laptop.

## Problem Statement

Manually ejecting multiple external drives before unplugging is tedious. Stream Deck button → one click → all drives ejected with notification.

## How It Works

1. **Shell script** (`eject-drives.sh`) — lists drives to eject, loops through them with `sudo /usr/sbin/diskutil eject`, shows macOS notifications
2. **AppleScript launcher** (`EjectDrives.app`) — wraps the shell script so Stream Deck can call it via the "Open" action
3. **Sudoers rule** — allows the user to run `diskutil eject` without a password prompt

## Key Implementation Decisions

### Why `sudo` in the script, not AppleScript's `with administrator privileges`?

Early approach: Used AppleScript's `with administrator privileges` flag. Problem: it prompted for a password every time, even with a sudoers rule in place. 

Root cause: AppleScript's privilege elevation goes through macOS's native privilege system, which doesn't respect sudoers rules.

**Solution:** Use `sudo /usr/sbin/diskutil eject` in the shell script directly. Pair it with a sudoers rule (`jlouthan ALL=(ALL) NOPASSWD: /usr/sbin/diskutil eject *`) to eliminate password prompts. This respects sudoers and works seamlessly.

### Why `/usr/sbin/diskutil` with full path?

AppleScript's `do shell script` runs in a minimal environment with a limited PATH. Using the full path ensures `diskutil` is always found.

### Why `sudo -n` isn't used?

`sudo -n` (non-interactive) would fail if the sudoers rule wasn't set up. Instead, we handle both cases:
- If sudoers is set up: runs silently
- If not: prompts for password (user-friendly fallback)

## Development Notes

### Testing the script

```bash
# Direct test
./eject-drives.sh

# Check the log file that AppleScript wrote
cat ~/tmp/eject.log
```

### Rebuilding the app

After editing `eject-drives.sh`:
```bash
make install
```

Or manually:
```bash
osacompile -o ~/Applications/EjectDrives.app -e 'do shell script "/bin/zsh /path/to/eject-drives.sh > ~/tmp/eject.log 2>&1"'
```

### Sudoers setup

```bash
make setup-sudoers
```

Or manually:
```bash
echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/sbin/diskutil eject *" | sudo tee /etc/sudoers.d/diskutil-eject
```

## Configuration

Edit `eject-drives.sh` to change the drive names:
```zsh
DRIVES=("Media" "Archives")
```

Notification title can also be customized in the `osascript` calls.

## Known Limitations

- Only ejects drives that are mounted in `/Volumes/`
- Silently skips drives that don't exist (no error if drive is already ejected)
- Requires macOS (uses `diskutil` and `osascript`)
- Requires the exact drive names to be correct

## Future Ideas

- Dynamically detect external drives (no hardcoded list)
- Add option to eject only mounted drives vs. specific named drives
- Support unmounting instead of ejecting (for internal volumes)
- Add logging to a persistent log file

## Emoji in README

The README includes an animated GIF reference (Soundwave ejecting cassettes) — kept as-is, playful touch for the open source project.
