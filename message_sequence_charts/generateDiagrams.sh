#!/bin/bash
echo 'Generating diagrams...'

declare -a subdirectories=(
	"apps"
)

for dir in "${subdirectories[@]}" ; do
	for i in diagrams/$dir/*/*.msc ; do
		echo $i
		mscgen -T eps -i $i
		mscgen -T png -i $i
	done
done

