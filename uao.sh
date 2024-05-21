#!/bin/bash

function run() {
    echo "Running: $1"
    eval "$1"
}

if [ $# -lt 2 ]; then
    echo "Usage: $0 <zip_file> <destination_folder> [--ide=idea|vsc]"
    exit 1
fi

zip_file="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
dest_folder="$(cd "$(dirname "$2")" && pwd)/$(basename "$2")"
ide="idea"

if [ $# -eq 3 ] && [[ $3 == --ide=* ]]; then
    ide="${3#*=}"
fi

if [[ ! $zip_file == *.zip ]]; then
    echo "You must specify a .zip file to open."
    exit 1
fi

if [ ! -f "$zip_file" ]; then
    echo "The zip file '$zip_file' does not exist."
    exit 1
fi

folder_name="${zip_file%.zip}"
folder_name="$(basename "$folder_name")"

run "unzip -a \"$zip_file\" -d \"$dest_folder\""

project_folder="$dest_folder/$folder_name"
gradle_build="$project_folder/build.gradle"
mvn_pom="$project_folder/pom.xml"

if [ ! -f "$gradle_build" ] && [ ! -f "$mvn_pom" ]; then
    echo "There must be a 'build.gradle' or a 'pom.xml' in the root of the folder '$project_folder'."
    exit 1
fi

if [ -f "$gradle_build" ]; then
    if [ "$ide" == "idea" ]; then
        run "open -na \"IntelliJ IDEA.app\" --args \"$gradle_build\""
    elif [ "$ide" == "vsc" ] && command -v code >/dev/null 2>&1; then
        run "code \"$project_folder\""
    else
        echo "The specified IDE ('$ide') is not installed or not found on the PATH."
        exit 1
    fi
else
    if [ "$ide" == "idea" ]; then
        run "open -na \"IntelliJ IDEA.app\" --args \"$mvn_pom\""
    elif [ "$ide" == "vsc" ] && command -v code >/dev/null 2>&1; then
        run "code \"$project_folder\""
    else
        echo "The specified IDE ('$ide') is not installed or not found on the PATH."
        exit 1
    fi
fi
