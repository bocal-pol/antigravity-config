# Alert sound — plays a notification sound
# Called by the session-stop hook

$soundPath = "C:\Windows\Media\tada.wav"

# Fallback if tada.wav does not exist
if (-not (Test-Path $soundPath)) {
    $soundPath = "C:\Windows\Media\notify.wav"
}

# Fallback if no sound is found at all
if (-not (Test-Path $soundPath)) {
    Write-Host "Alert: no sound file found"
    exit 1
}

# Play the sound via System.Media.SoundPlayer
try {
    Add-Type -AssemblyName presentationCore
    $player = New-Object System.Media.SoundPlayer $soundPath
    $player.PlaySync()
    exit 0
} catch {
    Write-Host "Alert: error while playing sound ($($_.Exception.Message))"
    exit 1
}
