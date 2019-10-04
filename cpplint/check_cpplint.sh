#!/bin/bash

print_help(){
    echo -e "$(tput setaf 1)    bash check_cpplint.sh [single-package directory]$(tput setaf 7)"
}

declare script_path=`readlink -f $0`
declare script_dir=`dirname ${script_path}`

declare cpplint_option="--recursive"

# fetch ros-workspace root
declare catkin_root=`pwd`

if [ $# == 1 ]; then
    catkin_root=`readlink -f "$1"`
    if [ -d ${catkin_root} ]; then
        cpplint_option="--repository=${catkin_root}/.. ${cpplint_option}"

        # check using cpplint.py
        python ${script_dir}/cpplint.py ${cpplint_option} ${catkin_root}
    else
        print_help
        exit -1
    fi
else
    echo -e "$(tput setaf 3)    checking cpplint on current ros workspace ${catkin_root}$(tput setaf 7)"
    for package in `find ${catkin_root}/src -name package.xml`
        do
            package_root=`dirname ${package}`
            echo -e "$(tput setaf 3)\n\n  ${package_root}$(tput setaf 7)"
            bash ${script_path} ${package_root}
        done
fi