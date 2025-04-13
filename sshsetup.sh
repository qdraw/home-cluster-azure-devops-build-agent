#!/bin/bash
# Check if /mnt/secrets/ exists and contains the required files

if [ -d "/mnt/secrets/" ]; then
  echo "Found /mnt/secrets/. Setting up SSH configuration..."
  
  mkdir -p ~/.ssh
  if [ -f "/mnt/secrets/privateSshKey" ]; then
    cp /mnt/secrets/privateSshKey ~/.ssh/id_rsa
    chmod 600 ~/.ssh/id_rsa
  fi

  if [ -f "/mnt/secrets/publicSshKey" ]; then
    cp /mnt/secrets/publicSshKey ~/.ssh/id_rsa.pub
    chmod 644 ~/.ssh/id_rsa.pub
  fi

  if [ -f "/mnt/secrets/sshConfig" ]; then
    cp /mnt/secrets/sshConfig ~/.ssh/config
    chmod 644 ~/.ssh/config
  fi

  echo "SSH configuration set up successfully."
else
  echo "No /mnt/secrets/ directory found. Skipping SSH setup."
fi