# --- Configuration ---
$videoExtensions = @('.mkv', '.mp4', '.avi', '.m4v')
$metaExtensions = @('.nfo', '.srt')
# ---------------------

# Get all files in the current folder
$allFiles = Get-ChildItem -File

# Separate the video files and the metadata (non-video) files
$metaFiles = $allFiles | Where-Object { $_.Extension -in $metaExtensions }
$videoFiles = $allFiles | Where-Object { $_.Extension -in $videoExtensions }

# Create an empty list to store the files we plan to rename
$pendingRenames = @()

foreach ($meta in $metaFiles) {
    # Extract the episode number using Regex (Looks for S01E01, grabs the '01')
    if ($meta.BaseName -match 'S\d+E(\d+)') {
        $episodeNum = $Matches[1]
        
        # Find a video file that contains this exact episode number as a standalone word
        $matchingVideo = $videoFiles | Where-Object { $_.BaseName -match "\b$episodeNum\b" }
        
        if ($matchingVideo.Count -eq 1) {
            $vid = $matchingVideo[0]
            $newName = "$($meta.BaseName)$($vid.Extension)"
            
            Write-Host "[PREVIEW] Will rename: '$($vid.Name)' -> '$newName'" -ForegroundColor Cyan
            
            # Add the matched file and its intended new name to our pending list
            $pendingRenames += [PSCustomObject]@{
                TargetFile = $vid
                NewName    = $newName
            }
            
            # Remove the matched video from our search pool so it doesn't get matched again
            $videoFiles = $videoFiles | Where-Object { $_.FullName -ne $vid.FullName }
            
        } elseif ($matchingVideo.Count -gt 1) {
            Write-Host "Conflict: Multiple videos found for episode $episodeNum (Skipping)" -ForegroundColor Red
            $matchingVideo | ForEach-Object { Write-Host "   - $($_.Name)" -ForegroundColor Red }
        } else {
            Write-Host "Skipped: No matching video found for episode $episodeNum ($($meta.Name))" -ForegroundColor DarkGray
        }
    }
}

# Check if we actually found anything to rename
if ($pendingRenames.Count -gt 0) {
    # Ask the user for confirmation
    $choice = Read-Host "`nReady to rename $($pendingRenames.Count) files? (y/n)"
    
    if ($choice -eq 'y' -or $choice -eq 'Y' -or $choice -eq 'yes') {
        Write-Host "`nRenaming files..." -ForegroundColor Magenta
        
        # Loop through our pending list and execute the renames
        foreach ($item in $pendingRenames) {
            Rename-Item -LiteralPath $item.TargetFile.FullName -NewName $item.NewName
            Write-Host "Success: Renamed '$($item.TargetFile.Name)' -> '$($item.NewName)'" -ForegroundColor Green
        }
        
        Write-Host "`nAll done!" -ForegroundColor Green
    } else {
        # If the user typed 'n' or anything else
        Write-Host "`nOperation cancelled. No files were changed." -ForegroundColor Yellow
    }
} else {
    Write-Host "`nNo matches found to rename." -ForegroundColor Yellow
}

Write-Host "`n"
# This stops the window from closing until you press Enter
Pause