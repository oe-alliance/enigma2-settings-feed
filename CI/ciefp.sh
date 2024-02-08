#!/bin/bash

# Script by jbleyel for https://github.com/oe-alliance

PVER="1.1"
PR="r0"
PACK="ciefp"
LOCAL="local"
GITREPRO="ciefp/ciefpsettings-enigma2"
PACKNAME="enigma2-plugin-settings-ciefp"
D=$(pwd) &> /dev/null
PD=${D}/$LOCAL
B=${D}/build
TMP=${D}/tmp
R=${D}/feed
Homepage="https://github.com/ciefp/ciefpsettings-enigma2"

function MakeIPK ()
{

    rm -rf ${B}
    rm -rf ${TMP}
    mkdir -p ${B}
    mkdir -p ${TMP}
    mkdir -p ${TMP}/CONTROL

    mkdir -p ${TMP}/etc/enigma2/
    cp -rp ${PD}/$1/* ${TMP}/etc/enigma2/

cat > ${TMP}/CONTROL/control << EOF
Package: ${PACKNAME}-${2}
Version: ${3}
Description: ${PACK} enigma2 settings ${2}
Section: base
Priority: optional
Maintainer: OE-Core Developers <openembedded-core@lists.openembedded.org>
License: Proprietary
Architecture: all
OE: ${PACKNAME}-${2}
Source: ${Homepage}
EOF

	tar -C ${TMP}/CONTROL -czf ${B}/control.tar.gz .
	rm -rf ${TMP}/CONTROL

    PKG="${PACKNAME}-${2}_${3}_all.ipk"
    tar -C ${TMP} -czf ${B}/data.tar.gz .
    echo "2.0" > ${B}/debian-binary
	cd ${B}
	ls -l
	ar -r ${R}/${PKG} ./debian-binary ./control.tar.gz ./data.tar.gz 
	cd ${D}

}

GITCOMMITS=$(curl  --silent -I -k "https://api.github.com/repos/$GITREPRO/commits?per_page=1" | sed -n '/^[Ll]ink:/ s/.*"next".*page=\([0-9]*\).*"last".*/\1/p')
GITHASH=$(git ls-remote https://github.com/$GITREPRO HEAD | sed -e 's/^\(.\{7\}\).*/\1/')
#OLDHASH=$(head -n 1 $PACK.hash 2>/dev/null)

#if [ "$OLDHASH" == "$GITHASH" ]; then
#    exit 0
#fi
#echo $GITHASH > $PACK.hash

rm -rf ${PD}
git clone --depth 1 ${Homepage} local

VER="$PVER+git$GITCOMMITS+${GITHASH}_r0"

mkdir -p ${R}

rm -rf ${D}/feed/${PACKNAME}*.ipk

MakeIPK ciefp-E2-1sat-19E 19e ${VER}
MakeIPK ciefp-E2-2satA-19E-13E 19e.13e ${VER}
MakeIPK ciefp-E2-2satB-19E-16E 19e.16e ${VER}
MakeIPK ciefp-E2-3satA-9E-10E-13E 9e.10e.13e ${VER}
MakeIPK ciefp-E2-3satB-19E-16E-13E 19e.16e.13e ${VER}
MakeIPK ciefp-E2-4satA-28E-19E-13E-30W 28e.19e.13e.30w ${VER}
MakeIPK ciefp-E2-4satB-19E-16E-13E-0.8W 19e.16e.13e.0.8w ${VER}
MakeIPK ciefp-E2-5sat-19E-16E-13E-1.9E-0.8W 19e.16e.13e.1.9e.0.8w ${VER}
MakeIPK ciefp-E2-6sat-23E-19E-16E-13E-1.9E-0.8W 23e.19e.16e.13e.1.9e.0.8w ${VER}
MakeIPK ciefp-E2-7sat-23E-19E-16E-13E-4.8E-1.9E-0.8W 23e.19e.16e.13e.1.9e.0.8w ${VER}
MakeIPK ciefp-E2-8sat-28E-23E-19E-16E-13E-4.8E-1.9E-0.8W 28e.23e.19e.16e.13e.4.8e.1.9e.0.8w ${VER}
MakeIPK ciefp-E2-9sat-39E-28E-23E-19E-16E-13E-4.8E-1.9E-0.8W 39e.23e.19e.16e.13e.4.8e.1.9e.0.8w ${VER}
MakeIPK ciefp-E2-10sat-39E-28E-23E-19E-16E-13E-9E-4.8E-1.9E-0.8W 39e.28e.23e.19e.16e.13e.9e.4.8e.1.9e.0.8w ${VER}
MakeIPK ciefp-E2-13sat-42E-39E-28E-23E-19E-16E-13E-9E-7E-4.8E-1.9E-0.8w-5w 42e.39e.28e.23e.19e.16e.13e.9e.7e.4.8e.1.9e.0.8w.5w ${VER}
MakeIPK ciefp-E2-16sat-42E-39E-28E-26E-23E-19E-16E-13E-10E-9E-7E-4.8E-1.9E-0.8w-4W-5w 42e.39e.28e.26e.23e.19e.16e.13e.10e.9e.7e.4.8e.1.9e.0.8w.4w.5w ${VER}
MakeIPK ciefp-E2-18sat-42E-39E-36E-33E-28E-26E-23E-19E-16E-13E-10E-9E-7E-4.8E-1.9E-0.8w-4W-5w 42e.39e.36e.33e.28e.26e.23e.19e.16e.13e.10e.9e.7e.4.8e.1.9e.0.8w.4w.5w ${VER}
MakeIPK ciefp-E2-motor-75E-34W motor.75e.34w ${VER}
