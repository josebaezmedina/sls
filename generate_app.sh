#!/usr/bin/env bash

ver=$( head -n1 project.clj | cut -d " " -f3 | tr -d '"' )


srcdir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )
echo "generating app image for this machine"
echo ""

echo "cleaning app directory"
rm -rf  $srcdir/bin/sls_app

echo "generating uberjar"
lein uberjar

echo "generating app image with jpackage"

# echo "${srcdir}"

jpackage \
--input $srcdir/target/uberjar/ \
--dest $srcdir/bin \
--name "sls" \
--main-jar $srcdir/target/uberjar/sls-$ver-standalone.jar \
--main-class sls.core \
--type app-image

echo ""
echo "App image generate for this machine"

echo ""
echo "generate symlink in /home/yourusername/bin"

if [ ! -d ~/bin ];
then
   mkdir -p ~/bin
fi;

ln -sf ${srcdir}/bin/sls_app/bin/sls ~/bin/sls

echo "link created"

read -p "Do you wish to add ~/bin to your path? (y/n)" -n 1 r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
   PATH="${PATH:+${PATH}:}~/bin" 
else
  exit 1
fi