# gene-ws
### description:
    This is a toplevel git repo which points to several subrepos

    This repo and its subrepos should include:
    * init/ # scripts to align your pc's cfg to the repo
    * src/ # files to be sourced by various shells
### notes:
    shells to be referenced in the 'usage' below
        gitBash is a type of windows shell
        powershell is a type of windows shell
        terminal is a linux/unix bash shell
### usage:
    clone repo wherever you'd like
        via gitBash/terminal
```
            cd "${HOME}" # can be any dir of your choice
            git clone https://github.com/AceGene/gene-ws.git
```
    clone subrepos
        via gitBash/powershell/terminal
```
            cd gene-ws
            git submodule init
            git submodule deinit "repos/lew"; git -c submodule."repos/lew".update=none submodule update --recursive
            git submodule foreach --recursive 'git submodule update --recursive --init || :'
            git submodule foreach '{ git checkout master && git pull; } || { git checkout main && git pull; } || :'
```
    init cfgs for shells
        if OS == windows
            via gitBash
```
                cd gene-ws && init/init.bash --os windows
```
        if OS == Linux or OS == Unix
            via terminal
```
                cd gene-ws && init/init.bash --os linux # 
```
        init for powershell
            via powershell
```
                cd gene-ws; init/init.ps1
```
### subrepos description:
    repos/aliases
        aliases, shell profile cfg
    repos/lrns
        the pursuit of knowledge!
    repos/media
        personal content, gaming etc
    repos/note
        cmd line note taking assistant
    repos/scripts
        scripts for pc cfg and various utility
