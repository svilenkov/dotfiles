### `gen_patch.pl`

`gen_patch.pl` is a Perl script that **automatically syncs your Homebrew Brewfile** with the currently installed taps, casks, and brews, and **generates a patch file** (Brewfile.patch) showing the differences.

It has some requirements, at least on macOS:
```bash
brew install cpanminus

cpanm -n Perl::LanguageServer
cpanm -n File::Slurp
cpanm -n IPC::Run
```