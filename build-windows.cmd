@echo off
setlocal EnableExtensions
cd /d "%~dp0"
echo [VirtualApp] Checking build environment...
where java >nul 2>&1 || (echo ERROR: Java not found in PATH. Install JDK 17.& exit /b 1)
where git >nul 2>&1 || echo NOTE: Git not found; build can still run.
if not exist gradlew.bat (echo ERROR: Run this script from the VirtualApp repository root.& exit /b 1)
if not defined ANDROID_HOME if not defined ANDROID_SDK_ROOT (
  if exist "%LOCALAPPDATA%\Android\Sdk" set "ANDROID_HOME=%LOCALAPPDATA%\Android\Sdk"
)
if not defined ANDROID_HOME if not defined ANDROID_SDK_ROOT (
  echo ERROR: Set ANDROID_HOME or ANDROID_SDK_ROOT to your Android SDK directory.
  exit /b 1
)
java -version
echo [VirtualApp] Building debug APKs...
call gradlew.bat --no-daemon assembleDebug --stacktrace
if errorlevel 1 (
  echo ERROR: Gradle build failed. See output above.
  exit /b 1
)
echo [VirtualApp] APK output:
dir /b "app\build\outputs\apk\debug\*.apk"
echo [VirtualApp] Build complete. APK launch/functionality still needs device testing.
endlocal
