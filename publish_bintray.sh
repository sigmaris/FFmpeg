#!/bin/bash -e

: "${BINTRAY_USER:=sigmaris}"

ffmpeg_version="$(set -- ffmpeg_*_arm64.deb; echo "$1" | cut -d '_' -f 2)"
if [[ -z "$ffmpeg_version" ]]
then
	echo "Can't detect FFmpeg version from these files:"
	ls
	exit 1
fi

echo "*********************************"
echo "*** Uploading built artifacts ***"
echo "*********************************"

for pkgfile in *.deb
do
	echo " ${pkgfile}..."
	curl -s -T "$pkgfile" --netrc-file <(cat <<<"machine api.bintray.com login $BINTRAY_USER password $BINTRAY_API_KEY") "https://api.bintray.com/content/${BINTRAY_USER}/artifacts/ffmpeg/${ffmpeg_version}/${pkgfile}"
	echo ""
done

echo "*************"
echo "*** Done! ***"
echo "*************"
