# enable-build-plates
Bambu Studio - Enable All Build Plates

Removes build plate restrictions from printers in Bambu Studio

What does this do?
1) checks which OS it is running under (macOS, Linux, or WSL/Windows)
2) removes build plate restrictions from printer profiles

Example: Cool Plate wasn't selectable on several printers.
This scripts removes that restriction.

The script will check for common locations and processes json files within.

Tested with sh/bash/zsh on macOS, Linux, and WSL.
I've tried to make this POSIX compliant for GNU and BSD.

To use:

Download to your system and then run it.
e.g. "sh ./enable-build-plates.sh" or set executable.

It updates files in-place, and does NOT make backups of them.



2026-08-18
* first test

Nicholas Caito
https://xenomorph.net
