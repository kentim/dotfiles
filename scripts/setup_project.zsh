#!/bin/sh

die() {
    echo "$(basename $0):" "$@" 1>&2
    exit 1
}

if [ $# -lt 1 ]
then
  die "Usage: setup_project <path>"
fi

mkdir -p "$1/Classes/AppDelegate"
mkdir -p "$1/Classes/Controllers"
mkdir -p "$1/Classes/Models"
mkdir -p "$1/Classes/Helpers"

mkdir -p "$1/Resources/Custom UI Classes"
mkdir -p "$1/Resources/Database"
mkdir -p "$1/Resources/Images"
mkdir -p "$1/Resources/Sounds"
mkdir -p "$1/Resources/Storyboards"

echo "Setup complete"