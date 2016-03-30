#!/bin/bash

export ERR=errors.log

ao() {
	if [ "$1" == "" ] || [ "$2" == "" ]; then
		echo "Converts audio-stream only (aac, 2ch, 44.1 kHz, vbr 3)."
		echo "Usage: cnv ao <input-filename> <output-filename>"
		exit
	fi
	ffmpeg -i "$1" -c:v copy -c:a libfdk_aac -ac 2 -ar 44100 -vbr 3 "$2"
}

player() {
	if [ "$1" == "" ]; then
		echo "Convert tracks from list (aac, 2ch, 44.1 kHz, vbr 4)."
		echo "Usage: cnv player <list>"
		exit
	fi
	until [ -z "$1" ]; do
		if [[ $(mimetype -b "$1") != audio* ]]; then
			shift
			continue
		fi
		LIST="$LIST\n$1"
		shift
	done
	export -f player_1
	echo -e "$LIST" | parallel --will-cite player_1
	echo
	echo "Tracks converted."
}

player_1() {
	[[ -z "$1" ]] && return
	ffmpeg -v quiet -i "$1" -c:a libfdk_aac -ac 2 -ar 44100 -vbr 4 "${1%.*}.m4a"
	if (( "$?" == 0 )); then
		if [ "$1" != "${1%.*}.m4a" ]; then
			rm "$1"
		fi
		echo -n "."
	else
		echo
		echo "An error occured converting '$1'!"
	fi
}

photos() {
	if [ "$1" == "" ]; then
		echo "Convert photos from list (jpeg, 1024x768)."
		echo "Usage: cnv photos <list>"
		exit
	fi
	until [ -z "$1" ]; do
		if [[ $(mimetype -b "$1") != image* ]]; then
			shift
			continue
		fi
		[[ ! -z "$LIST" ]] && LIST="$LIST\n"
		LIST="$LIST$1"
		shift
	done
	export -f photos_1
	echo -e "$LIST" | parallel --will-cite photos_1
	echo
	echo "Photos were successfully converted."
}

photos_1() {
	DIM=($(identify -format "%W %H" "$1" 2>/dev/null))
	[[ -z "${DIM[0]}" ]] && W=0 || W=${DIM[0]}
	[[ -z "${DIM[1]}" ]] && H=0 || H=${DIM[1]}
	if (( "$?" != 0 || ("$W" <= 1024 && "$H" <= 1024) )); then
		echo -n "_"
		return
	fi
	convert "$1" -filter Lanczos -resize 1024x1024 -quality 80 -auto-level "$1"
	echo -n "."
}

videos() {
	if [ "$1" == "" ]; then
		echo "Converts videos from list (mp4, 640x480, 1400 kbps)."
		echo "Usage: cnv videos <list>"
		exit
	fi
	until [ -z "$1" ]; do
		if [[ $(mimetype -b "$1") != video* ]]; then
			shift
			continue
		fi
		[[ ! -z "$LIST" ]] && LIST="$LIST\n"
		LIST="$LIST$1"
		shift
	done

	touch $ERR
	export -f videos_1
	echo -e "$LIST" | parallel --will-cite videos_1
	echo

	if [ -s $ERR ]; then
		echo "Not all videos were converted:"
		cat $ERR
	else
		echo "Videos converted successfully."
	fi
		
	rm $ERR
}

videos_1() {
	BR_V=$(ffprobe -print_format csv=p=0 -v quiet -show_entries stream=bit_rate -select_streams v "$1")
	if (( "$?" != 0 )); then
		echo -n "e"
		echo "BR_V $1" >> "$ERR"
		shift
		return
	fi
	A=$(ffprobe -print_format csv=p=0 -v quiet -show_entries stream=channels,bit_rate -select_streams a "$1")
	if (( "$?" != 0 )); then
		echo -n "e"
		echo "A $1" >> "$ERR"
		shift
		return
	fi
	A=(${A//,/ })
	if (( $(bc <<< ${A[1]}/${A[0]}) < 60000 )); then
		A="-c:a copy"
	else
		A="-c:a libfdk_aac -ar 44100 -vbr 3"
	fi
	( [[ -z "$BR_V" ]] || [[ "$BR_V" -gt 1400000 ]] ) && BR_V=1400000
	ffmpeg -v quiet -i "$1" -c:v mpeg4 -b:v $BR_V -vf "scale=640:trunc(ow/a/2)*2" \
-flags +aic+mv4 $A "_${1%.*}.mp4"
	if (( "$?" == 0 )); then
		rm "$1"
		mv "_${1%.*}.mp4" "${1%.*}.mp4"
		echo -n "."
	else
		echo -n "e"
		echo "CNV $1" >> "$ERR"
	fi
}

film() {
	if [ "$1" == "" ]; then
		echo "Convert film."
		echo "Usage: cnv film <file> <width> <bitrate>"
		exit
	fi

#,scale=${2}:-1 \
	ARGS="-ss 06:48 -i $1 -t 30 -c:v libx264 \
-vf crop=1280:800:250:200,hqdn3d=4.0:3.0:6.0:4.5,eq=gamma=1.2:contrast=2.0:brightness=0.8 \
-preset:v fast -b:v $3 \
-c:a libfdk_aac -ar 44100 -vbr 3 \
-x264opts threads=9"
#	ffmpeg -y $ARGS -pass 1 -f matroska /dev/null && \
#ffmpeg $ARGS -pass 2 ${1%.*}.mkv
	ffmpeg -y $ARGS ${1%.*}.mkv

	if (( "$?" == 0 )); then
		echo "Video converted!"
	fi
}

webm() {
	if [ "$1" == "" ]; then
		echo "Convert video to webm."
		echo "Usage: cnv webm <file> <width> <bitrate> <from> <duration>"
		exit
	fi

	ARGS="-y -ss $4 -i $1 -t $5 -threads 8 \
-c:v libvpx -vf scale=${2}:-1 -r 24 -b:v $3 -crf 4 \
-c:a libvorbis -qscale:a 2 -ac 1 -ar 44100"
	ffmpeg $ARGS -pass 1 -f webm /dev/null && \
ffmpeg $ARGS -pass 2 ${1%.*}.webm

	if (( "$?" == 0 )); then
		echo "Video converted!"
	fi
}

if [ "$1" == "" ]; then
	echo "Usage: cnv <ao|photos|videos|player|webm|...>"
else
	CMD="$1"
	shift
	$CMD "$@"
fi
