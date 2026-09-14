# Lecture2TXT

**Turn downloaded lecture videos into local TXT transcripts—and use them to enrich your study notes with AI.**

Lecture2TXT is a small macOS launcher for [OpenAI Whisper](https://github.com/openai/whisper). Double-click it, select one or more lecture videos or audio files, and get plain-text transcripts beside the originals.

```text
Lecture video downloaded from Canvas
                 ↓
       Whisper on your Mac
                 ↓
           Lecture.txt
                 ↓
  Your notes + an AI assistant of your choice
                 ↓
     More complete study notes
```

## What it does

- Transcribes local video and audio files using Whisper on your Mac.
- Lets you select multiple files in a native macOS file picker.
- Saves `.txt` transcripts in the same folder as each source file.
- Shows progress and a success/failure summary in Terminal.
- Requires no API key or transcription service subscription.

Canvas is an example source: the tool works on files you have already downloaded. It does not sign into Canvas or download recordings. It also does not generate study notes automatically; you choose how to use the resulting text.

## Local processing and offline use

**Transcription runs locally. Lecture2TXT does not upload your video, audio, or transcripts to a cloud transcription service.**

Internet access is needed to install dependencies and download the Whisper model the first time it is used. Once dependencies and the model are available locally, transcription can run offline. Whisper normally caches models under `~/.cache/whisper`.

If you later upload a transcript or your notes to a cloud AI assistant, that is a separate step that sends the text to that service. Use a local AI assistant if you want the note-enrichment step to stay local too. Files saved inside a cloud-synced folder may also be synced by that folder's provider.

## Quick start: already have Whisper and ffmpeg?

1. Download this repository using **Code → Download ZIP**, then unzip it.
2. Double-click `Lecture2TXT.command`.
3. Select one or more downloaded lecture videos or audio files.
4. Wait for transcription to finish, then open the `.txt` files beside the originals.

For example, `Week 02 Lecture.mp4` produces `Week 02 Lecture.txt`.

If Whisper is installed in a custom environment, activate it in Terminal and launch the script from there. A `.venv` folder next to the script is detected automatically.

## Install on another Mac

You need macOS, [Homebrew](https://brew.sh/), Python, and ffmpeg. From Terminal:

```bash
brew install python@3.11 ffmpeg
```

Open Terminal in the downloaded `Lecture2TXT` folder, then run:

```bash
"$(brew --prefix python@3.11)/bin/python3.11" -m venv .venv
.venv/bin/python -m pip install --upgrade pip
.venv/bin/python -m pip install openai-whisper
chmod +x Lecture2TXT.command
```

Double-click `Lecture2TXT.command` to start. The first transcription downloads the `medium` model, so allow extra time and keep your connection available. Later runs reuse the cached model.

To download the model before you go offline, run this from the project folder while online:

```bash
.venv/bin/python -c 'import whisper; whisper.load_model("medium")'
```

## Defaults

| Setting | Value |
| --- | --- |
| Platform | macOS |
| Model | `medium` |
| Spoken language | English |
| Output format | Plain text (`.txt`), without timestamps |
| Output location | Same folder as the source media |
| Batch processing | One file at a time |

To change the model or spoken language, edit `--model medium` or `--language English` in `Lecture2TXT.command`. Update the printed settings banner as well. Smaller models such as `base` or `small` can reduce processing time, with an accuracy tradeoff. A different model needs its own initial download.

## Use the transcript to improve your notes

Give your AI assistant the transcript and your existing notes, then try:

```text
Use the lecture transcript to improve my existing study notes.

1. Preserve my structure and writing style where possible.
2. Add missing concepts, definitions, and examples supported by the transcript.
3. Clearly label new additions and any apparent contradictions.
4. Flag unclear wording and possible transcription errors instead of guessing.
5. Separate any outside knowledge from what the lecturer actually said.
6. Finish with five review questions based on the lecture.

My notes:
[paste your notes here]

Lecture transcript:
[paste the TXT transcript here]
```

For long lectures, work through the transcript in sections. Review the result against the recording, especially technical terms, names, and equations. Transcription captures speech; it does not extract slide text or diagrams.

## Troubleshooting

- **Permission denied:** run `chmod +x Lecture2TXT.command` in the project folder, then reopen it. You can also run `bash Lecture2TXT.command` from Terminal.
- **Whisper not found:** follow the `.venv` installation steps above, or launch from a Terminal session with your Whisper environment activated.
- **ffmpeg not found:** run `brew install ffmpeg` and reopen the launcher.
- **Slow transcription:** long lectures and the `medium` model can take substantial time, especially on CPU. Try a smaller model if needed.
- **Duplicate OpenMP runtime error:** prefer a clean `.venv` installation. The original personal script enabled `KMP_DUPLICATE_LIB_OK=TRUE`; this version leaves that workaround commented out. It suppresses a runtime check rather than resolving the underlying library conflict.
- **Missing or incorrect output:** check the error in Terminal and confirm you can write to the source folder. Whisper can make mistakes or invent text in noisy or silent sections.

Files with the same name stem in the same folder target the same TXT filename, and existing transcripts may be overwritten. Rename source files or move them into separate folders first. Filenames containing newline characters are not supported by the file-picker handoff.

## Credits

Powered by [OpenAI Whisper](https://github.com/openai/whisper) and [ffmpeg](https://ffmpeg.org/). This is an independent helper, not an official Canvas or OpenAI application. Use recordings you are permitted to download and process.
