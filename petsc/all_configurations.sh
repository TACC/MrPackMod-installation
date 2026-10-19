#!/bin/bash

function usage () {
    echo "Usage: $1 [ -h ] [ -j 123 ] [ -t : trace ]"
    echo "    [ -f : skip fortran ]"
    # echo "    [ --install big/small]"
}

export installation=big
fortran=ON
jcount=6
traceflag=
while [ $# -gt 0 ] ; do
    if [ $1 = "-h" ] ; then
	usage && exit
    elif [ $1 == "--install" ] ; then
    	shift && installation=$1 && shift
    elif [ "$1" = "-f" ] ; then
	fortran=OFF && shift
    elif [ "$1" = "-j" ] ; then
	shift && jcount=$1 && shift
    elif [ "$1" = "-t" ] ; then
	traceflag="-t" && shift
    else
	echo "Unknown option <<$1>>" && usage && exit 1
    fi
done

for cuda in ON OFF ; do
    for i in 64 32 ; do
	export INTSIZE=$i
	for s in single real complex ; do
	    export SCALAR=$s
	    for d in OFF ON ; do
		echo -e "================\nInstalling with:\ncuda=${cuda}\nint=${i}\nscalar=${s}\ndebug=${d}\nfortran=${fortran}\n================"
		ext=$s$i$d$( if [ "${cuda}" = "ON" ] ; then echo cuda ; fi )
		scriptsdir=${PWD}/mpm_scripts_${ext}		   
		SCRIPTSDIR=${scriptsdir} \
       	        INSTALLATION=${installation} DEBUG=${d} \
	        HAS_CUDA=${cuda} \
		HAS_FORTRAN=${fortran} \
	            mpm.py -j ${jcount} install
		echo "(see logs in ${scriptsdir})"
	    done
	done
    done
done

