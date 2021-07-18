#!/bin/bash
#
# descr: this file executes the init/init.bash of all child repositories
# TODO: add option for --partial for execution of specifc init scripts

set -u

PATH_THIS="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)/"$(basename -- "${BASH_SOURCE[0]}")""
DIR_THIS="$(dirname -- "${PATH_THIS}")"
BASE_THIS="$(basename -- "${PATH_THIS}")"
[ -f "${PATH_THIS}" ] && [ -d "${DIR_THIS}" ] && [ -f "${DIR_THIS}/${BASE_THIS}" ] || ! >&2 echo "ERROR: ${BASE_THIS}: could not generate paths" || exit 1

__parse_args(){
    while (( "${#}" )); do
        case "${1}" in
            --operating-system|--os|-o)
                case "${2}" in
                    linux|windows|wsl) os="${2}"; shift ;;
                    *) >&2 echo "ERROR: ${BASE_THIS}: unrecognized '${1}' parameter '${2}', available options are windows, linux, or wsl" && return 1 ;;
                esac
                ;;
            *) >&2 echo "ERROR: ${BASE_THIS}: arg ${1} is unexpected" && return 2 ;;
        esac
        shift
    done
    [ "${os}" != '' ] || ! >&2 echo "ERROR: ${BASE_THIS}: --operating-system cmd arg is required" || return 3
}

################&&!%@@%!&&################ AUTO GENERATED CODE BELOW THIS LINE ################&&!%@@%!&&################
# yymmdd: 210228
# generation cmd on the following line:
# python "${GWSPY}/write-btw.py" "-t" "bash" "-w" "${GWS}/init/init.bash" "-x" "__echo" "__yes_no_prompt" "__check_if_objs_exist" "__append_line_to_file_if_not_found"

__echo(){
    #### echo that can watch the silent and verbose variables from the scope it was called from
    local out=''
    local send_out='false'; local stderr='false'; local obj_set='false'; local end_char='\n'
    while (( "${#}" )); do
        case "${1}" in
            --err|-e) stderr='true';;
            --verbose|-v) [ "${verbose}" == 'false' ] || send_out='true';;
            --silent|-s) [ "${silent}" == 'true' ] || send_out='true';;
            --no-newline|-n) end_char='';;
            -*) # convert flags grouped as in -vrb to -v -r -b
                case "${1:1}" in
                    "") echo "ERROR: arg ${1} is unexpected" && return 2;;
                    '-') break;;
                    [a-zA-Z]) echo "ERROR: arg ${1} is unexpected" && return 2;;
                    *[!a-zA-Z]*) echo "ERROR: arg ${1} is unexpected" && return 2;;
                    *);;
                esac
                set -- 'dummy' $(for ((i=1;i<${#1};i++)); do echo "-${1:$i:1}"; done) "${@:2}" # implicit shift
                ;;
            *)
                [ "${obj_set}" == 'false' ] && obj_set='true' || ! echo "ERROR: too many objs for __echo" || return 2
                out="${1}"
                ;;
        esac
        shift
    done
    [ "${send_out}" == 'false' ] || { [ "${stderr}" == 'true' ] && >&2 printf "${out}${end_char}" || printf "${out}${end_char}"; }
}

__yes_no_prompt(){ # __yes_no_prompt "string to print as prompt" "string to print if answered no" && cmd-if-continue || cmd-if-not-yes
    local REGEX='^[Yy]$'
    echo; read -p "${1} " -n 1 -r; echo; ! [[ "${REPLY}" =~ ${REGEX} ]] && echo "${2}" && return 1; echo
}

__check_if_objs_exist() {
    local objs=(); local type=''; local out=''
    local create='false'; local verbose='false'; local silent='false'; local send_out='false'; local obj_set='false'
    while (( "${#}" )); do
        case "${1}" in
            --type|-t)
                case "${2}" in
                    file|f|dir|d) type="${2}"; shift;;
                    *) __echo -se "ERROR: bad cmd arg combination '${1} ${2}'"; return 1;;
                esac
                ;;
            --create|-c) create='true';;
            --out|-o) send_out='true';;
            --verbose|-v) verbose='true';;
            --silent|-s) silent='true';;
            -*) # convert flags grouped as in -vrb to -v -r -b
                case "${1:1}" in
                    "") __echo -se "ERROR: arg ${1} is unexpected" && return 2;;
                    '-') break;;
                    [a-zA-Z]) __echo -se "ERROR: arg ${1} is unexpected" && return 2;;
                    *[!a-zA-Z]*) __echo -se "ERROR: arg ${1} is unexpected" && return 2;;
                    *);;
                esac
                set -- 'dummy' $(for ((i=1;i<${#1};i++)); do echo "-${1:$i:1}"; done) "${@:2}" # implicit shift
                ;;
            *) objs+=("${1}");;
        esac
        shift
    done

    local cmd=''; local flag=''
    case "${type}" in
        file|f) cmd='touch'; flag='f';;
        dir|d) cmd='mkdir'; flag='d';;
        *) __echo -se "ERROR: arg type '${1}' unexpected" && return 5;;
    esac
    for ((i=0; i<${#objs[@]}; i++)); do
        if [ "${create}" == 'true' ] && [ ! -"${flag}" "${objs[$i]}" ]; then
            "${cmd}" "${objs[$i]}" && __echo -ve "INFO: created ${type}: ${objs[$i]}" || ! __echo -se "ERROR: could not create ${type}: ${objs[$i]}" || return 4
            [ "${send_out}" == 'true' ] && out='created'
        fi
        [ ! -"${flag}" "${objs[$i]}" ] && __echo -ve "ERROR: ${objs[$i]} does not exist" && return 1
    done
    printf "${out}"
}

__append_line_to_file_if_not_found() {
    local file=''; local lines=()
    local verbose='false'; local silent='false'
    while (( "${#}" )); do
        case "${1}" in
            --file|-f) file="${2}"; shift;;
            --line|-l) line="${2}"; shift;;
            --verbose|-v) verbose='true';;
            --silent|-s) silent='true';;
            -*) # convert flags grouped as in -vrb to -v -r -b
                case "${1:1}" in
                    '-') break;;
                    "") echo "ERROR: arg ${1} is unexpected" && return 2;;
                    [a-zA-Z]) echo "ERROR: arg ${1} is unexpected" && return 2;;
                    *[!a-zA-Z]*) echo "ERROR: arg ${1} is unexpected" && return 2;;
                    *);;
                esac
                set -- 'dummy' $(for ((i=1;i<${#1};i++)); do echo "-${1:$i:1}"; done) "${@:2}" # implicit shift
                ;;
            *) lines+=("${1}");;
        esac
        shift
    done
    for line in "${@}"; do lines+=("${line}"); done
    [ ! -f "${file}" ] && __echo -se "ERROR: file not found: ${file}"
    for line in "${lines[@]}"; do
        if ! grep -qF -- "${line}" "${file}"; then
            [ "$(tail -c 1 "${file}")" != '' ] && printf '\n' >> "${file}" # ensure trailing new line
            printf "${line}\n" >> "${file}" && __echo -ve "INFO: '${line}' added to '${file}'" || ! __echo -se "ERROR: could not add ${line} to ${file}" || return 1
        fi
    done
}
################&&!%@@%!&&################ AUTO GENERATED CODE ABOVE THIS LINE ################&&!%@@%!&&################

_init() {
    #### hardcoded vars
    ## dirs
    local dir_repo="$(cd -- "${DIR_THIS}" && cd -- "$(git rev-parse --show-toplevel)" && echo "${PWD}")" && [ "${dir_repo}" != '' ] || ! __echo -se "ERROR: dir_repo=''" || return 1
    ## files
    local bash_aliases="${HOME}/.bash_aliases"
    local bashrc="${HOME}/.bashrc"
    local src="${dir_repo}/src/src.bash"
    #### default vars
    local os=''
    #### parse cmd args and overwrite vars
    __parse_args "${@}" || return "1${?}"
    #### create arg lists for init scripts
    local args="--os ${os}"
    ## lines to add to files
    local lines_bash_aliases=("[ -f '${src}' ] && . '${src}'")
    #### initialize submodules # TODO:
    #### list scripts matching submodule/init/init.bash
    local init_scripts=($(for g in $(find "${dir_repo}" -mindepth 2 -name ".git"); do local init="$(dirname "${g}")/init/init.bash"; [ -f "${init}" ] && echo "${init}"; done))
    for init_script in "${init_scripts[@]}"; do echo "${init_script}"; done
    #### execute scripts following user prompt 
    __yes_no_prompt "PROMPT: execute the above scripts? (y/n)" "INFO: aborting ${0}..." && { for init_script in ${init_scripts[@]};
        do { echo "EXEC: ${init_script} ${args}"; "${init_script}" ${args} || echo "ERROR: ${init_script} ${args}"; } ; done; } || return 1
    #### add $line to $bash_aliases if needed to source #gene_ws_source
    __check_if_objs_exist -ct 'file' "${bash_aliases}" || return "${?}"
    local status=''; status="$(__check_if_objs_exist -cot 'file' "${bashrc}")" || return "${?}"; [ "${status}" == 'created' ] && echo ". '${bash_aliases}'" >> "${bashrc}"
    #### add lines to files if not found
    __append_line_to_file_if_not_found -vf "${bash_aliases}" "${lines_bash_aliases[@]}"
}

_init "${@}" || exit "${?}"