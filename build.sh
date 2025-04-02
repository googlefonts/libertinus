set -e

rm fonts/ttf/*.ttf

# Find latest release
API_URL="https://api.github.com/repos/alerque/libertinus/releases/latest"
curl -s $API_URL > release.json
TAG_NAME=$(jq -r '.tag_name' release.json)
echo $TAG_NAME
VERSION=${TAG_NAME//v/}
jq -r '.assets[] | select(.name | endswith(".zip")) | .browser_download_url' release.json > zip_urls.txt

# Download zip file
mkdir -p upstream-release
while IFS= read -r url; do
echo "Downloading $url"
curl -L -o "upstream-release/$(basename $url)" "$url"
done < zip_urls.txt

# Unzip
for file in upstream-release/*.zip; do
unzip -o "$file" -d upstream-release
done

# Copy statics
cp -R upstream-release/Libertinus-$VERSION/static/TTF/*.ttf fonts/ttf

# Fontspector Hotfixing
for file in fonts/ttf/*.ttf;
do
    echo "hotfixing $file";
    md5sum $file;
    fontspector -p googlefonts -l fail --hotfix $file || true;
    md5sum $file;
done

# Fontsetter
# Fontsetter
for file in fontsetter/*.fontsetter;
do
    echo "fontsetting $file";
    FONTSETTER=`basename $file`;
    FONT=fonts/ttf/${FONTSETTER//.fontsetter/.ttf};
    gftools-fontsetter -o $FONT $FONT $file;
done

# Rename Semibold to SemiBold
for file in fonts/ttf/*Semibold*.ttf;
do
    ttx_file=${file//.ttf/.ttx};
    ttx -t name $file;
    # Rename in file
    sed -i '' 's/Semibold/SemiBold/g' $ttx_file;
    ttx -m $file $ttx_file;
    mv ${file//.ttf/#1.ttf} $file;
    rm $ttx_file;
done
mv fonts/ttf/LibertinusSerif-Semibold.ttf fonts/ttf/LibertinusSerif-SemiBold.ttf
mv fonts/ttf/LibertinusSerif-SemiboldItalic.ttf fonts/ttf/LibertinusSerif-SemiBoldItalic.ttf