#!/bin/bash

if [[ -e source.txt && ! -e destination.txt ]] ; then
  # source.txt exists, destination.txt does not exist; perform the copy:
  cp source.txt destination.txt
fi

if [[ -e source.txt ]] && ! [[ -e destination.txt ]] ; then
  # source.txt exists, destination.txt does not exist; perform the copy:
  cp source.txt destination.txt
fi
