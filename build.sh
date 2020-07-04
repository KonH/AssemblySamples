if [ $# -ne 1 ]; 
    then echo "Please provide filename without extension!"
    exit 1
fi
FILENAME=$1
echo "Building '$FILENAME'"
rm -f $FILENAME
rm -f $FILENAME.o
as $FILENAME.asm -o $FILENAME.o
ld $FILENAME.o -lSystem -e _main -o $FILENAME
echo 'Build finished'