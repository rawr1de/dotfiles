#!/bin/bash

# SXIV

# SXIV helper file as html (done by org-mode and CSS)
brave /home/rdo/Docs/5.systems/01.linux_shit/1.text/system/helpers/SXIV.html

# SXIV helper file as pdf (done by groff)
# groff -Kutf8 -ms ~/.scripts/groff_helpers/groff/SXIV_hp.ms -T pdf > SXIV_hp.pdf && zathura SXIV_hp.pdf && rm -rf SXIV_hp.pdf
