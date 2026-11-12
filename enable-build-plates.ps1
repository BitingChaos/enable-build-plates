<#
Bambu Studio - Enable All Build Plates

Removes build plate restrictions from printer profiles in Bambu Studio.

Original concept:
Nicholas Caito
https://xenomorph.net

PowerShell version for Windows

2026-11-12
* first test

#>

Write-Host ""
Write-Host "Bambu Studio - Enable All Build Plates"
Write-Host ""

# Restrictive entries to remove
$LinesToDelete = @(
    '"image_bed_type"'
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

            if ($Content -match [regex]::Escape($LinePattern)) {

                $Content = $Content | Where-Object {
                    $_ -notmatch [regex]::Escape($LinePattern)
                }

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

        Write-Host "Script for Windows"
        Write-Host "Checking path: $JsonPath"
        Write-Host ""

        Process-JsonFiles -Path $JsonPath
    }
}


Write-Host "You may close this window or press any key to quit... " -NoNewline
$null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# EoF
