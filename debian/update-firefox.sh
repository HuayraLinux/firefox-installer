#!/bin/bash

work_dir=`mktemp -d --suffix=.update-firefox`
moz_url='http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/latest'
wget -O "$work_dir/MD5SUMS" "$moz_url/MD5SUMS"

moz_lang=`echo $LANG | cut -f 1 -d . | sed s/_/-/`

moz_arch=`uname -m`
moz_link=`grep linux-$moz_arch/$moz_lang $work_dir/MD5SUMS |grep bz2`

moz_md5=`echo $moz_link | cut -f 1 -d " "`
moz_path=`echo $moz_link | cut -f 2 -d " "`
moz_file=`basename $moz_path`

echo "$moz_md5 $work_dir/$moz_file" >> "$work_dir/VERIFY.MD5"
wget -O "$work_dir/$moz_file" "$moz_url/$moz_path"
md5sum -c "$work_dir/VERIFY.MD5"

if [ $? = 0 ]; then
    echo "md5sum OK"
    rm -rf /opt/firefox
    tar xvjf "$work_dir/$moz_file" -C "$work_dir"
    mv "$work_dir/firefox" /opt    
    rm -rf "$work_dir"
    echo "Instalacion finalizada"
    
else
    echo "md5sum ERROR"
fi

# rm -rf $work_dir
