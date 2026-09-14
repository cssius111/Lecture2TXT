#!/bin/bash

# Lecture2TXT — macOS helper for local OpenAI Whisper transcription.
# Double-click this file, choose one or more audio/video files,
# and TXT transcripts will be written next to the originals.

# Optional workaround; prefer a clean virtual environment (see README).
# export KMP_DUPLICATE_LIB_OK=TRUE

# GUI-launched shells may have a reduced PATH, so include common locations.
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/anaconda3/envs/playwright_env/bin:$HOME/anaconda3/bin:$HOME/miniconda3/bin:$PATH"

SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
export PATH="$SCRIPT_DIR/.venv/bin:$PATH"

# Find Whisper.
WHISPER_BIN=""
for candidate in \
  "$(command -v whisper 2>/dev/null)" \
  "$HOME/anaconda3/envs/playwright_env/bin/whisper" \
  "$HOME/anaconda3/bin/whisper" \
  "$HOME/miniconda3/bin/whisper" \
  "/opt/homebrew/bin/whisper" \
  "/usr/local/bin/whisper"
do
  if [ -n "$candidate" ] && [ -x "$candidate" ]; then
    WHISPER_BIN="$candidate"
    break
  fi
done

if [ -z "$WHISPER_BIN" ]; then
  osascript -e 'display alert "Lecture2TXT" message "Whisper was not found. Follow the installation steps in README.md, then reopen this tool." as critical'
  exit 1
fi

# Find ffmpeg.
if ! command -v ffmpeg >/dev/null 2>&1; then
  osascript -e 'display alert "Lecture2TXT" message "ffmpeg was not found. Install it with: brew install ffmpeg" as critical'
  exit 1
fi

# Ask for one or more media files.
FILES=$(
osascript <<'APPLESCRIPT'
try
    set pickedFiles to choose file with prompt "Select lecture videos or audio files to transcribe into TXT:" with multiple selections allowed
    set outputText to ""
    repeat with f in pickedFiles
        set outputText to outputText & POSIX path of f & linefeed
    end repeat
    return outputText
on error number -128
    return ""
end try
APPLESCRIPT
)

if [ -z "$FILES" ]; then
  exit 0
fi

echo "============================================================"
echo " Lecture2TXT"
echo " Model: medium | Language: English | Output: TXT"
echo "============================================================"
echo

COUNT=0
SUCCESS=0
FAILED=0

while IFS= read -r FILE; do
  [ -z "$FILE" ] && continue
  COUNT=$((COUNT + 1))
  OUTDIR="$(dirname "$FILE")"
  BASENAME="$(basename "$FILE")"

  echo
  echo "[$COUNT] Transcribing: $BASENAME"
  echo "Output folder: $OUTDIR"
  echo

  "$WHISPER_BIN" "$FILE" \
    --language English \
    --model medium \
    --output_format txt \
    --output_dir "$OUTDIR"

  STATUS=$?
  if [ $STATUS -eq 0 ]; then
    SUCCESS=$((SUCCESS + 1))
    echo
    echo "✓ Finished: $BASENAME"
  else
    FAILED=$((FAILED + 1))
    echo
    echo "✗ Failed: $BASENAME"
  fi
done <<< "$FILES"

echo
echo "============================================================"
echo " Batch complete: $SUCCESS succeeded, $FAILED failed"
echo " Successful transcripts are saved next to the original media files."
echo "============================================================"

osascript -e "display notification \"$SUCCESS succeeded, $FAILED failed. Check Terminal for details.\" with title \"Lecture2TXT\""

echo
read -n 1 -s -r -p "Press any key to close this window..."
echo

# Report partial batch failures to callers.
[ "$FAILED" -eq 0 ]
