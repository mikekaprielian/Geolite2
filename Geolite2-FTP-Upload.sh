#!/bin/bash

# Download GeoLite.mmdb files
wget -nv -O- "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-Country&license_key=<YOUR LICENSE KEY>&suffix=tar.gz" | tar zxv
VERSION_FOLDER=$(find GeoLite* -maxdepth 0 -type d)  # Get the version folder name
VERSION=$(echo "$VERSION_FOLDER" | sed 's/.*_//')     # Extract the version from the folder name
EPOCH_DATE=$(date -d "$VERSION" +"%s")               # Convert version to Epoch date
mkdir -p upload
mv -v GeoLite*/*.mmdb GeoLite2.mmdb
cp -v GeoLite2.mmdb upload
echo "{\"date\": \"$EPOCH_DATE\", \"version\": \"$VERSION\"}" > upload/GeoLite2_status.json

# Replace FTP_SERVER, FTP_USERNAME, FTP_PASSWORD, and FTP_PATH with your FTP server details
FTP_SERVER=""
FTP_USERNAME=""
FTP_PASSWORD=""
FTP_PATH="/"

# Upload the files to the FTP server using lftp and overwrite existing files
lftp -c "open -u ${FTP_USERNAME},${FTP_PASSWORD} ${FTP_SERVER}; mirror --reverse --delete --only-newer --verbose upload ${FTP_PATH}"

# Remove GeoLite2-Country_* folder and contents
rm -rf GeoLite2-Country_*

# Cleanup temporary files
rm -rf upload
