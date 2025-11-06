# Converts direct stored-procedure parameter declarations from VARCHAR(...) to NVARCHAR(MAX)
# - Scans all .sql files under dbo\Stored Procedures
# - For each file that contains CREATE/ALTER PROCEDURE, only edits the procedure header (up to the first AS or BEGIN)
# - Replaces occurrences like "@param VARCHAR(100)" or "@param varchar(max)" with "@param NVARCHAR(MAX)"
# - Creates a backup file with extension .orig before writing changes

Set-StrictMode -Version Latest

$root = Join-Path $PSScriptRoot "..\UnicodeDB\dbo\Stored Procedures"
if (-not (Test-Path $root)) {
    # try relative to repository root
    $root = "c:\Users\Admin\source\repos\Unicode_ConversionDB\UnicodeDB\dbo\Stored Procedures"
}

Write-Host "Scanning: $root"

$files = Get-ChildItem -Path $root -Recurse -Filter *.sql -File
$changed = @()

# Regexes
$procStartRegex = '(?i)\b(CREATE|ALTER)\s+(PROCEDURE|PROC)\b'
$headerEndRegex = '(?i)\bAS\b|\bBEGIN\b'
$paramVarcharRegex = '(?i)(@\w+\s*)varchar\s*(\(\s*\d+\s*\)|\(\s*max\s*\))?'

foreach ($f in $files) {
    $text = Get-Content -Raw -LiteralPath $f.FullName -ErrorAction SilentlyContinue
    if (-not $text) { continue }

    $procMatch = [regex]::Match($text, $procStartRegex)
    if (-not $procMatch.Success) { continue }

    # find header area start
    $startIndex = $procMatch.Index

    # find first AS or BEGIN after startIndex
    $headerEndMatch = [regex]::Match($text.Substring($startIndex), $headerEndRegex)
    if (-not $headerEndMatch.Success) {
        # no AS/BEGIN found; skip file
        continue
    }

    $headerEndIndex = $startIndex + $headerEndMatch.Index
    $header = $text.Substring($startIndex, $headerEndIndex - $startIndex)

    $newHeader = [regex]::Replace($header, $paramVarcharRegex, '$1NVARCHAR(MAX)')

    if ($newHeader -ne $header) {
        # backup original
        $bakPath = $f.FullName + '.orig'
        if (-not (Test-Path $bakPath)) {
            Copy-Item -LiteralPath $f.FullName -Destination $bakPath -Force
        }

        $newText = $text.Substring(0, $startIndex) + $newHeader + $text.Substring($headerEndIndex)
        Set-Content -LiteralPath $f.FullName -Value $newText -Encoding UTF8
        $changed += $f.FullName
        Write-Host "Updated: $($f.FullName)"
    }
}

Write-Host "Done. Files changed: $($changed.Count)"
if ($changed.Count -gt 0) {
    $changed | Out-File -FilePath (Join-Path $PSScriptRoot "changed_files.txt") -Encoding UTF8
    Write-Host "List written to: $(Join-Path $PSScriptRoot 'changed_files.txt')"
}
else {
    Write-Host "No changes made."
}
