#!/usr/bin/env bash
#
# owner: acegene
#
# descr: this file executes the init/init.bash of all child repositories
#
# todos: * add option for --partial for specifying submodules to act on
#        * initialize submodules

# shellcheck disable=SC1091

set -u

dir_this="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && printf %s "${PWD}")" || ! printf '%s\n' "ERROR: UNKNOWN_CONTEXT: could not generate dir_this" >&2 || exit 1
base_this="$(basename -- "${BASH_SOURCE[0]}")" || ! printf '%s\n' "ERROR: UNKNOWN_CONTEXT: could not generate base_this" >&2 || exit 1
path_this="${dir_this}/${base_this}"
[ -f "${path_this}" ] && [ -d "${dir_this}" ] || ! printf '%s\n' "ERROR: UNKNOWN_CONTEXT: could not generate paths" >&2 || exit 1

# shellcheck disable=SC2034
log_context="${base_this}" # implicitly used by __log func

dir_repo="$(git -C "${dir_this}" rev-parse --show-toplevel | sed 's/^\(.\):/\/\1/')" || ! printf '%s\n' "ERROR: ${log_context}: could not locate git repo dir for ${base_this}" || return 1

dir_sh_utils="${dir_repo}/repos/scripts/shell/sh-utils"
. "${dir_sh_utils}/misc-utils.sh" || ! printf '%s\n' "ERROR: ${log_context}: could not source ${dir_sh_utils}/misc-utils.sh" || return 1
. "${dir_sh_utils}/path-utils.sh" || ! printf '%s\n' "ERROR: ${log_context}: could not source ${dir_sh_utils}/path-utils.sh" || return 1
. "${dir_sh_utils}/print-utils.sh" || ! printf '%s\n' "ERROR: ${log_context}: could not source ${dir_sh_utils}/print-utils.sh" || return 1
. "${dir_sh_utils}/validation-utils.sh" || ! printf '%s\n' "ERROR: ${log_context}: could not source ${dir_sh_utils}/validation-utils.sh" || return 1

__generate_src() {
    local dir_repo="${1}"
    local path_src="${2}"
    local path_src_template="${dir_repo}/src/src.bash.template"
    #### create src file from template
    __execute_w_err_q cp "${path_src_template}" "${path_src}" || return 1
    #### overwrite placeholde template parameters
    __execute_w_err_q sed -i "s|TEMPLATE_DIR_REPO|${dir_repo}|g" "${path_src}" || return 1
}

__main() {
    #### hardcoded vars
    ## dirs
    local dir_submodules="${dir_repo}/repos"
    ## files
    local bash_aliases="${HOME}/.bash_aliases"
    local bashrc="${HOME}/.bashrc"
    local path_src="${dir_repo}/src/src.bash"
    local path_init_relative_submodule='init/init.bash'
    #### generate src file based on parameters
    local path_src="${dir_repo}/src/src.bash"
    __generate_src "${dir_repo}" "${dir_repo}/src/src.bash" || ! __log -e "could not generate src" || return 1
    #### create $bash_aliases and $bashrc if they do not exist
    __is_file "${bash_aliases}" || touch "${bash_aliases}" || ! __log -e "could not create '${bash_aliases}'" || return 1
    __is_file "${bashrc}" || __print_out_nl ". '${bash_aliases}'" >>"${bashrc}" || ! __log -e "could not write to '${bashrc}'" || return 1
    #### lines to add to files
    local lines_bash_aliases=("[ -f '${path_src}' ] && . '${path_src}'")
    #### add ${lines_bash_aliases[@]} to $bash_aliases if not already within $bash_aliases
    __file_append_trailing_nl_if_none "${bash_aliases}" || return 1
    local line_bash_aliases=''
    for line_bash_aliases in "${lines_bash_aliases[@]}"; do
        __file_append_line_if_not_found "${bash_aliases}" "${line_bash_aliases}" || return 1
    done
    #### collect all existing submodule/init/init.bash
    local path_inits=()
    local path_init=''
    local dir_submodule=''
    while IFS= read -r -d '' dir_submodule; do
        path_init="${dir_submodule}/${path_init_relative_submodule}"
        [ -f "${path_init}" ] || ! __log -w "could not locate ${path_init}; skipping" || continue
        path_inits+=("${path_init}")
    done < <(find "${dir_submodules}" ! -name "$(basename -- "${dir_submodules}")" -prune -type d -print0)
    #### list each submodule/init/init.bash
    __log -i 'listing available scripts to execute:'
    for path_init in "${path_inits[@]}"; do
        __print_err_nl "    ${path_init}"
    done
    #### execute all inits if the user answers yes to the given prompt
    if __yes_no_prompt "PROMPT: would you like to execute all of the above scripts? (y/n) "; then
        for path_init in "${path_inits[@]}"; do
            __execute_w_err "${path_init}" "${@}" || return 1
        done
    fi
}

__main "${@}"
