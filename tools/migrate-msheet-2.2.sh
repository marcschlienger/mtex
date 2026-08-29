#!/bin/sh
# migrate-msheet-2.2.sh -- rename msheet.sty v2.1 environments to the v2.2
# semantic names.  Operates in place on every .tex file given, or on every
# .tex file below the current directory when called with no arguments.
#
#   msheet 2.1                     msheet 2.2
#   ---------------------------    -------------------------
#   mtbred    / mbred              mrule       / mrule*
#   mtbgreen  / mbgreen            mexperiment / mexperiment*
#   mtbblue   / mbblue             mexample    / mexample*
#              mbinfo                            minfo*
#   mtbcolor  / mbcolor            mframe      / mframe*
#   \mibcolor[c]{t} \mibgreen{t}   \mtag[c]{t} \mtag{t}
#   \mibred{t} / \mibblue{t}       \mtag[FireBrick]{t} / \mtag[DodgerBlue]{t}
#   \mibnpsymbol                   \mturnsymbol
#
# Removed with no replacement (they had no uses): mtasklist, msectionlist,
# mexerciselist, msectioniselist, menumeratex, mtaskcolumns, mdone,
# \msexercise, \mpexercise.
set -eu

if [ "$#" -gt 0 ]; then
	set -- "$@"
else
	# shellcheck disable=SC2046
	set -- $(find . -name '*.tex' -not -path '*/.git/*')
fi

for f in "$@"; do
	[ -f "$f" ] || continue
	perl -0777 -i -pe '
		# environments: titled first, then the untitled ones to the starred form
		s/\\(begin|end)\{mtbred\}/\\$1\{mrule\}/g;
		s/\\(begin|end)\{mtbgreen\}/\\$1\{mexperiment\}/g;
		s/\\(begin|end)\{mtbblue\}/\\$1\{mexample\}/g;
		s/\\(begin|end)\{mtbcolor\}/\\$1\{mframe\}/g;
		s/\\(begin|end)\{mbred\}/\\$1\{mrule*\}/g;
		s/\\(begin|end)\{mbgreen\}/\\$1\{mexperiment*\}/g;
		s/\\(begin|end)\{mbblue\}/\\$1\{mexample*\}/g;
		s/\\(begin|end)\{mbinfo\}/\\$1\{minfo*\}/g;
		s/\\(begin|end)\{mbcolor\}/\\$1\{mframe*\}/g;
		# inline markers
		s/\\mibcolor(\[[^]]*\])?/\\mtag$1/g;
		s/\\mibgreen\b/\\mtag/g;
		s/\\mibred\b/\\mtag[FireBrick]/g;
		s/\\mibblue\b/\\mtag[DodgerBlue]/g;
		s/\\mibnpsymbol\b/\\mturnsymbol/g;
		# renamed commands
		s/\\msexercise\b/\\msection/g;
		s/\\mpexercise\b/\\msectionr/g;
	' "$f"
done
