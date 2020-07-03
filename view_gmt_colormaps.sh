#!/bin/bash

if [[ $# -ne 1 ]]; then 
  echo "usage: $0 <gmt_cpts_dir>"
  echo "script to view all available CPTs (colormaps) on this computer."
  echo "provide the location of GMT colormap files on this computer. Probably it is /usr/local/share/cpt, or /opt/local/share/cpt, or similar."
  exit 1
fi

gmt gmtset PS_MEDIA A0

i=-1
yoffset=-1.2i
xoffset=0i
ps=gmt_cmaps.ps

gmt psbasemap -JX5i -R0/1/0/1 -B+n -V -P -K > $ps

for cpt in `ls $1/*`; do
    i=`echo $i | awk '{print $1 + 1}'`
    irem=`echo $i |awk '{print $1%9}'`
    cptbase=$(basename $cpt .cpt)
    if [[ $irem == 0 ]]; then
        gmt psscale -Y9.6i -X3.5i -J -R -C$cpt -Dx0/-0.4i+w3i/0.18i+h -O -K -B1000000:"$cptbase": >> $ps
    else
        gmt psscale -Y$yoffset -X$xoffset -J -R -C$cpt -Dx0/-0.4i+w3i/0.18i+h -O -K -B1000000:"$cptbase": >> $ps
    fi
done

gmt psxy -J -R -O -T >> $ps
gmt psconvert -A1p -Tg $ps
open $(basename $ps .ps).png
rm -f *cpt $ps gmt.conf gmt.history
