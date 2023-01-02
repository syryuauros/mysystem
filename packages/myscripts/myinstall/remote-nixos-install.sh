#!/usr/bin/env bash

set -e

# Ensure a consistent umask.
umask 0022

# Parse the command line for the -I flag
mountPoint=/mnt
system=
host=
verbosity=()

while [ "$#" -gt 0 ]; do
    i="$1"; shift 1
    case "$i" in
        --root)
            mountPoint="$1"; shift 1
            ;;
        --host)
            host="$1"; shift 1
            ;;
        --system|--closure)
            system="$1"; shift 1
            ;;
        *)
            echo "$0: unknown option \`$i'"
            exit 1
            ;;
    esac
done


nix copy "$system" --to "${host}?remote-store=${mountpoint}"
ssh "${host}" "nixos-install --root ${mountpoint} --system ${system} --no-root-passwd"
