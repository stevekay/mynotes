#!/bin/bash

# setup git colors.

cat >>~/.gitconfig <<EOF
# Neonwolf Color Scheme for Git
#
# Based mostly on the colors from the badwolf airline theme
#
# Github: https://github.com/h3xx/git-colors-neonwolf
#
# Recommended additions to make this work:
#
#[core]
#   pager           = less -R       # handle colors correctly
#
#[color]
#   branch          = auto
#   diff            = auto
#   interactive     = auto
#   ui              = auto

[color "diff"]
    frag            = bold 160 238 # red
    meta            = bold 45 238  # light blue
    old             = bold 202 238 # orange
    new             = bold 82 238  # green
    commit          = bold 226 238 # yellow
    func            = bold 213 238 # dark orange


[color "grep"]
    linenumber      = bold 165 235
    filename        = bold 39 235
    separator       = bold 82 235
    function        = bold 222
    selected        = bold 255 235
    context         = 240
    match           = bold 154 235
    #matchContext   = ? # matching text in context lines
    #matchSelected  = ? # matching text in selected lines

[color "status"]
    added           = bold 154 235
    changed         = bold 166 235
    untracked       = bold 81 235
    unmerged        = bold 196 235

[color "decorate"]
    HEAD            = bold 81 235
    branch          = bold 121 235
    remoteBranch    = bold 222 235
    tag             = bold 166 235

[color "branch"]
    current         = bold 121 235
    local           = bold 81 235
    remote          = bold 222 235
    upstream        = bold 222 235
    plain           = 255

[color "interactive"]
    prompt          = bold 121 235
    header          = bold 165 235
    help            = bold 222 235
    error           = bold 196 235

# vi: ft=gitconfig ts=8 sts=8 sw=4 et
EOF

git config --global color.branch auto
git config --global color.diff auto
git config --global color.interactive auto
git config --global color.ui auto
git config --global color.pager true
