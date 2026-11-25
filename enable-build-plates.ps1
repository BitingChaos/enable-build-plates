<#
Bambu Studio - Enable All Build Plates

Removes build plate restrictions from printer profiles in Bambu Studio.

Original concept:
Nicholas Caito
https://xenomorph.net

PowerShell version for Windows

2026-11-24
* clear values instead of deleting lines
* leave default plate image type alone

2026-11-12
* first test

#>

Write-Host ""
Write-Host "Bambu Studio - Enable All Build Plates"
Write-Host ""

# Restrictive entries to remove
$LinesToDelete = @(
    '"bottom_texture_end_name"'
    '"not_support_bed_type"'
)

# Common Bambu Studio data location
$JsonLocations = @(
    "$env:APPDATA\BambuStudio\system\BBL\machine"
)

function Process-JsonFiles {
    param (
        [string]$Path
    )

    Get-ChildItem -Path $Path -Filter *.json -File -ErrorAction SilentlyContinue | ForEach-Object {

        $File = $_.FullName
        $Content = Get-Content $File

        $Changed = $false

    foreach ($LinePattern in $LinesToDelete) {

        $NewContent = $Content | ForEach-Object {

            if ($_ -match [regex]::Escape($LinePattern)) {

                $_ -replace '(:\s*")([^"]*)(")', '$1$3'

            } else {

                $_
            }

        }

        if (($NewContent -join "`n") -ne ($Content -join "`n")) {
            $Content = $NewContent
            $Changed = $true
        }
    }

        if ($Changed) {
            Set-Content -Path $File -Value $Content -Encoding UTF8
            Write-Host "File updated: $File"
        }


    }

    Write-Host ""
}

foreach ($JsonPath in $JsonLocations) {

    if (Test-Path $JsonPath) {

        # Write-Host "Script for Windows"
        Write-Host "Checking path: $JsonPath"
        Write-Host ""

        Process-JsonFiles -Path $JsonPath
    }
}


Write-Host "You may close this window or press any key to quit... " -NoNewline
$null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# EoF
