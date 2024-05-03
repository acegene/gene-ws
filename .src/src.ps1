# This file is sourced by powershell profile's after this repo's init.ps1 is executed

function __Set-Vars-GWS {
    function __Set-Var {
        param (
            [string]$var_name,
            [string]$value,
            [Int16]$target_scope = 0,
            [string[]]$scopes = @('Process')
        )
        foreach ($scope in $scopes) {
            [Environment]::SetEnvironmentVariable($var_name, $value, $scope)
        }
        New-Variable -Name $var_name -Value $value -Scope ($target_scope + 1)
    }

    $private:dir_this = $PSScriptRoot # not compatible with PS version < 3.0
    $private:dir_repo = "$(Push-Location $(git -C $($dir_this) rev-parse --show-toplevel); Write-Output $PWD; Pop-Location)"
    __Set-Var 'DOCCRY' "$($HOME)\Documents\synced\crypt" 1
    __Set-Var 'DOCUNC' "$($HOME)\Documents\synced\uncrypt" 1
    __Set-Var 'GWS' $dir_repo 1
    __Set-Var 'GWSA' "$($GWS)\repos\aliases" 1
    __Set-Var 'GWSLEW' "$($GWS)\repos\lew" 1
    __Set-Var 'GWSL' "$($GWS)\repos\lrns" 1
    __Set-Var 'GWSM' "$($GWS)\repos\media" 1
    __Set-Var 'GWSS' "$($GWS)\repos\scripts" 1
    __Set-Var 'GWSWIN' "$($GWSS)\win" 1
    __Set-Var 'GWSAHK' "$($GWSWIN)\ahk" 1
    __Set-Var 'GWSPS' "$($GWSWIN)\ps1" 1
    __Set-Var 'GWSPY' "$($GWSS)\py" 1
    __Set-Var 'GWSSH' "$($GWSS)\shell" 1

    $private:REPOS_MAYBE = (Get-Item $GWS).parent
    if ((Split-Path($REPOS_MAYBE) -Leaf) -eq 'repos') {
        __Set-Var 'REPOS' $REPOS_MAYBE 1
    }
}

$FormatEnumerationLimit = -1

__Set-Vars-GWS

$env:PATH += ";$($HOME)\.local\bin"
$env:PATH += ";$($GWSA)\bin"
$env:PATH += ";$($GWSLEW)\bin"
$env:PATH += ";$($GWSPS)\bin"
$env:PATH += ";$($GWSPY)\bin"
$env:PATH += ";$($GWSSH)\bin"
$env:PYTHONPATH = "$($env:PATH):${GWSLEW}:${GWSPY}"

function doccry () {Set-Location $DOCCRY}
function docunc () {Set-Location $DOCUNC}
function cry () {Set-Location $DOCCRY}
function unc () {Set-Location $DOCUNC}
function gws () {Set-Location $GWS; gg}
function gws () {Set-Location $GWS; gg}
function gwsa() {Set-Location $GWSA; gg}
function gwslew() {Set-Location $GWSLEW; gg}
function gwsl() {Set-Location $GWSL; gg}
function gwsm() {Set-Location $GWSM; gg}
function gwss() {Set-Location $GWSS; gg}
function gwswin() {Set-Location $GWSWIN; gg}
function gwsahk() {Set-Location $GWSAHK; gg}
function gwsps() {Set-Location $GWSPS; gg}
function gwspy() {Set-Location $GWSPY; gg}
function gwssh() {Set-Location $GWSSH; gg}

function repos() {Set-Location $REPOS}
