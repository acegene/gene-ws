#!/usr/bin/env bash
#
# This file executes the .init/init.bash of all child repositories
#
# todos
#   * add option for --partial for specifying submodules to act on
#   * initialize submodules
#   * extend init.bash search logic for all dirs rather than only within repos/

# shellcheck disable=SC1091

set -u

dir_this="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && printf %s "${PWD}")" || ! printf '%s\n' "ERROR: UNKNOWN_CONTEXT: could not generate dir_this" >&2 || exit 1
base_this="$(basename -- "${BASH_SOURCE[0]}")" || ! printf '%s\n' "ERROR: UNKNOWN_CONTEXT: could not generate base_this" >&2 || exit 1
path_this="${dir_this}/${base_this}"
[ -f "${path_this}" ] && [ -d "${dir_this}" ] || ! printf '%s\n' "ERROR: UNKNOWN_CONTEXT: could not generate paths" >&2 || exit 1

# shellcheck disable=SC2034
log_context="${base_this}" # implicitly used by __log func

dir_repo="$(git -C "${dir_this}" rev-parse --show-toplevel | sed 's/^\([a-zA-Z]\):/\/\1/')" || ! printf '%s\n' "ERROR: ${log_context}: could not locate git repo dir for ${base_this}" || exit 1

# shellcheck disable=SC1090
for file in "${dir_repo}/repos/scripts/shell/sh/utils/"*.sh; do . "${file}" || exit "${?}"; done || exit "${?}"

__generate_src() {
    local dir_repo="${1}"
    local path_src="${2}"
    local path_src_template="${dir_repo}/.src/src.bash.template"
    #### create src file from template
    __exec_only_err cp "${path_src_template}" "${path_src}" || return 1
    #### overwrite placeholde template parameters
    __exec_only_err sed -i "s|<TEMPLATE_DIR_REPO>|${dir_repo}|g" "${path_src}" || return 1
}

__main() {
    #### hardcoded vars
    ## dirs
    local dir_submodules="${dir_repo}/repos"
    ## files
    local bashrc="${HOME}/.bashrc"
    local bash_aliases="${HOME}/.bash_aliases"
    local path_src="${dir_repo}/.src/src.bash"
    local path_init_relative_submodule='.init/init.bash'
    #### generate src file based on parameters
    __generate_src "${dir_repo}" "${dir_repo}/.src/src.bash" || ! __log -e "could not generate src" || return 1
    #### lines to add to files
    local lines_bashrc=("[ -f '${bash_aliases}' ] && . '${bash_aliases}'")
    local lines_bash_aliases=("[ -f '${path_src}' ] && . '${path_src}'")
    #### create $bash_aliases and $bashrc if they do not exist
    __is_file "${bashrc}" || touch "${bashrc}" || ! __log -e "could not create '${bashrc}'" || return 1
    __is_file "${bash_aliases}" || touch "${bash_aliases}" || ! __log -e "could not create '${bash_aliases}'" || return 1
    #### add ${lines_bashrc[@]} to $bashrc if not already within $bashrc
    __file_append_trailing_nl_if_none "${bash_aliases}" || return 1
    local line_bashrc=''
    for line_bashrc in "${lines_bashrc[@]}"; do
        __file_append_line_if_not_found "${bashrc}" "${line_bashrc}" || return 1
    done
    #### add ${lines_bash_aliases[@]} to $bash_aliases if not already within $bash_aliases
    __file_append_trailing_nl_if_none "${bashrc}" || return 1
    local line_bash_aliases=''
    for line_bash_aliases in "${lines_bash_aliases[@]}"; do
        __file_append_line_if_not_found "${bash_aliases}" "${line_bash_aliases}" || return 1
    done
    #### collect all existing submodule/.init/init.bash
    local path_inits=()
    local path_init=''
    local dir_submodule=''
    while IFS= read -r -d '' dir_submodule; do
        path_init="${dir_submodule}/${path_init_relative_submodule}"
        [ -f "${path_init}" ] || ! __log -w "could not locate ${path_init}; skipping" || continue
        path_inits+=("${path_init}")
    done < <(find "${dir_submodules}" ! -name "$(basename -- "${dir_submodules}")" -prune -type d -print0)
    #### list each submodule/.init/init.bash
    __log -i 'listing available scripts to execute:'
    for path_init in "${path_inits[@]}"; do
        __print_err_nl "    ${path_init}"
    done
    #### execute all inits if the user answers yes to the given prompt
    if __yes_no_prompt "PROMPT: would you like to execute all of the above scripts? (y/n) "; then
        for path_init in "${path_inits[@]}"; do
            __exec_w_err "${path_init}" "${@}" || return 1
        done
    fi
}

__main "${@}"
