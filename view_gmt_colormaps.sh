#!/bin/bash

gmt gmtset PS_MEDIA A0

i=0
yoffset=1.2i
xoffset=0i
ps=gmt_cmaps.ps

gmt psbasemap -JX5i -R0/1/0/1 -B+n -V -P -K > $ps

for cpt in `ls /opt/local/share/gmt/cpt`; do
    i=`echo $i | awk '{print $1 + 1}'`
    echo $i
    irem=`echo $i |awk '{print $1%9}'`
    echo $irem
    cptbase=$(basename $cpt .cpt)
    echo $cptbase
    scaledcpt=$cptbase.scaled.cpt
    echo "gmt makecpt -C$cptbase -T0/1/0.01 -D -Z > $cpt"
    gmt makecpt -C$cptbase -T0/1/0.01 -D -Z > $scaledcpt
    if [[ $irem == 0 ]]; then
        gmt psscale -Y-9.6i -X3.5i -J -R -C$scaledcpt -Np -Dx0/-0.4i+w3i/0.18i+h -O -K -B1:"$cpt": >> $ps
    else
        gmt psscale -Y$yoffset -X$xoffset -J -R -C$scaledcpt -Np -Dx0/-0.4i+w3i/0.18i+h -O -K -B1:"$cpt": >> $ps
    fi
done

gmt psxy -J -R -O -T >> $ps
gmt psconvert -A1p -Tg $ps
open $(basename $ps .ps).png
rm -f *cpt $ps gmt.conf gmt.history
