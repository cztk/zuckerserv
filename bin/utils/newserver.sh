#!/bin/sh

if [ "x$1" = "x" ]
then
    echo "usage: $0 <new server directory>"
    exit 1
fi

DEST=$1


v_system=$(uname)
f_starter=$(basename $0)
d_pwd=$(pwd)
d_main=

if echo $v_system | grep -q "BSD"
then
    d_main=$(dirname $(dirname $(cd $(dirname $0) ; pwd)))
    cd $d_pwd
else
    d_main=$(dirname $(dirname $(dirname $(readlink -f $0))))
fi


mkdir -p $DEST

mkdir $DEST/bin
for aa in utils env.sh sauer_server monitor
do
    ln -s $d_main/bin/$aa $DEST/bin/$aa
done
cp $d_main/bin/server $DEST/bin/

ln -s $d_main/lib $DEST/lib

mkdir $DEST/{script,conf,log}
mkdir $DEST/script/{commands-enabled,modules-enabled}

ln -s $d_main/script/base $DEST/script/
ln -s $d_main/script/package $DEST/script/
### todo .... clean mess up :)
ln -s $d_main/script/commands-available $DEST/script/
ln -s $d_main/script/modules-available $DEST/script/
ln -s $d_main/share $DEST/share
ln -s $d_main/mapinfo $DEST/mapinfo

mkdir $DEST/log/game
mkdir $DEST/log/demo

cp $d_main/conf/server_conf.lua.dist $DEST/conf/server_conf.lua
cp $d_main/conf/maps.lua $DEST/conf/maps.lua
cp $d_main/conf/new_maps.conf $DEST/conf/new_maps.conf
cp $d_main/conf/auth.lua $DEST/conf/auth.lua
