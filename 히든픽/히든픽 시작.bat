@echo off
setlocal DisableDelayedExpansion
rem Opens the local HTML in an Edge or Chrome app window. No installation.
set "HP_DIR=%~dp0"
powershell.exe -NoLogo -NoProfile -Command "$ErrorActionPreference = 'Stop'; try { $files = @(Get-ChildItem -LiteralPath $env:HP_DIR -Filter '*.html' -File); if ($files.Count -ne 1) { throw 'Keep this launcher and the Hidden Pick HTML file in the same folder.' }; $uri = ([System.Uri]::new($files[0].FullName)).AbsoluteUri; $bases = @($env:ProgramFiles, ${env:ProgramFiles(x86)}, $env:LOCALAPPDATA) | Where-Object { $_ } | Select-Object -Unique; $candidates = @(); foreach ($base in $bases) { $candidates += Join-Path $base 'Microsoft\Edge\Application\msedge.exe' }; foreach ($base in $bases) { $candidates += Join-Path $base 'Google\Chrome\Application\chrome.exe' }; $browser = $candidates | Where-Object { Test-Path -LiteralPath $_ -PathType Leaf } | Select-Object -First 1; if (-not $browser) { foreach ($name in @('msedge.exe', 'chrome.exe')) { $found = Get-Command $name -CommandType Application -ErrorAction SilentlyContinue; if ($found) { $browser = $found.Source; break } } }; if (-not $browser) { throw 'Microsoft Edge or Google Chrome is required. You can also open the HTML file directly in a browser.' }; Start-Process -FilePath $browser -ArgumentList @(('--app=' + $uri), '--window-size=1280,900'); exit 0 } catch { Write-Host ''; Write-Host ('Hidden Pick: ' + $_.Exception.Message); exit 1 }"
if errorlevel 1 (
  echo.
  echo If Windows blocks this launcher, open the HTML file in Edge or Chrome.
  pause
  exit /b 1
)
endlocal
exit /b 0
