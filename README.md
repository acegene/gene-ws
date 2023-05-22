# gene-ws
## Description:
This is a toplevel git repo which points to several submodules


This repo's submodules with the following will have their corresponding scripts executed
* `.init/` # scripts to align your pc's cfg to the repo
* `.src/` # files to be sourced by various shells
## Glossary:
* gitbash -> type of windows shell -> see: https://gitforwindows.org/
* OS -> operating system
* powershell -> type of windows shell
* terminal -> linux/unix bash shell
## Usage:
### Initialize Repo
* via gitbash/terminal
```
dir_clone="${HOME}" # can replace with: dir_clone='path_to_put_repo_in'
git -C "${dir_clone}" clone git@github.com:AceGene/gene-ws.git
cd "${dir_clone}/gene-ws"
git submodule init
git submodule deinit "repos/lew" # errors are usually fine
git submodule update --recursive --progress
git submodule foreach --recursive 'git submodule update --recursive --init || :'
```
### Add Configs
* `cd <GENE_WS_PATH>`
* depenmding on OS, execute the following:
  * mint -> via terminal: `.init/init.bash --os <NAME_OS>`
  * ubuntu -> via terminal: `.init/init.bash --os <NAME_OS>`
  * win -> via gitbash: `.init/init.bash --os <NAME_OS>`; via powershell `.init/init.ps1`
  * wsl-ubuntu -> via terminal: `.init/init.bash --os <NAME_OS>`
  * other flavors of linux/unix -> via terminal: `.init/init.bash --os ubuntu` # untested
## editors:
* vscode -> see [.vscode](.vscode)
## formatters:
* c/cpp/csharp/java/objective-c/objective-cpp
  * clang-format -> see: https://clang.llvm.org/docs/ClangFormat.html
    * config file=`.clang-format`
    * installation -> see: https://llvm.org/builds/
* css/html/javascript/json/jsonc
  * jsbeautify
    * config file=`.jsbeautifyrc`
* editor-agnostic
  * editorconfig -> see: https://editorconfig.org/com/mvdan/sh
    * config file=`.editorconfig`
    * installation is editor specific
* python
  * black -> see: https://github.com/psf/black
    * config file=`pyproject.toml`
    * installation -> via pip: `pip install black`
* shell
  * bash/mksh/sh
    * shfmt -> see: https://github.com/mvdan/sh
      * config file=`.editorconfig`
      * installation -> via [go](https://go.dev/doc/install): `go install mvdan.cc/sh/v3/cmd/shfmt@latest`
## linters:
* python
  * mypy -> see: https://mypy.readthedocs.io/en/stable/getting_started.html
    * config file=`.mypy.ini`
    * installation -> via pip: `python3 -m pip install mypy`
  * pylint
    * config file=`.pylintrc`
    * installation -> via pip: `python3 -m pip install pylint`
* shell
  * bash/sh
    * shellcheck -> see: https://github.com/koalaman/shellcheck
      * config file=`.shellcheckrc`
      * installation -> see: https://github.com/koalaman/shellcheck#installing
