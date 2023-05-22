# This file is sourced by powershell profile's after this repo's init.ps1 is executed

$ErrorActionPreference = 'Stop'

function _src {
    #### hardcoded values
    $dir_this = $PSScriptRoot # not compatible with PS version < 3.0
    $dir_repo = "$(Push-Location $(git -C $($dir_this) rev-parse --show-toplevel); Write-Output $PWD; Pop-Location)"
    $FormatEnumerationLimit = -1
    #### exports
    ## export vars
    $global:GWS = $dir_repo
    $global:GWSA = "$($GWS)\repos\aliases"
    $global:GWSLEW = "$($GWS)\repos\lew"
    $global:GWSLEWST = "$($GWSLEW)\storage"
    $global:GWSL = "$($GWS)\repos\lrns"
    $global:GWSM = "$($GWS)\repos\media"
    $global:GWSS = "$($GWS)\repos\scripts"
    $global:GWSAHK = "$($GWSS)\win\ahk"
    $global:GWSPS = "$($GWSS)\win\ps1"
    $global:GWSPY = "$($GWSS)\py"
    $global:GWSSH = "$($GWSS)\shell"
    ## export paths
    $env:PATH += ";$($GWSA)\bin"
    $env:PATH += ";$($LEW)\bin"
    $env:PYTHONPATH = "$($env:PATH):${GWSPY}"
    #### aliases
    function global:gws () {Set-Location $global:GWS; gg}
    function global:gwsa() {Set-Location $global:GWSA; gg}
    function global:gwslew() {Set-Location $global:GWSLEW; gg}
    function global:gwslewst() {Set-Location $global:GWSLEWST; gg}
    function global:gwsl() {Set-Location $global:GWSL; gg}
    function global:gwsm() {Set-Location $global:GWSM; gg}
    function global:gwss() {Set-Location $global:GWSS; gg}
    function global:gwsahk() {Set-Location $global:GWSAHK; gg}
    function global:gwsps() {Set-Location $global:GWSPS; gg}
    function global:gwspy() {Set-Location $global:GWSPY; gg}
    function global:gwssh() {Set-Location $global:GWSSH; gg}
}

_src @args
