@echo off
setlocal EnableDelayedExpansion

rem Check for .c3p files with a dash in the filename
dir /b *-*.c3p 2>nul | findstr . >nul
if errorlevel 1 (
    echo No *-*.c3p files were found in the current directory.
    pause
    exit /b 1
)

rem Iterate through c3p files sorted by name, ascending
for /f "tokens=*" %%A in ('dir /b /o:n *-*.c3p') do (

    rem Extract the project directory name (before the first dash) and the commit message (after the first dash)
	for /f "tokens=1* delims=-" %%P in ("%%~nA") do (
		set "REPO_DIR=%%P"
		set "COMMIT_MESSAGE=%%Q"
	)

    rem Ensure the repo directory exists and is a git repository
    if not exist "!REPO_DIR!" (
        echo The directory "!REPO_DIR!" does not exist for file %%A.
        pause
        exit /b 1
    )
    if not exist "!REPO_DIR!\.git" (
        echo The directory "!REPO_DIR!" is not a git repository for file %%A.
        pause
        exit /b 1
    )

	echo Deleting contents of "!REPO_DIR!" directory

    rem Remove everything from repo directory except .git directory and .gitignore file
    for /d %%D in ("!REPO_DIR!\*") do (
        if /I "%%~nxD" neq ".git" (
            rd /s /q "%%D"
        )
    )
    for %%F in ("!REPO_DIR!\*") do (
        if /I "%%~nxF" neq ".gitignore" (
            del /q "%%F"
        )
    )

    rem Extract the current c3p file to the repo directory
    echo Extracting %%A to !REPO_DIR! directory
    tar -xf "%%A" -C "!REPO_DIR!"
    if errorlevel 1 (
        echo Failed to extract %%A
        pause
        exit /b 1
    )

    rem Change to the repo directory
    pushd "!REPO_DIR!"

    rem Stage all changes 
	echo Staging all changes
    git add --all
    if errorlevel 1 (
        echo Failed to stage files
        popd
        pause
        exit /b 1
    )

	rem Commit with the c3p project file suffix as the message
	echo Creating commit
    git commit -m "!COMMIT_MESSAGE!"
    if errorlevel 1 (
        echo Failed to commit changes
        popd
        pause
        exit /b 1
    )

    rem Run git gc as the last step
	echo Cleaning up unnecessary files and optimizing repository
    git gc
    popd
)

echo All done!
pause
