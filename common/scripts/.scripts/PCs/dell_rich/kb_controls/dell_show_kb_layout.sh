#!/bin/bash
xkblayout-state print "⌨ %s" | xargs -I {} notify-send "{}"
