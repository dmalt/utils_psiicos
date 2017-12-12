#!/usr/bin/env bash

startup_path="$HOME/Documents/MATLAB/startup.m"

echo "Writing current path to $startup_path"
echo "path(path, '$PWD');"  >> "$startup_path"

if [ "$1" == "--data" ]; then
    ./get_simulations_data.sh
    ./get_test_data.sh
fi

while [ "$1" != "" ]; do
    case $1 in
        -s | --sim-data )   ./get_simulations_data.sh
                            ;;
        -t | --test-data )  ./get_test_data.sh
                            ;;
        -h | --help )       echo "-s | --sim-data: downloads simulations data"
                            echo "-t | --test-data: downloads test data"
    esac
    shift
done
