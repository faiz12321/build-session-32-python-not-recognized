# Windows-only checks. Changes only this process's PATH and restores it in finally.
$ErrorActionPreference='Stop'
function Check($ok,$name){if(-not $ok){throw "FAIL: $name"};"PASS: $name"}
$original=$env:Path
try {
 $pyhome=(& py -c 'import sys,os; print(os.path.dirname(sys.executable))').Trim()
 Check ($LASTEXITCODE -eq 0 -and (Test-Path -LiteralPath "$pyhome\python.exe")) 'existing Python found without installing'
 $alias=Join-Path $env:LOCALAPPDATA 'Microsoft\WindowsApps\python.exe'
 Check (Test-Path -LiteralPath $alias) 'recording alias exists'
 $env:Path=(($original -split ';')|Where-Object {$_ -notmatch 'hostedtoolcache'}) -join ';'
 $out=(& cmd /c 'python --version' 2>&1 | Out-String).Trim()
 Check ($LASTEXITCODE -eq 9009 -and $out -match 'Python was not found') 'prepared session reproduces alias failure'
 $where=@(& cmd /c 'where python')
 Check ($where.Count -eq 1 -and $where[0] -eq $alias) 'prepared search finds only alias'
 $env:Path="$env:Path;$pyhome"
 $out=(& cmd /c 'python --version' 2>&1 | Out-String).Trim()
 Check ($LASTEXITCODE -eq 9009) 'appending still reaches alias'
 $where=@(& cmd /c 'where python')
 Check ($where.Count -eq 2 -and $where[0] -eq $alias -and $where[1] -eq "$pyhome\python.exe") 'appended folder follows alias'
 $env:Path="$pyhome;$env:Path"
 $out=(& cmd /c 'python --version' 2>&1 | Out-String).Trim()
 Check ($LASTEXITCODE -eq 0 -and $out -match '^Python ') 'prepending starts installed Python'
 $exe=(& cmd /c 'python -c "import sys; print(sys.executable)"').Trim()
 Check ($exe -eq "$pyhome\python.exe") 'selected interpreter is expected one'
 $out=(& cmd /c 'pip --version' 2>&1 | Out-String).Trim()
 Check ($LASTEXITCODE -ne 0) 'standalone pip still absent before Scripts'
 $env:Path="$pyhome\Scripts;$env:Path"
 $out=(& cmd /c 'pip --version' 2>&1 | Out-String).Trim()
 Check ($LASTEXITCODE -eq 0 -and $out -match '^pip ') 'Scripts makes pip command available in prepared session'
 # A child cmd.exe PATH change must not persist into this PowerShell process.
 $beforeChild=$env:Path
 & cmd /c 'set "PATH=C:\made-up-path-for-this-child-only"'
 Check ($env:Path -eq $beforeChild) 'child PATH edit does not change parent process'
} finally { $env:Path=$original }
Check ($env:Path -ceq $original) 'original process PATH restored'
'PASS: all 12 critical checks passed'
$global:LASTEXITCODE=0
