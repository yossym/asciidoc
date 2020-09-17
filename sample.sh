#!/usr/bin/bash
# set -x

# declare ls_result=$(ls *.adoc)
declare ls_result=$(ls *.adoc)

echo ${#ls_result[0]}
echo ${#ls_result[*]}

declare i=0
if [ ${#ls_result[0]} -gt 0 ] ; then
    for line in ${ls_result}
    do
        echo  ${line} ${i}
        let i++
        # i=${i}+1
    done
fi


if [ -a *.txt ]; then

    ls_result=$(ls *.txt)

    echo ${#ls_result[0]}
    echo ${#ls_result[*]}

    declare i=0
    if [ ${#ls_result[0]} -gt 0 ] ; then
        for line in ${ls_result}
        do
            echo  ${line} ${i}
            let i++
            # i=${i}+1
        done
    fi

fi
