#!/bin/bash

# Check if URL was provided
if [ -z "$1" ]; then
    echo "Usage: ./yt-play.sh <YouTube URL>"
    echo "Plays a YouTube video or playlist in mpv using yt-dlp."
    echo "Example for a single video: ./yt-play.sh 'https://www.youtube.com/watch?v=mkqhVRt9aXc&t=306s'"
    echo "Example for a playlist: ./yt-play.sh 'https://www.youtube.com/watch?v=1Tp6IP-5JWY&list=PLsaE__vWcRalT0TQ8t00uaNPA6rZglGVb&pp=iAQB'"
    exit 1
fi

# Check if the URL is a playlist
if [[ $1 == *"list="* ]]; then
    mpv $(yt-dlp "$1" --yes-playlist --get-url -f best)
else
    yt-dlp -o - "$1" | mpv -
fi

