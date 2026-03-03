# One Pace Episode Renamer for Plex/Jellyfin

A PowerShell script designed to quickly rename pre-existing One Pace episodes in your Jellyfin or Plex library according to the custom metadata provided by [opforjellyfin](https://github.com/joshb616/opforjellyfin) (which uses metadata from[SpykerNZ/one-pace-for-plex](https://github.com/SpykerNZ/one-pace-for-plex)).

I wrote this script as an exercise to avoid having to redownload all my One Pace episodes or rename them manually, especially after I couldn't get Filebot to detect and name One Pace episodes correctly. 

## 🌟 How It Works

The script looks for metadata files (like `.nfo`) containing the `S##E##` format. It then scans the video files in the same folder, matching them solely by the episode number found in their filenames. 

I can confirm that this logic successfully matches and works for **all One Pace episode names**.

**Before:**
```text
One Pace - S02E01 - Enter Nami.nfo
Orange Town 01 [1080p][8-11].mkv
```

**After running the script:**
```text
One Pace - S02E01 - Enter Nami.nfo
One Pace - S02E01 - Enter Nami.mkv
```

## ✨ Features

- **Interactive Preview (Dry Run)**: Never guess what the script will do. It displays a preview of all intended name changes and waits for you to type `y` to confirm before altering any files.
- **Already Correct Detection**: Automatically detects if files were already renamed in a previous run and safely skips them.
- **Conflict Prevention**: If multiple videos match the same episode number (e.g., if you mix seasons in the same folder), the script flags a conflict and skips them to protect your files.
- **Bracket Safe**: Safely handles the complex release names and square brackets typical of One Pace releases (e.g., `[1080p][8-11]`).

## 🚀 Usage

1. Copy the `Rename-Episodes.ps1` script into the specific season folder containing your One Pace videos and `.nfo` metadata files. *(Note: Process one season folder at a time to avoid episode number conflicts).*
2. Right-click the `Rename-Episodes.ps1` file and select **Run with PowerShell**.
3. Review the terminal output. It will show you exactly what will be renamed in Cyan text.
4. When prompted `Ready to rename X files? (y/n)`, type `y` and press **Enter** to apply the changes.
5. Press **Enter** again to close the window when finished.

## ⚙️ Configuration

By default, the script looks for `.mkv`, `.mp4`, `.avi`, and `.m4v` for video files, and `.nfo` and `.srt` for metadata. You can easily edit the top of the `.ps1` file in any text editor to add or remove file extensions:

```powershell
# --- Configuration ---
$videoExtensions = @('.mkv', '.mp4', '.avi', '.m4v')
$metaExtensions = @('.nfo', '.srt')
# ---------------------
```

## ⚠️ Troubleshooting

**"Execution of scripts is disabled on this system."**
By default, Windows restricts running custom PowerShell scripts. If the script flashes and closes immediately, or gives an execution policy error, you need to allow it to run:
1. Open PowerShell as Administrator.
2. Run the following command: `Set-ExecutionPolicy RemoteSigned`
3. Press `Y` to confirm. You can now run the script properly.
