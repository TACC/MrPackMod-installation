#!/bin/bash

configuration=Configuration
jcount=6
while [ $# -gt 0 ] ; do
    if [ "$1" = "-h" ] ; then 
	echo "Usage: $0 [ -j 123 ] [ -c configuration ] [ -v : package version ]"
	exit 0
    elif [ "$1" = "-j" ] ; then 
	shift && jcount=$1 && shift
    elif [ "$1" = "-c" ] ; then
	shift && configuration="$1" && shift
    elif [ "$1" = "-v" ] ; then
	shift && version=$1 && shift
    fi
done

##
## What are we installing?
##
package=$( mpm.py package )
if [ -z "${version}" ] ; then
    version="$( mpm.py version )"
fi

all_log=all_${package}.log
rm -f ${all_log}
touch ${all_log}

##
## find compilers to use
##
compilersfile=${HOME}/Testing/compilers_${TACC_SYSTEM}.sh
if [ ! -f "$compilersfile" ] ; then
    echo "Could not find compilersfile: $compilersfile" && exit 1
fi
compilers="$( cat $compilersfile )"
echo "Going to install <<$package>> for compilers: <<$compilers>>" \
     | tee -a ${all_log}

##
## do install for all compilers
##
for compiler in $compilers ; do
    compiler=$( echo ${compiler} | tr -d '/' )
    ##
    ## skip if we explicitly requested a compiler
    ##
    if [ ! -z "$compilerselect" -a "$compiler" != "$compilerselect" ] ; then
	echo "Compiler <<$compiler>> does not match selected compiler <<$compilerselect>>"
	continue
    fi
    ##
    ## read settings file for this compiler
    ##
    settings=../env/${TACC_SYSTEM}_${compiler}.sh
    if [ ! -f ${settings} ] ; then
	echo "----" && echo "No such settings file: $settings" && echo "----"
	continue
    else
	echo "================================================================"
	echo "================ Compiler: ${compiler} ================"
	echo "================================================================"
	source ${settings} 
	##
	## load prerequisites
	##
	for m in $( mpm.py modules ) ; do
	    echo "loading prereq module <<$m>>"
	    module load $m 2>/dev/null
	    if [ $? -gt 0 ] ; then echo "ERROR could not load $m"exit 1 ; fi
	done
	module -t list 2>&1
	##
	## and go
	##
	PACKAGEVERSION=${version} mpm.py  -j ${jcount} -c ${configuration} install
    fi
done 2>&1 | tee -a ${all_log}

##
## report available installation
## of this package, this version,
## over all compilers
##
echo "Available installations:"
module -t spider ${package}/${version}
echo && echo "See: all_${package}.log"  && echo
