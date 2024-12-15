# Functions
Help()
{
	echo "No options implemented"
}

# Get options
while getopts ":h" option; do
   case $option in
      h) # display Help
         Help
         exit;;
   esac
done

# Script body
mkdir -p build-files
mkarchiso -v -w /tmp/archiso-build -o build-files/ profile/
