@echo off
setlocal EnableDelayedExpansion
title YouTube Downloader - Auto Setup

REM =============================================
REM CONFIGURATION
REM =============================================
set "COOKIE_PATH="
set "MAIN_FOLDER="
set "TOOLS_FOLDER=%~dp0tools"

set "YTDLP=%TOOLS_FOLDER%\yt-dlp.exe"
set "FFMPEG_PATH=%TOOLS_FOLDER%\ffmpeg"

set "YTDLP_URL=https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
set "FFMPEG_URL=https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip"

REM =============================================
REM STARTUP
REM =============================================
:STARTUP
cls
echo.
echo ==============================================
echo      YOUTUBE DOWNLOADER - STARTING
echo ==============================================
echo.

if not exist "%TOOLS_FOLDER%" mkdir "%TOOLS_FOLDER%" 2>nul

REM Check if download folder is set
if "!MAIN_FOLDER!"=="" (
    call :SETUP_FOLDER
)

set "NEED_YTDLP=0"
set "NEED_FFMPEG=0"

if not exist "%YTDLP%" (
    echo [!] yt-dlp not found
    set "NEED_YTDLP=1"
) else (
    echo [OK] yt-dlp found
)

if not exist "%FFMPEG_PATH%\ffmpeg.exe" (
    echo [!] ffmpeg not found
    set "NEED_FFMPEG=1"
) else (
    echo [OK] ffmpeg found
)

echo.

if "%NEED_YTDLP%"=="1" (
    call :DOWNLOAD_YTDLP
)

if "%NEED_FFMPEG%"=="1" (
    call :DOWNLOAD_FFMPEG
)

REM Final check
if not exist "%YTDLP%" goto MANUAL_DOWNLOAD
if not exist "%FFMPEG_PATH%\ffmpeg.exe" goto MANUAL_DOWNLOAD

if not exist "%MAIN_FOLDER%" mkdir "%MAIN_FOLDER%" 2>nul

echo.
echo [OK] All tools ready!
timeout /t 2 >nul
goto MAIN_MENU

REM =============================================
REM SETUP FOLDER - LET USER CHOOSE
REM =============================================
:SETUP_FOLDER
cls
echo.
echo ==============================================
echo      CHOOSE DOWNLOAD FOLDER
echo ==============================================
echo.
echo Where do you want to save your videos?
echo.
echo   1. Desktop
echo   2. Downloads folder (Recommended)
echo   3. Documents folder
echo   4. Custom location (enter path manually)
echo   5. External Drive (D:, E:, etc.)
echo.
echo ==============================================
echo.

set "folder_choice="
set /p "folder_choice=Enter your choice (1-5): "

if "%folder_choice%"=="1" (
    set "MAIN_FOLDER=%USERPROFILE%\Desktop\YouTubeDownloads"
    goto :eof
)
if "%folder_choice%"=="2" (
    set "MAIN_FOLDER=%USERPROFILE%\Downloads\YouTubeDownloads"
    goto :eof
)
if "%folder_choice%"=="3" (
    set "MAIN_FOLDER=%USERPROFILE%\Documents\YouTubeDownloads"
    goto :eof
)
if "%folder_choice%"=="4" (
    echo.
    echo Enter the full path where you want to save videos:
    echo Example: D:\MyVideos
    echo.
    set /p "MAIN_FOLDER=Path: "
    
    REM Clean up trailing backslash if present
    if "!MAIN_FOLDER:~-1!"=="\" set "MAIN_FOLDER=!MAIN_FOLDER:~0,-1!"
    
    if "!MAIN_FOLDER!"=="" (
        echo Invalid path. Using Downloads folder instead.
        set "MAIN_FOLDER=%USERPROFILE%\Downloads\YouTubeDownloads"
    ) else (
        echo.
        echo You chose: !MAIN_FOLDER!
        pause
    )
    goto :eof
)
if "%folder_choice%"=="5" (
    cls
    echo.
    echo ==============================================
    echo      AVAILABLE DRIVES
    echo ==============================================
    echo.
    echo Available drives on your computer:
    echo.
    
    for /f "tokens=1" %%A in ('wmic logicaldisk get name ^| findstr ":"') do (
        echo   - %%A
    )
    
    echo.
    echo Enter the drive letter (example: D, E, F):
    set /p "drive_letter=Drive letter: "
    
    if "!drive_letter!"=="" (
        echo Invalid choice. Using Downloads folder instead.
        set "MAIN_FOLDER=%USERPROFILE%\Downloads\YouTubeDownloads"
    ) else (
        set "MAIN_FOLDER=!drive_letter!:\YouTubeDownloads"
        echo.
        echo You chose: !MAIN_FOLDER!
        pause
    )
    goto :eof
)

echo Invalid choice. Using Downloads folder (default).
set "MAIN_FOLDER=%USERPROFILE%\Downloads\YouTubeDownloads"
goto :eof

REM =============================================
REM MANUAL DOWNLOAD INSTRUCTIONS
REM =============================================
:MANUAL_DOWNLOAD
cls
echo.
echo ==============================================
echo     AUTOMATIC DOWNLOAD FAILED
echo ==============================================
echo.
echo Please download the files manually:
echo.
echo -----------------------------------------------
echo STEP 1: Download yt-dlp
echo -----------------------------------------------
echo.
echo   URL: %YTDLP_URL%
echo.
echo   Save it to: %YTDLP%
echo.
echo -----------------------------------------------
echo STEP 2: Download ffmpeg
echo -----------------------------------------------
echo.
echo   URL: %FFMPEG_URL%
echo.
echo   1. Download the ZIP file
echo   2. Extract it
echo   3. Inside you'll find: ffmpeg-X.X-essentials_build\bin\
echo   4. Copy ffmpeg.exe to: %FFMPEG_PATH%\
echo.
echo -----------------------------------------------
echo.
echo After downloading, press any key to continue...
echo Or close this window and run the script again.
echo.
pause

REM Check again
if exist "%YTDLP%" (
    if exist "%FFMPEG_PATH%\ffmpeg.exe" (
        goto MAIN_MENU
    )
)

echo.
echo [!] Files still not found.
echo.
echo Would you like to:
echo   1. Open download URLs in browser
echo   2. Open tools folder
echo   3. Try again
echo   4. Continue anyway (downloads may not work properly)
echo.

set "dlchoice="
set /p "dlchoice=Choice: "

if "%dlchoice%"=="1" (
    start "" "%YTDLP_URL%"
    start "" "https://www.gyan.dev/ffmpeg/builds/"
    echo.
    echo Browser opened. Download the files and try again.
    pause
    goto MANUAL_DOWNLOAD
)
if "%dlchoice%"=="2" (
    if not exist "%TOOLS_FOLDER%" mkdir "%TOOLS_FOLDER%" 2>nul
    if not exist "%FFMPEG_PATH%" mkdir "%FFMPEG_PATH%" 2>nul
    explorer "%TOOLS_FOLDER%"
    echo.
    echo Folder opened. Place the files there and try again.
    pause
    goto MANUAL_DOWNLOAD
)
if "%dlchoice%"=="3" goto STARTUP
if "%dlchoice%"=="4" goto MAIN_MENU

goto MANUAL_DOWNLOAD

REM =============================================
REM DOWNLOAD FILE - TRIES MULTIPLE METHODS
REM =============================================
:DOWNLOAD_FILE
REM Parameters: %1 = URL, %2 = Output file
set "DL_URL=%~1"
set "DL_OUT=%~2"
set "DL_OK=0"

echo.
echo Downloading: %DL_URL%
echo To: %DL_OUT%
echo.

REM Method 1: curl (Windows 10+)
echo Trying curl...
curl --help >nul 2>nul
if not errorlevel 1 (
    curl -L -o "%DL_OUT%" "%DL_URL%" --progress-bar
    if exist "%DL_OUT%" (
        echo [OK] Downloaded with curl
        set "DL_OK=1"
        goto :eof
    )
)

REM Method 2: PowerShell with full path
echo Trying PowerShell...
if exist "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" (
    "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%DL_URL%' -OutFile '%DL_OUT%' -UseBasicParsing"
    if exist "%DL_OUT%" (
        echo [OK] Downloaded with PowerShell
        set "DL_OK=1"
        goto :eof
    )
)

REM Method 3: bitsadmin
echo Trying bitsadmin...
bitsadmin /transfer "DownloadJob" /download /priority high "%DL_URL%" "%DL_OUT%" >nul 2>nul
if exist "%DL_OUT%" (
    echo [OK] Downloaded with bitsadmin
    set "DL_OK=1"
    goto :eof
)

REM Method 4: certutil
echo Trying certutil...
certutil -urlcache -split -f "%DL_URL%" "%DL_OUT%" >nul 2>nul
if exist "%DL_OUT%" (
    echo [OK] Downloaded with certutil
    set "DL_OK=1"
    goto :eof
)

echo [FAILED] All download methods failed.
goto :eof

REM =============================================
REM DOWNLOAD YT-DLP
REM =============================================
:DOWNLOAD_YTDLP
echo.
echo ==============================================
echo Downloading yt-dlp...
echo ==============================================

call :DOWNLOAD_FILE "%YTDLP_URL%" "%YTDLP%"

if exist "%YTDLP%" (
    echo.
    echo [OK] yt-dlp downloaded!
) else (
    echo.
    echo [ERROR] Could not download yt-dlp
)
goto :eof

REM =============================================
REM DOWNLOAD FFMPEG
REM =============================================
:DOWNLOAD_FFMPEG
echo.
echo ==============================================
echo Downloading ffmpeg (this may take a few minutes)...
echo ==============================================

set "FFMPEG_ZIP=%TOOLS_FOLDER%\ffmpeg.zip"

call :DOWNLOAD_FILE "%FFMPEG_URL%" "%FFMPEG_ZIP%"

if not exist "%FFMPEG_ZIP%" (
    echo [ERROR] Could not download ffmpeg
    goto :eof
)

echo.
echo Download complete. Extracting...

if not exist "%FFMPEG_PATH%" mkdir "%FFMPEG_PATH%" 2>nul

REM Try to extract
set "EXTRACT_OK=0"

REM Method 1: PowerShell extraction
if exist "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" (
    echo Extracting with PowerShell...
    "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -Command "Expand-Archive -Path '%FFMPEG_ZIP%' -DestinationPath '%TOOLS_FOLDER%\fftemp' -Force" 2>nul
    if exist "%TOOLS_FOLDER%\fftemp" set "EXTRACT_OK=1"
)

REM Method 2: tar (Windows 10 1803+)
if "%EXTRACT_OK%"=="0" (
    echo Extracting with tar...
    tar -xf "%FFMPEG_ZIP%" -C "%TOOLS_FOLDER%\fftemp" 2>nul
    if exist "%TOOLS_FOLDER%\fftemp" set "EXTRACT_OK=1"
)

if "%EXTRACT_OK%"=="0" (
    echo.
    echo [ERROR] Could not extract ffmpeg.
    echo.
    echo Please extract manually:
    echo   1. Open: %FFMPEG_ZIP%
    echo   2. Extract to: %TOOLS_FOLDER%
    echo   3. Copy ffmpeg.exe to: %FFMPEG_PATH%\
    goto :eof
)

REM Find and copy ffmpeg.exe
echo Copying ffmpeg files...
for /r "%TOOLS_FOLDER%\fftemp" %%f in (ffmpeg.exe) do (
    copy "%%f" "%FFMPEG_PATH%\" >nul 2>nul
)
for /r "%TOOLS_FOLDER%\fftemp" %%f in (ffprobe.exe) do (
    copy "%%f" "%FFMPEG_PATH%\" >nul 2>nul
)

REM Cleanup
echo Cleaning up...
rmdir /s /q "%TOOLS_FOLDER%\fftemp" 2>nul
del "%FFMPEG_ZIP%" 2>nul

if exist "%FFMPEG_PATH%\ffmpeg.exe" (
    echo.
    echo [OK] ffmpeg installed!
) else (
    echo.
    echo [ERROR] ffmpeg extraction failed
)
goto :eof

REM =============================================
REM MAIN MENU
REM =============================================
:MAIN_MENU
cls
echo.
echo ==============================================
echo          YOUTUBE DOWNLOADER
echo ==============================================
echo.
echo Download Folder: %MAIN_FOLDER%
echo.
echo   1. Download Playlist
echo   2. Download Single Video
echo   3. Resume Download
echo   4. Change Download Folder
echo   5. Update Tools
echo   6. Exit
echo.
echo ==============================================
echo.

set "choice="
set /p "choice=Enter your choice (1-6): "

if "%choice%"=="1" goto DOWNLOAD_PLAYLIST
if "%choice%"=="2" goto DOWNLOAD_VIDEO
if "%choice%"=="3" goto RESUME
if "%choice%"=="4" (
    set "MAIN_FOLDER="
    goto SETUP_FOLDER
)
if "%choice%"=="5" goto UPDATE_TOOLS
if "%choice%"=="6" goto EXIT_SCRIPT

echo Invalid choice.
timeout /t 2 >nul
goto MAIN_MENU

REM =============================================
REM UPDATE TOOLS
REM =============================================
:UPDATE_TOOLS
cls
echo.
echo ==============================================
echo          UPDATE TOOLS
echo ==============================================
echo.

echo Current status:
echo.
if exist "%YTDLP%" (
    echo   yt-dlp: [INSTALLED]
    for /f "delims=" %%v in ('"%YTDLP%" --version 2^>nul') do echo   Version: %%v
) else (
    echo   yt-dlp: [NOT FOUND]
)
echo.
if exist "%FFMPEG_PATH%\ffmpeg.exe" (
    echo   ffmpeg: [INSTALLED]
) else (
    echo   ffmpeg: [NOT FOUND]
)

echo.
echo ==============================================
echo.
echo   1. Update yt-dlp
echo   2. Reinstall ffmpeg
echo   3. Reinstall both
echo   4. Open download URLs in browser
echo   5. Open tools folder
echo   6. Go back
echo.

set "upchoice="
set /p "upchoice=Choice: "

if "%upchoice%"=="1" (
    echo Deleting old yt-dlp...
    del "%YTDLP%" 2>nul
    call :DOWNLOAD_YTDLP
    pause
)
if "%upchoice%"=="2" (
    echo Deleting old ffmpeg...
    rmdir /s /q "%FFMPEG_PATH%" 2>nul
    call :DOWNLOAD_FFMPEG
    pause
)
if "%upchoice%"=="3" (
    del "%YTDLP%" 2>nul
    rmdir /s /q "%FFMPEG_PATH%" 2>nul
    call :DOWNLOAD_YTDLP
    call :DOWNLOAD_FFMPEG
    pause
)
if "%upchoice%"=="4" (
    start "" "%YTDLP_URL%"
    start "" "https://www.gyan.dev/ffmpeg/builds/"
    echo Browser opened.
    pause
)
if "%upchoice%"=="5" (
    if not exist "%TOOLS_FOLDER%" mkdir "%TOOLS_FOLDER%" 2>nul
    if not exist "%FFMPEG_PATH%" mkdir "%FFMPEG_PATH%" 2>nul
    explorer "%TOOLS_FOLDER%"
    pause
)
if "%upchoice%"=="6" goto MAIN_MENU

goto UPDATE_TOOLS

REM =============================================
REM BUILD COMMAND
REM =============================================
:BUILD_CMD
set "YTDLP_CMD="%YTDLP%""

if exist "%FFMPEG_PATH%\ffmpeg.exe" (
    set "YTDLP_CMD=!YTDLP_CMD! --ffmpeg-location "%FFMPEG_PATH%""
)

if exist "%COOKIE_PATH%" (
    set "YTDLP_CMD=!YTDLP_CMD! --cookies "%COOKIE_PATH%""
)
goto :eof

REM =============================================
REM VERIFY TOOLS
REM =============================================
:VERIFY_TOOLS
set "TOOLS_OK=1"

if not exist "%YTDLP%" (
    echo.
    echo [ERROR] yt-dlp not found at: %YTDLP%
    set "TOOLS_OK=0"
)

if not exist "%FFMPEG_PATH%\ffmpeg.exe" (
    echo.
    echo [WARNING] ffmpeg not found - videos may have no audio!
    echo          Location checked: %FFMPEG_PATH%\ffmpeg.exe
)

if "!TOOLS_OK!"=="0" (
    echo.
    echo Go to option 5 to download/update tools.
    pause
)
goto :eof

REM =============================================
REM DOWNLOAD PLAYLIST
REM =============================================
:DOWNLOAD_PLAYLIST
cls
echo.
echo ==============================================
echo          DOWNLOAD PLAYLIST
echo ==============================================
echo.

call :VERIFY_TOOLS
if "!TOOLS_OK!"=="0" goto MAIN_MENU

REM Loop to allow user to retry without going to main menu
:PLAYLIST_INPUT_LOOP
set "url="
set /p "url=Enter playlist URL (or 'back' to return to menu): "

if /i "!url!"=="back" goto MAIN_MENU

if "!url!"=="" (
    echo.
    echo [!] No URL entered. Please try again.
    echo.
    timeout /t 1 >nul
    goto PLAYLIST_INPUT_LOOP
)

echo.
echo Getting playlist info...

call :BUILD_CMD

set "ptitle=Playlist_%random%"
for /f "delims=" %%a in ('!YTDLP_CMD! --print playlist_title --playlist-items 1 "!url!" 2^>nul') do (
    set "ptitle=%%a"
)

REM Check if URL was valid
if "!ptitle!"=="Playlist_%random%" (
    echo.
    echo [ERROR] Could not get playlist info. This could mean:
    echo   - Invalid YouTube URL
    echo   - Playlist is private or doesn't exist
    echo   - Network connection issue
    echo.
    set /p "retry=Try another URL? (y/n): "
    if /i "!retry!"=="y" goto PLAYLIST_INPUT_LOOP
    goto MAIN_MENU
)

REM Clean the playlist name for use as folder name
set "ptitle=!ptitle::=-!"
set "ptitle=!ptitle:/=-!"
set "ptitle=!ptitle:\=-!"
set "ptitle=!ptitle:?=!"
set "ptitle=!ptitle:*=!"
set "ptitle=!ptitle:|=-!"
set "ptitle=!ptitle:~0,60!"

if "!ptitle!"=="" set "ptitle=Playlist_%random%"

echo.
echo Playlist Name: !ptitle!

set "outdir=%MAIN_FOLDER%\!ptitle!"
set "archive=%MAIN_FOLDER%\archive_!ptitle!.txt"

REM Create directory with error handling
if not exist "!outdir!" (
    mkdir "!outdir!" 2>nul
    if errorlevel 1 (
        echo.
        echo [ERROR] Cannot create folder: !outdir!
        echo.
        echo This might be a permission issue. Try:
        echo   1. Run as Administrator
        echo   2. Choose a different download location (option 4 in main menu)
        pause
        goto MAIN_MENU
    )
)

echo Saving to: !outdir!
echo.
echo Starting download (VIDEO + AUDIO)...
echo This may take a while depending on playlist size...
echo.

!YTDLP_CMD! -f "bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/bestvideo[height<=1080]+bestaudio/best[height<=1080]/best" --merge-output-format mp4 -o "!outdir!\%%(playlist_index)03d - %%(title)s.%%(ext)s" --download-archive "!archive!" --continue --no-overwrites --retries 10 --fragment-retries 10 --ignore-errors --restrict-filenames --windows-filenames --progress "!url!"

echo.
echo ==============================================
echo          DOWNLOAD COMPLETE
echo ==============================================
echo.
echo Folder: !ptitle!
echo Location: !outdir!
echo.

set /p "openfolder=Open folder? (y/n): "
if /i "!openfolder!"=="y" explorer "!outdir!"

echo.
set /p "another=Download another playlist? (y/n): "
if /i "!another!"=="y" goto DOWNLOAD_PLAYLIST

goto MAIN_MENU

REM =============================================
REM DOWNLOAD SINGLE VIDEO
REM =============================================
:DOWNLOAD_VIDEO
cls
echo.
echo ==============================================
echo          DOWNLOAD SINGLE VIDEO
echo ==============================================
echo.

call :VERIFY_TOOLS
if "!TOOLS_OK!"=="0" goto MAIN_MENU

REM Loop to allow user to retry without going to main menu
:VIDEO_INPUT_LOOP
set "url="
set /p "url=Enter video URL (or 'back' to return to menu): "

if /i "!url!"=="back" goto MAIN_MENU

if "!url!"=="" (
    echo.
    echo [!] No URL entered. Please try again.
    echo.
    timeout /t 1 >nul
    goto VIDEO_INPUT_LOOP
)

set "outdir=%MAIN_FOLDER%\Single_Videos"
set "archive=%MAIN_FOLDER%\archive_singles.txt"

REM Create directory with error handling
if not exist "!outdir!" (
    mkdir "!outdir!" 2>nul
    if errorlevel 1 (
        echo.
        echo [ERROR] Cannot create folder: !outdir!
        echo.
        echo This might be a permission issue. Try:
        echo   1. Run as Administrator
        echo   2. Choose a different download location (option 4 in main menu)
        pause
        goto MAIN_MENU
    )
)

echo.
echo Saving to: !outdir!
echo.
echo Starting download (VIDEO + AUDIO)...
echo.

call :BUILD_CMD

!YTDLP_CMD! -f "bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/bestvideo[height<=1080]+bestaudio/best[height<=1080]/best" --merge-output-format mp4 -o "!outdir!\%%(title)s.%%(ext)s" --download-archive "!archive!" --continue --no-overwrites --retries 10 --fragment-retries 10 --ignore-errors --restrict-filenames --windows-filenames --no-playlist --progress "!url!"

echo.
echo ==============================================
echo          DOWNLOAD COMPLETE
echo ==============================================
echo.

set /p "openfolder=Open folder? (y/n): "
if /i "!openfolder!"=="y" explorer "!outdir!"

echo.
set /p "another=Download another video? (y/n): "
if /i "!another!"=="y" goto DOWNLOAD_VIDEO

goto MAIN_MENU

REM =============================================
REM RESUME DOWNLOAD
REM =============================================
:RESUME
cls
echo.
echo ==============================================
echo          RESUME DOWNLOAD
echo ==============================================
echo.

call :VERIFY_TOOLS
if "!TOOLS_OK!"=="0" goto MAIN_MENU

if not exist "%MAIN_FOLDER%" (
    echo Download folder not found at: %MAIN_FOLDER%
    pause
    goto MAIN_MENU
)

echo Folders in %MAIN_FOLDER%:
echo.

set "count=0"
for /d %%d in ("%MAIN_FOLDER%\*") do (
    set /a count+=1
    set "folder!count!=%%d"
    echo   !count!. %%~nxd
)

if "!count!"=="0" (
    echo No folders found.
    pause
    goto MAIN_MENU
)

echo.
set "pick="
set /p "pick=Enter folder number: "

if "!pick!"=="" (
    echo No selection.
    timeout /t 2 >nul
    goto RESUME
)

set "selected="
for /L %%i in (1,1,!count!) do (
    if "!pick!"=="%%i" set "selected=!folder%%i!"
)

if "!selected!"=="" (
    echo Invalid selection.
    timeout /t 2 >nul
    goto RESUME
)

echo.
echo Selected: !selected!

for %%f in ("!selected!") do set "fname=%%~nxf"
set "archive=%MAIN_FOLDER%\archive_!fname!.txt"

echo.
set "url="
set /p "url=Enter playlist URL: "

if "!url!"=="" (
    echo No URL entered.
    timeout /t 2 >nul
    goto RESUME
)

echo.
echo Resuming download...
echo.

call :BUILD_CMD

!YTDLP_CMD! -f "bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/bestvideo[height<=1080]+bestaudio/best[height<=1080]/best" --merge-output-format mp4 -o "!selected!\%%(playlist_index)03d - %%(title)s.%%(ext)s" --download-archive "!archive!" --continue --no-overwrites --retries 10 --fragment-retries 10 --ignore-errors --restrict-filenames --windows-filenames --progress "!url!"

echo.
echo ==============================================
echo          DOWNLOAD COMPLETE
echo ==============================================
echo.
pause
goto MAIN_MENU

REM =============================================
REM EXIT
REM =============================================
:EXIT_SCRIPT
cls
echo.
echo Goodbye!
echo.
timeout /t 2 >nul
exit