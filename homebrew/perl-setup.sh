#!/bin/bash
set -e -o pipefail

brew install cpanminus

cpanm -n Perl::LanguageServer
cpanm -n File::Slurp
cpanm -n IPC::Run