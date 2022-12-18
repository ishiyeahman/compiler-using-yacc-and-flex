sh c.ch
if [ $? != 0 ]; then
    echo "Command is failed"
    exit 1
else
    ./a.out
fi