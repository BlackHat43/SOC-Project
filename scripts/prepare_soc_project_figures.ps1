# prepare_soc_project_figures.ps1
# Purpose:
#   Organize the 74 numbered screenshots for the SOC project.
#   - Creates docs\figures with the 39 report figures named fig01..fig39.
#   - Marks the 31 strongest/core evidence images.
#   - Separates the 8 supporting images.
#   - Copies excluded and sensitive-review copies OUTSIDE the project folder
#     so they are not accidentally submitted.
#
# How to run:
#   1) Save this file as:
#      C:\Users\Rami\Desktop\SOC-Project\scripts\prepare_soc_project_figures.ps1
#   2) Open PowerShell as normal user.
#   3) Run:
#      Set-ExecutionPolicy -Scope Process Bypass -Force
#      cd C:\Users\Rami\Desktop\SOC-Project
#      .\scripts\prepare_soc_project_figures.ps1

$ErrorActionPreference = "Stop"

# =========================
# 1) Paths
# =========================
$ProjectRoot   = "C:\Users\Rami\Desktop\SOC-Project"
$DownloadsRoot = "C:\Users\Rami\Downloads"
$PreferredPic  = Join-Path $DownloadsRoot "pic"

# Final clean project output
$DocsDir       = Join-Path $ProjectRoot "docs"
$FiguresDir    = Join-Path $DocsDir "figures"
$ManifestDir   = Join-Path $DocsDir "manifests"

# Private area OUTSIDE the project folder. Do NOT upload this.
$PrivateRoot   = "C:\Users\Rami\Desktop\SOC-Project_PRIVATE_DO_NOT_UPLOAD"
$RawAllDir     = Join-Path $PrivateRoot "raw_all_numbered_1_to_74"
$ExcludedDir   = Join-Path $PrivateRoot "excluded_not_for_submission"
$RedactionDir  = Join-Path $PrivateRoot "redaction_review_before_upload"
$BackupDir     = Join-Path $PrivateRoot ("old_figures_backup_" + (Get-Date -Format "yyyyMMdd_HHmmss"))

# =========================
# 2) Safety checks
# =========================
if (-not (Test-Path $ProjectRoot)) {
    throw "Project folder not found: $ProjectRoot"
}
if (-not (Test-Path $DownloadsRoot)) {
    throw "Downloads folder not found: $DownloadsRoot"
}

New-Item -ItemType Directory -Path $DocsDir, $ManifestDir, $PrivateRoot, $RawAllDir, $ExcludedDir, $RedactionDir -Force | Out-Null

# Backup old docs\figures if it already has files
if (Test-Path $FiguresDir) {
    $oldFiles = Get-ChildItem -Path $FiguresDir -File -ErrorAction SilentlyContinue
    if ($oldFiles.Count -gt 0) {
        New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
        Copy-Item -Path (Join-Path $FiguresDir "*") -Destination $BackupDir -Recurse -Force
        Write-Host "[BACKUP] Existing docs\figures copied to: $BackupDir"
    }
    Remove-Item -Path $FiguresDir -Recurse -Force
}
New-Item -ItemType Directory -Path $FiguresDir -Force | Out-Null

# =========================
# 3) Figure map: 39 report figures
# =========================
# These names match the final report figure order.
$FigureMap = [ordered]@{
  "1"  = "fig01_architecture"
  "2"  = "fig02_workflow"

  "38" = "fig03_wazuh_install"
  "39" = "fig04_wazuh_credentials"
  "40" = "fig05_wazuh_dashboard_empty"

  "6"  = "fig06_kali_agent_first"
  "42" = "fig07_aws_rules_5"
  "43" = "fig08_wazuh_overview_active"
  "44" = "fig09_wazuh_endpoints_kali"
  "10" = "fig10_kali_agent_reboot"

  "11" = "fig11_fim_file_creation"
  "12" = "fig12_fim_modify_delete"
  "66" = "fig13_wazuh_fim_3hits"

  "67" = "fig14_docker_version"
  "68" = "fig15_aws_rules_8"
  "69" = "fig16_docker_compose_ports"
  "70" = "fig17_docker_compose_ps"

  "71" = "fig18_thehive_home"
  "72" = "fig19_thehive_org_admin"
  "73" = "fig20_thehive_user"
  "74" = "fig21_thehive_case_create"
  "48" = "fig22_thehive_case_success"
  "49" = "fig23_thehive_observables"
  "50" = "fig24_thehive_tasks"

  "51" = "fig25_cortex_org_initial"
  "52" = "fig26_cortex_soclab_user"
  "53" = "fig27_cortex_analyzers_0"
  "54" = "fig28_cortex_unshorten_enabled"
  "55" = "fig29_cortex_jobs_history"
  "56" = "fig30_cortex_job_details"

  "57" = "fig31_thehive_comment_cortex"
  "58" = "fig32_thehive_both_comments"

  "59" = "fig33_backup_script_output"
  "60" = "fig34_sha256_ok"
  "61" = "fig35_restore_file_list"
  "62" = "fig36_final_sha256_ok"

  "63" = "fig37_autopsy_filetree"
  "64" = "fig38_autopsy_keyword"
  "65" = "fig39_autopsy_report"
}

# 31 strongest evidence screenshots
$Core31 = @(
  "1","2",
  "38","39","40",
  "6","43","44","10",
  "11","12","66",
  "67","69","70",
  "74","48","49","50",
  "54","55","56",
  "57","58",
  "59","60","61","62",
  "63","64","65"
)

# 8 supporting screenshots: useful for complete report, but not the strongest proof
$Supporting8 = @("42","68","71","72","73","51","52","53")

# Screens that likely include IPs, URLs, credentials, browser bars, usernames, or infrastructure data.
# These are copied to a review folder so you know what to blur before public upload.
$NeedsRedactionReview = @(
  "39","40","42","43","44","68",
  "71","72","73","74","48","49","50",
  "51","52","53","54","55","56","57","58",
  "59","60","61","62"
)

# =========================
# 4) Find source images
# =========================
$AllowedExt = @(".png",".jpg",".jpeg",".webp")
$ImageIndex = @{}

function Add-Image-ToIndex {
    param(
        [System.IO.FileInfo]$File
    )
    $base = $File.BaseName
    $ext  = $File.Extension.ToLowerInvariant()

    if ($base -match '^\d+$' -and $AllowedExt -contains $ext) {
        $n = [int]$base
        if ($n -ge 1 -and $n -le 74) {
            if (-not $ImageIndex.ContainsKey($base)) {
                $ImageIndex[$base] = $File.FullName
            }
        }
    }
}

# Priority 1: C:\Users\Rami\Downloads\pic, if it exists
if (Test-Path $PreferredPic) {
    Get-ChildItem -Path $PreferredPic -File -ErrorAction SilentlyContinue | ForEach-Object { Add-Image-ToIndex $_ }
}

# Priority 2: Directly inside Downloads
Get-ChildItem -Path $DownloadsRoot -File -ErrorAction SilentlyContinue | ForEach-Object { Add-Image-ToIndex $_ }

# Priority 3: Recursive fallback inside Downloads, only if some numbers are missing
$missingBeforeRecursive = @()
foreach ($i in 1..74) {
    if (-not $ImageIndex.ContainsKey([string]$i)) {
        $missingBeforeRecursive += [string]$i
    }
}
if ($missingBeforeRecursive.Count -gt 0) {
    Write-Host "[SCAN] Some images were not found directly. Searching inside Downloads subfolders..."
    Get-ChildItem -Path $DownloadsRoot -File -Recurse -ErrorAction SilentlyContinue |
        Where-Object { $_.BaseName -match '^\d+$' -and $AllowedExt -contains $_.Extension.ToLowerInvariant() } |
        ForEach-Object { Add-Image-ToIndex $_ }
}

# =========================
# 5) Copy 39 final report figures
# =========================
$Rows = New-Object System.Collections.Generic.List[object]
$Missing = New-Object System.Collections.Generic.List[string]

foreach ($num in $FigureMap.Keys) {
    $figureName = $FigureMap[$num]

    if ($ImageIndex.ContainsKey($num)) {
        $src = $ImageIndex[$num]
        $dest = Join-Path $FiguresDir ($figureName + ".png")
        Copy-Item -Path $src -Destination $dest -Force

        $category = if ($Core31 -contains $num) { "CORE_31_STRONG_EVIDENCE" } elseif ($Supporting8 -contains $num) { "SUPPORTING_8_REPORT_COMPLETION" } else { "REPORT_FIGURE" }
        $redact = if ($NeedsRedactionReview -contains $num) { "YES" } else { "NO" }

        $Rows.Add([pscustomobject]@{
            OriginalNumber = $num
            FigureFile     = ($figureName + ".png")
            Category       = $category
            InFinal39      = "YES"
            RedactionReview= $redact
            SourcePath     = $src
            OutputPath     = $dest
        }) | Out-Null
    }
    else {
        $Missing.Add($num) | Out-Null
        $Rows.Add([pscustomobject]@{
            OriginalNumber = $num
            FigureFile     = ($figureName + ".png")
            Category       = "MISSING_REPORT_FIGURE"
            InFinal39      = "YES"
            RedactionReview= if ($NeedsRedactionReview -contains $num) { "YES" } else { "NO" }
            SourcePath     = "NOT_FOUND"
            OutputPath     = "NOT_CREATED"
        }) | Out-Null
    }
}

# =========================
# 6) Copy raw 1-74 and excluded images to PRIVATE folder outside the project
# =========================
$Final39Nums = @($FigureMap.Keys)

foreach ($i in 1..74) {
    $num = [string]$i

    if ($ImageIndex.ContainsKey($num)) {
        $src = $ImageIndex[$num]
        $rawDest = Join-Path $RawAllDir ("raw_{0:D2}.png" -f $i)
        Copy-Item -Path $src -Destination $rawDest -Force

        if (-not ($Final39Nums -contains $num)) {
            $excludedDest = Join-Path $ExcludedDir ("excluded_{0:D2}.png" -f $i)
            Copy-Item -Path $src -Destination $excludedDest -Force

            $Rows.Add([pscustomobject]@{
                OriginalNumber = $num
                FigureFile     = ("excluded_{0:D2}.png" -f $i)
                Category       = "EXCLUDED_NOT_FOR_FINAL_SUBMISSION"
                InFinal39      = "NO"
                RedactionReview= if ($NeedsRedactionReview -contains $num) { "YES" } else { "NO" }
                SourcePath     = $src
                OutputPath     = $excludedDest
            }) | Out-Null
        }

        if ($NeedsRedactionReview -contains $num) {
            $redDest = Join-Path $RedactionDir ("review_{0:D2}.png" -f $i)
            Copy-Item -Path $src -Destination $redDest -Force
        }
    }
    else {
        $Rows.Add([pscustomobject]@{
            OriginalNumber = $num
            FigureFile     = ("raw_{0:D2}.png" -f $i)
            Category       = "MISSING_ORIGINAL"
            InFinal39      = if ($Final39Nums -contains $num) { "YES" } else { "NO" }
            RedactionReview= if ($NeedsRedactionReview -contains $num) { "YES" } else { "NO" }
            SourcePath     = "NOT_FOUND"
            OutputPath     = "NOT_CREATED"
        }) | Out-Null
    }
}

# =========================
# 7) Write manifest files
# =========================
$CsvPath = Join-Path $ManifestDir "figure_manifest.csv"
$MdPath  = Join-Path $ManifestDir "figure_manifest.md"

$Rows |
    Sort-Object {[int]$_.OriginalNumber}, Category |
    Export-Csv -Path $CsvPath -NoTypeInformation -Encoding UTF8

$createdFinal = (Get-ChildItem -Path $FiguresDir -File -Filter "fig*.png" -ErrorAction SilentlyContinue).Count
$coreCreated  = ($Rows | Where-Object { $_.Category -eq "CORE_31_STRONG_EVIDENCE" -and $_.OutputPath -ne "NOT_CREATED" }).Count
$suppCreated  = ($Rows | Where-Object { $_.Category -eq "SUPPORTING_8_REPORT_COMPLETION" -and $_.OutputPath -ne "NOT_CREATED" }).Count
$excludedCreated = (Get-ChildItem -Path $ExcludedDir -File -ErrorAction SilentlyContinue).Count
$redactionCreated = (Get-ChildItem -Path $RedactionDir -File -ErrorAction SilentlyContinue).Count

$md = @"
# SOC Project Figure Manifest

## Final decision

- Final report figures copied to: ``docs\figures``
- Expected final report figures: **39**
- Strong/core evidence among them: **31**
- Supporting/report-completion images among them: **8**
- Excluded raw images are outside the project folder: ``$PrivateRoot``

## Counts from this run

| Item | Count |
|---|---:|
| Final figures created in docs\figures | $createdFinal |
| Core evidence created | $coreCreated |
| Supporting evidence created | $suppCreated |
| Excluded images copied to private folder | $excludedCreated |
| Images copied for redaction review | $redactionCreated |

## Core 31 evidence numbers

``$($Core31 -join ", ")``

## Supporting 8 evidence numbers

``$($Supporting8 -join ", ")``

## Missing report figure numbers

``$($Missing -join ", ")``

## Important upload warning

Before public upload, review the folder:

``$RedactionDir``

Blur or hide anything sensitive such as public IPs, credentials, tokens, dashboard URLs, AWS details, or generated access information.

Do **not** upload:

``$PrivateRoot``

Use only:

``$FiguresDir``

and the project documents/scripts/configs needed for submission.
"@

Set-Content -Path $MdPath -Value $md -Encoding UTF8

# Optional: create/update a local gitignore to avoid common accidental folders if using Git
$GitIgnorePath = Join-Path $ProjectRoot ".gitignore"
$ignoreLines = @(
    "",
    "# Local/private screenshot material - do not submit",
    "docs/raw_screenshots/",
    "raw_screenshots/",
    "*PRIVATE_DO_NOT_UPLOAD*/",
    "*.tmp"
)
if (Test-Path $GitIgnorePath) {
    $existing = Get-Content $GitIgnorePath -ErrorAction SilentlyContinue
    foreach ($line in $ignoreLines) {
        if ($existing -notcontains $line) {
            Add-Content -Path $GitIgnorePath -Value $line
        }
    }
}
else {
    Set-Content -Path $GitIgnorePath -Value ($ignoreLines -join [Environment]::NewLine) -Encoding UTF8
}

# =========================
# 8) Final output
# =========================
Write-Host ""
Write-Host "==============================================="
Write-Host "SOC FIGURE ORGANIZATION COMPLETE"
Write-Host "==============================================="
Write-Host "Project root:          $ProjectRoot"
Write-Host "Source priority:       $PreferredPic then $DownloadsRoot"
Write-Host "Final 39 figures:      $FiguresDir"
Write-Host "Manifest CSV:          $CsvPath"
Write-Host "Manifest MD:           $MdPath"
Write-Host "Private raw/excluded:  $PrivateRoot"
Write-Host ""
Write-Host "Created final figures: $createdFinal / 39"
Write-Host "Core evidence:         $coreCreated / 31"
Write-Host "Supporting evidence:   $suppCreated / 8"
Write-Host "Excluded copied:       $excludedCreated"
Write-Host "Redaction review:      $redactionCreated"
Write-Host ""

if ($Missing.Count -gt 0) {
    Write-Host "[WARNING] Missing report images:" -ForegroundColor Yellow
    Write-Host ($Missing -join ", ") -ForegroundColor Yellow
    Write-Host "Check whether the files are named 1.png ... 74.png and located in Downloads or Downloads\pic."
}
else {
    Write-Host "[OK] No missing report figures." -ForegroundColor Green
}

Write-Host ""
Write-Host "NEXT STEP:"
Write-Host "Open docs\figures and check the 39 files."
Write-Host "Then review the redaction folder before uploading anything public:"
Write-Host $RedactionDir
