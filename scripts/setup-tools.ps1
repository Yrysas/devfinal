param(
    [string]$JdkUrl = 'https://github.com/adoptium/temurin21-binaries/releases/latest/download/OpenJDK21U-jdk_x64_windows_hotspot.zip',
    [string]$GradleUrl = 'https://services.gradle.org/distributions/gradle-8.6-bin.zip'
)

# This script attempts a non-elevated, local download of a JDK 21 and Gradle into .tools
# and then sets JAVA_HOME and PATH in the current PowerShell session so you can run
# gradle and gradlew without installing system-wide.

$root = Split-Path -Parent $MyInvocation.MyCommand.Definition
$tools = Join-Path $root '.tools'
New-Item -ItemType Directory -Force -Path $tools | Out-Null

function Download-IfMissing($url, $out) {
    if (-Not (Test-Path $out)) {
        Write-Host "Downloading $url -> $out"
        try {
            Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing -ErrorAction Stop
        } catch {
            Write-Error "Failed to download $url: $_"
            return $false
        }
    } else {
        Write-Host "Already downloaded: $out"
    }
    return $true
}

$jdkZip = Join-Path $tools 'jdk21.zip'
$gradleZip = Join-Path $tools 'gradle.zip'

if (-not (Download-IfMissing $JdkUrl $jdkZip)) { Write-Host 'JDK download failed; please download JDK 21 manually and extract to .tools\jdk'; exit 1 }
if (-not (Download-IfMissing $GradleUrl $gradleZip)) { Write-Host 'Gradle download failed; please download Gradle 8.6 manually and extract to .tools\gradle'; exit 1 }

$jdkDir = Join-Path $tools 'jdk'
$gradleDir = Join-Path $tools 'gradle'

if (-Not (Test-Path $jdkDir)) { New-Item -ItemType Directory -Path $jdkDir | Out-Null }
if (-Not (Test-Path $gradleDir)) { New-Item -ItemType Directory -Path $gradleDir | Out-Null }

Write-Host 'Extracting JDK...'
try { Expand-Archive -Path $jdkZip -DestinationPath $jdkDir -Force } catch { Write-Host "Expand JDK failed: $_" }

Write-Host 'Extracting Gradle...'
try { Expand-Archive -Path $gradleZip -DestinationPath $gradleDir -Force } catch { Write-Host "Expand Gradle failed: $_" }

# After extraction, JDK and Gradle may be inside versioned subfolders. Find bin paths.
$extractedJdk = Get-ChildItem -Path $jdkDir -Directory -ErrorAction SilentlyContinue | Select-Object -First 1
if ($extractedJdk) { $jdkHome = $extractedJdk.FullName } else { $jdkHome = $jdkDir }

$extractedGradle = Get-ChildItem -Path $gradleDir -Directory -ErrorAction SilentlyContinue | Select-Object -First 1
if ($extractedGradle) { $gradleHome = $extractedGradle.FullName } else { $gradleHome = $gradleDir }

Write-Host "Using JDK home: $jdkHome"
Write-Host "Using Gradle home: $gradleHome"

# Set env vars in current session
$env:JAVA_HOME = $jdkHome
$env:Path = "$($jdkHome)\bin;$($gradleHome)\bin;" + $env:Path

Write-Host 'Java version (from downloaded JDK):'
& "$env:JAVA_HOME\bin\java.exe" -version

Write-Host 'Gradle version (from downloaded Gradle):'
try { & "$gradleHome\bin\gradle.bat" --version } catch { Write-Host "Gradle not runnable yet: $_" }

# If there is no gradlew in repo, generate wrapper using local gradle
if (-not (Test-Path (Join-Path $root 'gradlew.bat'))) {
    Write-Host 'Generating Gradle wrapper with local Gradle...'
    Push-Location $root
    try {
        & "$gradleHome\bin\gradle.bat" wrapper --gradle-version 8.6 --no-daemon
    } catch {
        Write-Host "Failed to create gradle wrapper: $_"
    }
    Pop-Location
}

Write-Host 'Running build (skip tests) via ./gradlew.bat'
Push-Location $root
try {
    & .\gradlew.bat build --no-daemon -x test
} catch {
    Write-Host "Build failed: $_"
}
Pop-Location

Write-Host 'Done. If things failed, run this script as Administrator or install JDK 21 and Gradle system-wide.'
