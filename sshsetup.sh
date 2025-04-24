#!/bin/sh
# Check if the directories exist and contain the required files

# its one of both

for secrets_dir in /mnt/host-secrets /mnt/qdraw-ssh-secrets; do
  if [ -d "$secrets_dir" ]; then
    echo "Found $secrets_dir. Setting up SSH configuration..."
    
    mkdir -p ~/.ssh

    # if secrets_dir contains qdraw then use a different name
    if [[ "$secrets_dir" == *"qdraw"* ]]; then
      ssh_key_name="qdrawnl"
    else
      ssh_key_name="id_rsa"
    fi

    if [ -f "$secrets_dir/privateSshKey" ]; then
      cp $secrets_dir/privateSshKey ~/.ssh/$ssh_key_name
      chmod 600 ~/.ssh/$ssh_key_name
    fi

    if [ -f "$secrets_dir/publicSshKey" ]; then
      cp $secrets_dir/publicSshKey ~/.ssh/$ssh_key_name.pub
      chmod 644 ~/.ssh/$ssh_key_name.pub
    fi

    # Merge sshConfig into ~/.ssh/config
    if [ -f "$secrets_dir/sshConfig" ]; then
      if [ -f ~/.ssh/config ]; then
        echo "Merging $secrets_dir/sshConfig into ~/.ssh/config..."
        cat "$secrets_dir/sshConfig" >> ~/.ssh/config
      else
        echo "Copying $secrets_dir/sshConfig to ~/.ssh/config..."
        cp "$secrets_dir/sshConfig" ~/.ssh/config
      fi
      chmod 644 ~/.ssh/config
    fi

    echo "SSH configuration set up successfully from $secrets_dir."
  else
    echo "Directory $secrets_dir not found. Skipping."
  fi
done