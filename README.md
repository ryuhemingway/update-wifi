# reset-wifi

I made this because I was tired of only getting to use cafe wifi or public wifi for 30-60 minutes and then getting booted off unless I paid. With this program, just install and type in `reset wifi`. It will reset your wifi by toggling your MacOS private wifi setting on and off, forcing a new wifi address. That's it, enjoy!

`reset-wifi` is a small macOS terminal command for legitimate Wi-Fi troubleshooting. It refreshes the Wi-Fi radio without opening any windows, helping with captive-portal issues or flaky public hotspot connections.

It does not hack networks, bypass payment gates, or override venue rules. Use it only on networks you own or are authorized to use.

## Install

Clone the repo and run the installer:

```sh
git clone https://github.com/YOUR-USERNAME/reset-wifi.git
cd reset-wifi
./install.sh
source ~/.zshrc
```

Then run:

```sh
reset wifi
```

To change how long Wi-Fi stays off before being turned back on:

```sh
reset wifi --delay 3
```

To suppress normal terminal output:

```sh
reset wifi --quiet
```

To also open Wi-Fi settings after refreshing the radio:

```sh
reset wifi --open-settings
```

To run the command without cycling the radio:

```sh
reset wifi --no-cycle
```

## What It Does

When you run `reset-wifi`, the helper:

1. Finds your Mac's Wi-Fi hardware device.
2. Turns the Wi-Fi radio off, waits briefly, then turns it back on.
3. Exits without opening System Settings or any other popup window.

If you run `reset-wifi --open-settings`, it also opens **System Settings > Wi-Fi** after the refresh.

macOS manages Private Wi-Fi Address per network. This tool intentionally leaves that choice in System Settings so you can make an informed change for the network you are actually using.

## Uninstall

```sh
./uninstall.sh
source ~/.zshrc
```

## Safety And Legality

This project is for privacy maintenance and troubleshooting. Do not use it to evade access controls, paid sessions, public Wi-Fi limits, or terms of service. Respect the network operator's rules.

## Development

Run the script directly from the repo:

```sh
./bin/reset-wifi --help
./bin/reset-wifi --delay 3 --quiet --no-cycle
```

The installer adds:

- `~/.local/bin/reset-wifi`

The installer also removes the old `~/.local/bin/update-wifi` binary and old `update wifi` zsh shortcut block if they exist.

## Public Visibility

This repository is public. No license is granted
to copy, modify, redistribute, sublicense, or sell this code unless added later.
