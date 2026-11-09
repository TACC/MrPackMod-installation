##
## Basic setup
##
module purge
module reset
module -t list 2>&1 \
    | awk '{v=v " " $1} END { print "Initial modules: " v }'

##
## My modules
##
NV_VERSION=26.9
module unload nvidia openmpi cuda 2>/dev/null
export MODULEPATH=${WORK}/modulefiles/Core\
:${WORK}/modulefiles/Compiler/nvidia/${NV_VERSION}\
:${MODULEPATH}
module -t load nvidia/${NV_VERSION}
module -t list 2>&1 \
    | awk '{v=v " " $1} END { print "Modules: " v }'
#
echo -e "\nPossible openmpi:"
module -t avail openmpi
OMPI_VERSION=5.0.9
module -t load openmpi/${OMPI_VERSION}
module -t list 2>&1 \
    | awk '{v=v " " $1} END { print "Modules: " v }'
#
echo -n "\nPossible cuda:"
module -t avail cuda
cudaversion=13.3
module -t load cuda/${cudaversion}
MODULEPATH=\
${WORK}/modulefiles/Compiler/nvidia/${NV_VERSION}\
:${MODULEPATH}
echo "now available openmpi:"
module -t avail openmpi
module -t load openmpi/${OMPI_VERSION}

echo "Load nvpl/math"
module -t load nvpl nvidia_math

# #module load nvhpc-hpcx

#
# listing
#
which modulelist >/dev/null 2>&1
if [ $? -eq 0 ] ; then
    modulelist
else
    module -t list 2>&1 \
	| awk '{v=v " " $1} END { print "Modules: " v }'
fi

echo -e "Done setting up nvidia 26 environment\n"
