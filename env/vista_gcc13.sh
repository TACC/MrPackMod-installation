module reset
module use ${WORK}/modulefiles/Core
module load gcc/13.2.0
echo -e "\ngcc loaded\n"
modulelist
module -t avail openmpi
module load openmpi/5.0.5
echo -e "\nopenmpiloaded\n"
modulelist
module load cuda nvpl nvidia_math
echo -e "\ncuda loaded\n"
modulelist


