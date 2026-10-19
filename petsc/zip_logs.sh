#!/bin/bash

version=$( mpm.py version )
logs=$( ls $STOCKYARD/petsc/petsc-$version/$version/lib/petsc/conf/{configure,make}.log )
ls -l $logs

set -x
zip petsclogs.zip $logs
