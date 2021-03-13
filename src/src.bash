#!/bin/bash
#
# descr: this file is sourced via this repo's init.bash

_src(){
    #### hardcoded vars
    local PATH_THIS="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)/$(basename -- "${BASH_SOURCE[0]}")"
    local DIR_THIS="$(dirname -- "${PATH_THIS}")"
    local dir_repo="$(cd -- "${DIR_THIS}" && cd -- "$(git rev-parse --show-toplevel)" && echo "${PWD}")" && [ "${dir_repo}" != '' ] || ! __echo -se "ERROR: dir_repo=''" || return 1
    local dir_bin="${dir_repo}/bin"#### exports
    export GWS="${dir_repo}"
    #### aliases
    alias gws="cd ${GWS} && git status -sb"
}

_src "${@}" || exit "${?}"