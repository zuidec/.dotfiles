#!/bin/bash

sudo zypper in rclone

mkdir -p ~/Documents/OneDrive
rclone config

mkdir -p ~/.config/systemd/user
ln -s ~/.dotfiles/systemd/user/rclone-onedrive.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now rclone-onedrive


