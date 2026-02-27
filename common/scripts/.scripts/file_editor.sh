#!/bin/bash
fzf -i | xargs -i bash -c "emacs {} & disown -h"
