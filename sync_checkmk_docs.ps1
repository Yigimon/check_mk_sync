# === Konfiguration ===
$downloadUrl    = "https://docs.checkmk.com/offline/docs.checkmk.com.zip"
$zipPath        = "$env:TEMP\docs.checkmk.com.zip"
$extractTo      = "C:\Users\yigithan.zeybel\Desktop\docs.checkmk.com"
$htmlSource     = "C:\Users\yigithan.zeybel\Desktop\docs.checkmk.com\docs.checkmk.com\latest\de"
$mdTarget       = "C:\Users\yigithan.zeybel\Documents\GitHub\check_mk_sync\de_doc"
$pandocPath     = "pandoc"  # oder vollständiger Pfad, z.B. "C:\Program Files\Pandoc\pandoc.exe"

# === Schritt 1: Download ZIP ===
Write-Host "📥 Lade ZIP herunter..."
Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath -UseBasicParsing

# === Schritt 2: Entpacken (vorher löschen) ===
if (Test-Path $extractTo) {
    Write-Host "🧹 Entferne vorherige Entpackung..."
    Remove-Item -Path $extractTo -Recurse -Force
}
Write-Host "📦 Entpacke Archiv..."
Expand-Archive -Path $zipPath -DestinationPath $extractTo -Force
Remove-Item -Path $zipPath

# === Schritt 3: Markdown-Zielordner bereinigen (ohne .git) ===
Write-Host "🧼 Bereinige Markdown-Zielordner..."
Get-ChildItem -Path $mdTarget -Exclude ".git" -Recurse | Remove-Item -Force -Recurse

# === Schritt 4: HTML → Markdown konvertieren ===
Write-Host "🔁 Konvertiere HTML nach Markdown..."
Get-ChildItem -Path $htmlSource -Filter *.html | ForEach-Object {
    $htmlFile = $_.FullName
    $mdFile = Join-Path $mdTarget ($_.BaseName + ".md")

    & $pandocPath -f html -t markdown -o $mdFile $htmlFile

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Konvertiert: $($_.Name) → $($_.BaseName).md"
    } else {
        Write-Warning "⚠️ Fehler bei: $($_.Name)"
    }
}

# === Schritt 5: Git Commit & Push ===
Write-Host "🚀 Git Commit & Push..."
Set-Location $mdTarget
git add .
git commit -m "🔄 Auto-Update + Konvertierung: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git push

Write-Host "✅ Alles fertig und gepusht!"
