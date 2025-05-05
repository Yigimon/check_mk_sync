# Variablen
$downloadUrl     = "https://docs.checkmk.com/offline/docs.checkmk.com.zip"
$downloadPath    = "$env:USERPROFILE\Downloads\docs.checkmk.com.zip"
$extractPath     = "$env:USERPROFILE\Desktop\docs.checkmk.com"
$sourcePath      = Join-Path -Path $extractPath -ChildPath "docs.checkmk.com\latest\de"
$destinationPath = "C:\Users\yigithan.zeybel\Documents\GitHub\check_mk_sync\de_doc"
$imagesPath      = Join-Path -Path $destinationPath -ChildPath "images"

# Ordner vorbereiten
Write-Host "`n🔄 Entferne alte Dateien im Zielordner..." -ForegroundColor Cyan
Remove-Item -Path $destinationPath\* -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path $imagesPath\* -Recurse -Force -ErrorAction SilentlyContinue

# Zip herunterladen
Write-Host "⬇️ Lade aktuelle Dokumentation herunter..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadPath

# Entpacken
Write-Host "📦 Entpacke Archiv..." -ForegroundColor Cyan
Expand-Archive -Path $downloadPath -DestinationPath $extractPath -Force

# Markdown- und HTML-Dateien kopieren
Write-Host "📁 Kopiere deutsche Markdown- und HTML-Dateien..." -ForegroundColor Cyan
Copy-Item -Path "$sourcePath\*.md"   -Destination $destinationPath -Recurse
Copy-Item -Path "$sourcePath\*.html" -Destination $destinationPath -Recurse

# Bilder extrahieren und kopieren
Write-Host "🖼 Extrahiere und kopiere Bilder..." -ForegroundColor Cyan
$pattern = "<img.*?src=(['""])(.*?)\\1"
Get-ChildItem -Path "$destinationPath\*.html" | ForEach-Object {
    $htmlFile    = $_.FullName
    $htmlContent = Get-Content $htmlFile -Raw

    # Alle <img> tags finden
    [regex]::Matches($htmlContent, $pattern) | ForEach-Object {
        $imageUrl  = $_.Groups[2].Value
        $imageName = [IO.Path]::GetFileName($imageUrl)
        $destImage = Join-Path -Path $imagesPath -ChildPath $imageName

        if ($imageUrl -match '^https?://') {
            # Absoluter Pfad: herunterladen
            Write-Host "⬇️ Lade Bild herunter: $imageUrl" -ForegroundColor Cyan
            Invoke-WebRequest -Uri $imageUrl -OutFile $destImage
        } else {
            # Relativer Pfad: kopieren
            $sourceImage = Join-Path -Path $sourcePath -ChildPath $imageUrl
            Write-Host "📂 Kopiere Bild: $sourceImage" -ForegroundColor Cyan
            Copy-Item -Path $sourceImage -Destination $destImage -ErrorAction SilentlyContinue
        }

        # Bildpfad in HTML anpassen
        $htmlContent = $htmlContent -replace [Regex]::Escape($imageUrl), "./images/$imageName"
    }

    # Gespeichertes HTML zurückschreiben
    Set-Content -Path $htmlFile -Value $htmlContent -Encoding UTF8
}

# Markdown-Dateien formatieren
Write-Host "🖋 Formatiere Markdown-Dateien..." -ForegroundColor Cyan
Get-ChildItem -Path $destinationPath -Filter *.md | ForEach-Object {
    $file    = $_.FullName
    $content = Get-Content $file -Raw

    # Titel ermitteln
    if ($content -match '^# (.+)$') {
        $title = $matches[1]
    } else {
        $title = $_.BaseName
    }

    # Bildblock (wenn vorhanden)
    $imageName  = $_.BaseName + ".png"
    $imagePath  = "./images/$imageName"
    $imageBlock = Test-Path "$imagesPath\$imageName" ? "`n![$title]($imagePath)`n" : ""

    # Frontmatter + Header
    $header = @"
---
title:       $title
description: Dokumentation aus Checkmk
tags:        [checkmk, dokumentation]
---

# $title
$imageBlock
"@

    $newContent = $header + "`n---`n" + $content
    Set-Content -Path $file -Value $newContent -Encoding UTF8
    Write-Host "✅ Formatiert: $($_.Name)" -ForegroundColor Green
}

# Git Push
Write-Host "`n🚀 Pushe Änderungen nach GitHub..." -ForegroundColor Cyan
Push-Location $destinationPath
git add .
git commit -m "Sync: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
git push
Pop-Location

Write-Host "`n✅ Sync abgeschlossen!" -ForegroundColor Green
