#!/bin/bash

# Set variables
KEY_PATH="$HOME/.ssh/github"
PUBLIC_KEY_PATH="$KEY_PATH.pub"
ALLOWED_SIGNERS_FILE="$HOME/.ssh/allowed_signers"
DEFAULT_BRANCH="main"

# Prompt for user name and email
read -p -r "Enter your Git name: " GIT_NAME
read -p -r "Enter your Git email: " GIT_EMAIL

# Create the .ssh directory if it doesn't exist
mkdir -p "$HOME/.ssh"

# Prompt for a passphrase for the SSH key
read -s -p -r "Enter a passphrase for your SSH key: " PASSPHRASE
echo

# Generate an SSH ED25519 key with a passphrase
echo "Generating SSH ED25519 key..."
ssh-keygen -t ed25519 -f "$KEY_PATH" -C "$GIT_EMAIL" -N "$PASSPHRASE"

# Add the public key to allowed_signers file
echo "Adding public key to allowed_signers..."
echo "$(git config --get user.email) namespaces=\"git\" $(cat "$PUBLIC_KEY_PATH")" >> "$ALLOWED_SIGNERS_FILE"

# Set default branch name to main
git config --global init.defaultBranch "$DEFAULT_BRANCH"

# Set user name and email
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

# Set the user signing key to the new SSH key
git config --global commit.gpgSign true
git config --global user.signingkey "$PUBLIC_KEY_PATH"

# Enable tag signing and signoff
git config --global tag.gpgSign true
git config --global gpg.format ssh
git config --global signoff true

# Display a message indicating completion
echo "Git configuration initialized."
echo "SSH key generated at $KEY_PATH."
echo "Public key added to $ALLOWED_SIGNERS_FILE."
echo "Default branch set to '$DEFAULT_BRANCH'."
echo "User name set to '$GIT_NAME'."
echo "User email set to '$GIT_EMAIL'."
echo "User signing key set to the new SSH key."
echo "Commit signing, tag signing, and signoff enabled."
