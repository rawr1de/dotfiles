#!/bin/bash

chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_*
chmod 644 ~/.ssh/*.pub
[ -f ~/.ssh/authorized_keys ] && chmod 600 ~/.ssh/authorized_keys
[ -f ~/.ssh/config ] && chmod 600 ~/.ssh/config

echo "SSH permissions fixed."
