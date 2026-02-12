# YouTube Playlist Downloader - Windows Batch Script

**Download YouTube playlists, videos, and channels easily with a powerful Windows batch script that requires zero setup!**

A feature-rich, beginner-friendly batch script for downloading YouTube content with automatic tool installation, interactive folder selection, and intelligent resume capabilities.

## Features

- **Download Entire Playlists** - Save all videos from any YouTube playlist at once
- **Single Video Downloads** - Download individual videos by URL
- **Channel Downloads** - Download all videos from a YouTube channel
- **Auto-Install Dependencies** - Automatically installs yt-dlp and FFmpeg on first run
- **Smart Folder Organization** - Playlists automatically saved in folders with their names
- **Video + Audio** - Downloads video and audio together in MP4 format
- **Resume Downloads** - Continue interrupted downloads from where you left off
- **Update Tools** - Easy one-click updates for yt-dlp and FFmpeg
- **Interactive Menu** - User-friendly command-line interface
- **Efficient Storage** - Videos capped at 1080p to save disk space
- **Error Recovery** - Multiple download methods ensure success
- **Download Archive** - Tracks downloaded videos to avoid duplicates
- **Cookie Support** - Works with authentication for restricted content

---

## System Requirements

- **Windows 10/11** (7/8 may work with limitations)
- **Internet connection**
- **~500MB-1GB disk space** per hour of video
- **Administrator privileges** (for first-time tool installation)

---

## Quick Start (60 seconds)

### Step 1: Download
- Click **Code** → **Download ZIP**
- Extract the folder anywhere on your computer

### Step 2: Run
- **Double-click** `downloader.bat`
- Choose where to save videos (Desktop, Downloads, Custom, etc.)
- Script auto-installs tools (~2-5 minutes first run only)

---

## How to Use

### Download a YouTube Playlist
```
1. Run downloader.bat
2. choose download folder
3. Press 1 (Download Playlist or single video)
4. Paste YouTube playlist URL
5. Press Enter
6. When u use it for the first time after pasting link it may return to the 3 but no problem u can choose the same option again and download playlist
7. Videos auto-organize in playlist-named folder
```

**Example:**
```
Enter playlist URL: https://www.youtube.com/playlist?list=PLrAXtmErZgOeiKm4sgNOknGvNjby9efdf
Getting playlist info...
Playlist Name: My Music Collection
Starting download...
✓ 001 - Song 1.mp4
✓ 002 - Song 2.mp4
Download complete!
```

### Download a Single Video
```
1. Run downloader.bat
2. Press 2 (Download Single Video)
3. Paste video URL
4. Press Enter
5. Video saves to Single_Videos folder
```

### Resume Interrupted Downloads
```
1. Run downloader.bat
2. Press 3 (Resume Download)
3. Select the playlist folder
4. Paste playlist URL again
5. Script resumes from where it stopped
```

### Change Download Folder
```
1. From main menu, press 4
2. Choose new location (Desktop, Downloads, etc.)
3. Continue downloading to new location
```

---

## How Videos Are Organized

```
C:\Users\YourUsername\Downloads\YouTubeDownloads\
├── Playlist Name 1\
│   ├── 001 - Video 1.mp4
│   ├── 002 - Video 2.mp4
│   └── 003 - Video 3.mp4
├── Playlist Name 2\
│   └── 001 - Another Video.mp4
└── Single_Videos\
    └── Single Downloaded Video.mp4
```

---

## Configuration

Most settings work automatically, but you can customize:

```batch
REM In downloader.bat, find these lines to modify:

REM Video quality (1080p = 1080, 720p = 720, 4K = 2160)
-f "bestvideo[height<=1080]..."

REM Add cookies for age-restricted videos
set "COOKIE_PATH=C:\path\to\cookies.txt"
```

---

## Troubleshooting

### "Access Denied" or "Permission Error"
**Solution:**
- Right-click `downloader.bat` → "Run as Administrator"
- OR choose a different download folder (option 4 in menu)

### "yt-dlp not found" or "ffmpeg not found"
**Solution:**
- Go to menu → Option 5 (Update Tools)
- Choose 3 (Reinstall both)
- Wait for installation
- Restart the script

### Download returns to menu instead of retrying
**Solution:**
- Type `back` to exit OR try a different URL
- Script now lets you retry without returning to main menu!

### Video has no audio
**Solution:**
- FFmpeg didn't install correctly
- Go to Option 5 → 2 (Reinstall ffmpeg)
- Restart script

### "Invalid YouTube URL" error
**Solution:**
- Make sure URL is correct (starts with `https://youtube.com`)
- Try copying URL directly from browser address bar
- Check internet connection
- Try downloading a different video first

### Download is very slow
**Solution:**
- Check your internet connection
- Some videos have server rate limits
- Try again later
- Script automatically retries up to 10 times

---

## Video Quality & Format

**Default Settings:**
- **Video Quality:** Up to 1080p (MP4 format)
- **Audio Quality:** Best available
- **File Size:** ~500MB-1GB per hour of video

**To Change Quality:**
Edit the script line:
```batch
-f "bestvideo[height<=1080]..."
```

**Quality Options:**
- `height<=480` → 480p (smallest, ~200MB/hour)
- `height<=720` → 720p (medium, ~500MB/hour)
- `height<=1080` → 1080p (default, ~700MB/hour)
- `height<=2160` → 4K (large, ~2GB/hour)

---

## Download Age-Restricted Videos

For videos that require age verification:

1. **Export cookies from your browser:**
   - Install a cookie exporter extension
   - Export as `.txt` file format
   - Save as `cookies.txt`

2. **Tell the script where to find cookies:**
   - Edit `downloader.bat`
   - Find: `set "COOKIE_PATH="`
   - Change to: `set "COOKIE_PATH=C:\path\to\cookies.txt"`

3. **Download normally** - Script will use your cookies

---

## What Gets Installed?

On first run, the script automatically installs:

| Tool | Size | Purpose |
|------|------|---------|
| **yt-dlp** | 10MB | Downloads YouTube videos |
| **FFmpeg** | ~200MB | Combines video + audio |
| **Total** | ~210MB | One-time download |

*Located in `\tools\` folder inside script directory*

---

## Supported Platforms

| Platform | Status |
|----------|--------|
| Windows 10/11 | Full Support |
| Windows 8/7 | Partial Support |
| Mac | Not Supported |
| Linux | Not Supported |

---

## 🔗 Works With

- YouTube.com (videos, playlists, channels)
- YouTube Shorts
- Age-restricted videos (with cookies)
- Private videos (if you have access)
- Live streams (depending on availability)

---

## Important Disclaimer

**This tool is for personal use only.**

- Download content you have permission to download
- Respect copyright laws and YouTube Terms of Service
- Support creators when possible
- Use downloaded content for personal viewing only
- Don't redistribute copyrighted content
- Don't use for commercial purposes without permission

**YouTube's Terms of Service** may prohibit automated downloading. Use responsibly and at your own risk.

---

## Report Issues

Having problems?

1. **Check Troubleshooting section** above
2. **Note the exact error message**
3. **Open a GitHub Issue** with:
   - Error message
   - Steps you took
   - Windows version
   - Downloaded URL (if possible)

---

## License

This project is provided as-is for educational and personal use.

---

## Credits & Dependencies

- **yt-dlp** - YouTube downloader engine
  - GitHub: https://github.com/yt-dlp/yt-dlp
  - License: Unlicense

- **FFmpeg** - Audio/video processing
  - Website: https://ffmpeg.org
  - License: LGPL/GPL

---

## Quick Links

- [Full Documentation](#-how-to-use)
- [Troubleshooting](#-troubleshooting)
- [Configuration](#%EF%B8%8F-configuration)
- [Disclaimer](#%EF%B8%8F-important-disclaimer)

---

## Features Roadmap

- [ ] Support for other video platforms (Vimeo, etc.)
- [ ] GUI version (non-batch)
- [ ] Audio-only download option
- [ ] Subtitle downloading
- [ ] Download history tracking
- [ ] Scheduled downloads

---

## Contributing

Contributions welcome! Feel free to:
- Report bugs
- Suggest improvements
- Submit pull requests
- Improve documentation

---

## Questions?

- Check [Troubleshooting](#-troubleshooting) first
- Open a GitHub Issue
- Read the documentation carefully

---

**Last Updated:** February 12, 2026

*Happy downloading!*
