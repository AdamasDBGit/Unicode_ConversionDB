# Converts all varchar occurrences to nvarchar(max) in dbo schema stored procedures
# Includes:
# - Parameter declarations (@param varchar(...))
# - Local variable declarations (DECLARE @var varchar(...))
# - Table variable/temp table columns (varchar(...))
# Excludes:
# - CONVERT/CAST operations (to preserve business logic)
# - Comments
# - String literals

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$root = Join-Path $PSScriptRoot "..\UnicodeDB\dbo\Stored Procedures"
if (-not (Test-Path $root)) {
    Write-Error "Could not find stored procedures folder: $root"
    exit 1
}

# Track statistics
$stats = @{
    FilesProcessed = 0
    FilesChanged = 0
    ReplacementsMade = 0
    Errors = @()
}

# Regex patterns
$procStartRegex = '(?i)^\s*CREATE\s+PROCEDURE\s+\[?dbo\]?\.\[?(\w+)\]?'
$varcharPattern = '(?i)varchar\s*\(\s*(?:max|\d+)\s*\)'
$declareVarPattern = "(?i)(@\w+)\s+varchar\s*\(\s*(?:max|\d+)\s*\)"
$tableVarPattern = "(?i)(\w+)\s+varchar\s*\(\s*(?:max|\d+)\s*\)"

function Backup-File {
    param([string]$Path)
    $bakPath = $Path + ".bak"
    if (-not (Test-Path $bakPath)) {
        Copy-Item -LiteralPath $Path -Destination $bakPath -Force
        Write-Host "Created backup: $bakPath"
    }
}

function Convert-VarcharToNVarchar {
    param(
        [string]$Content,
        [string]$FilePath
    )

    $modified = $false
    $newContent = $Content

    # Replace varchar declarations, excluding CONVERT/CAST
    $lines = $Content -split "`n"
    $newLines = @()
    
    foreach ($line in $lines) {
        $originalLine = $line

        # Skip comments and CONVERT/CAST lines
        if ($line -match '^\s*--' -or 
            $line -match '(?i)CONVERT\s*\(' -or 
            $line -match '(?i)CAST\s*\(') {
            $newLines += $line
            continue
        }

        # Replace parameter and variable declarations
        if ($line -match $varcharPattern) {
            $line = $line -replace '(?i)varchar\s*\(\s*(?:max|\d+)\s*\)', 'nvarchar(max)'
        }

        if ($line -ne $originalLine) {
            $modified = $true
            $stats.ReplacementsMade++
        }

        $newLines += $line
    }

    $newContent = $newLines -join "`n"
    return @{
        Content = $newContent
        Modified = $modified
    }
}

# Process all .sql files
Get-ChildItem -Path $root -Filter "*.sql" -Recurse | ForEach-Object {
    $file = $_
    $stats.FilesProcessed++

    try {
        $content = Get-Content -Path $file.FullName -Raw
        if (-not $content) { return }

        # Only process dbo schema stored procedures
        if (-not ($content -match $procStartRegex)) {
            Write-Host "Skipping non-dbo stored procedure: $($file.Name)"
            return
        }

        $result = Convert-VarcharToNVarchar -Content $content -FilePath $file.FullName
        
        if ($result.Modified) {
            Backup-File -Path $file.FullName
            Set-Content -Path $file.FullName -Value $result.Content -NoNewline
            $stats.FilesChanged++
            Write-Host "Updated: $($file.FullName)"
        }
    }
    catch {
        $stats.Errors += "Error processing $($file.Name): $_"
        Write-Warning "Error processing $($file.Name): $_"
    }
}

# Report statistics
Write-Host "`nConversion Statistics:"
Write-Host "Files Processed: $($stats.FilesProcessed)"
Write-Host "Files Changed: $($stats.FilesChanged)"
Write-Host "Total Replacements: $($stats.ReplacementsMade)"

if ($stats.Errors.Count -gt 0) {
    Write-Host "`nErrors encountered:"
    $stats.Errors | ForEach-Object { Write-Host "- $_" }
}