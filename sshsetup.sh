#!/bin/sh
# Check if the directories exist and contain the required files

# its one of both

for secrets_dir in /mnt/host-secrets /mnt/qdraw-ssh-secrets; do
  if [ -d "$secrets_dir" ]; then
    echo "Found $secrets_dir. Setting up SSH configuration..."
    
    mkdir -p ~/.ssh

    # Define an array of file paths and their destinations
    for file in privateSshKey:id_rsa publicSshKey:id_rsa.pub sshConfig:config; do
      src="$secrets_dir/$(echo $file | cut -d: -f1)"
      dest="$HOME/.ssh/$(echo $file | cut -d: -f2)"

      if [ -f "$src" ]; then
        cp "$src" "$dest"
        case "$dest" in
          *.pub) chmod 644 "$dest" ;; # Public key
          config) chmod 644 "$dest" ;; # SSH config
          *) chmod 600 "$dest" ;; # Private key
        esac
      fi
    done

    echo "SSH configuration set up successfully from $secrets_dir."
  else
    echo "Directory $secrets_dir not found. Skipping."
  fi
done