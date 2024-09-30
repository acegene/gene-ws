# gene-ws

## Description

This is a toplevel git repo which points to several submodules.

This repo's submodules with the following will have their corresponding scripts executed.

- `.init/` # scripts to align your pc's cfg to the repo
- `.src/` # files to be sourced by various shells

## Glossary

- bash -> linux/unix shell
- gitbash -> type of windows shell -> see: <https://gitforwindows.org/>
- OS -> operating system
- powershell -> type of windows shell

## Usage

### Initialize Repo (bash/gitbash)

- via bash/gitbash

Clone repo

```bash
dir_for_repo="${HOME}/repos" && # can be any directory of your choice
mkdir -p "${dir_for_repo}" &&
cd "${dir_for_repo}" &&
git clone git@github.com:acegene/gene-ws.git &&
echo "SUCCESS" || echo "FAILURE"
```

Clone submodules

```bash
cd "${dir_for_repo}/gene-ws" &&
git submodule init &&
git submodule deinit "repos/lew" &&
git -c submodule."repos/lew".update=none submodule update --recursive &&
git submodule foreach --recursive 'git submodule update --recursive --init || :' &&
git submodule foreach '{ git checkout master && git pull; } || { git checkout main && git pull; } || :' &&
echo "SUCCESS" || echo "FAILURE"
```

Init shell configurations

```bash
cd "${dir_for_repo}/gene-ws" &&
.init/init.bash --os mint
## open new shell to continue
```

Setup linter and formatter files

```bash
python3 "$GWSPY/actions.py" --yaml "$GWSPY/actions-jsons/cp_cfgs.yaml"
```

### Add Configs

- `cd <GENE_WS_PATH>`
- depenmding on OS, execute the following:
    - mint -> via bash: `.init/init.bash --os <NAME_OS>`
    - ubuntu -> via bash: `.init/init.bash --os <NAME_OS>`
    - win -> via gitbash: `.init/init.bash --os <NAME_OS>`; via powershell `.init/init.ps1`
    - wsl-ubuntu -> via bash: `.init/init.bash --os <NAME_OS>`
    - other flavors of linux/unix -> via bash: `.init/init.bash --os ubuntu` # untested

## Editors

- vscode -> see [.vscode](.vscode)

## Formatters

- c/cpp/csharp/java/objective-c/objective-cpp
    - clang-format -> see: <https://clang.llvm.org/docs/ClangFormat.html>
        - config file=`.clang-format`
        - installation -> see: <https://llvm.org/builds/>
- css/html/javascript/json/jsonc
    - jsbeautify
        - config file=`.jsbeautifyrc`
- editor-agnostic
    - editorconfig -> see: <https://editorconfig.org/com/mvdan/sh>
        - config file=`.editorconfig`
        - installation is editor specific
- python
    - black -> see: <https://github.com/psf/black>
        - config file=`pyproject.toml`
        - installation -> via pip: `python 3 -m pip install black`
- shell (bash/mksh/sh)
    - shfmt -> see: <https://github.com/mvdan/sh>
        - config file=`.editorconfig`
        - installation -> via [go](https://go.dev/doc/install): `go install mvdan.cc/sh/v3/cmd/shfmt@latest`

## Linters

- python
    - mypy -> see: <https://mypy.readthedocs.io/en/stable/getting_started.html>
        - config file=`.mypy.ini`
        - installation -> via pip: `python3 -m pip install mypy`
    - pylint
        - config file=`.pylintrc`
        - installation -> via pip: `python3 -m pip install pylint`
- shell (bash/sh)
    - shellcheck -> see: <https://github.com/koalaman/shellcheck>
        - config file=`.shellcheckrc`
        - installation -> see: <https://github.com/koalaman/shellcheck#installing>
