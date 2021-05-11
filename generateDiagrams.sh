#!/bin/bash
echo 'Generating diagrams...'
for i in diagrams/*/*.msc ; do
	echo $i
	mscgen -T eps -i $i
	mscgen -T png -i $i
	done

