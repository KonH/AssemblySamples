if [ $# -ne 1 ]; 
    then echo "Please provide filename without extension!"
    exit 1
fi

FILENAME=$1

echo "Clean up..."
rm -f $FILENAME
rm -f $FILENAME.o

echo "Building '$FILENAME' with nasm"
nasm -f macho64 "$FILENAME.asm"
if [ ! -f $FILENAME.o ]; then
    echo "File '$FILENAME.o' is not found!"
    exit 1
fi

echo "Linking '$FILENAME.o' with ld"
ld -lSystem "$FILENAME.o" -o "$FILENAME"
if [ ! -f $FILENAME ]; then
    echo "File '$FILENAME' is not found!"
    exit 1
fi

echo 'Build finished'
echo 'Running...'
./$FILENAME
echo "Finished with $? exit code"

 