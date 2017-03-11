#!/bin/bash
#MAINTAINER Ion Pantalon <nanu_rtc@yahoo.com>

START=$(date +%s)

bold_text=$(tput bold)
normal_text=$(tput sgr0)

BROWN="\033[0;33m"
RED='\033[0;31m'
NC='\033[0m' #no color

execute_task="${bold_text}Executing task:${normal_text}"

timestamp=$(date +%s)

number_of_releases=5
container_name=my-container-name
container_deploy_path=/home/www/my-project-name
current_path=/home/www/my-project-name
releases=/home/www/my-project-name/releases

#add extra file for config if needed
domain_filename=config.php
docker_id=$(docker ps -aqf "name=$container_name")

releases(){
    if [ ! -d "$releases" ]; then
        echo -e "$execute_task Creating releases directory"
        mkdir -p $releases
    fi

    cd $releases/
    count_dir=$(find ./ -maxdepth 1 -type d | wc -l)

    if [ $(( $count_dir )) -gt $number_of_releases ]; then
        first_release=$(ls | sort -n | head -1)
        echo -e "$execute_task Removing $first_release directory"
        rm -rf $first_release
    fi

    mkdir release_${timestamp}
    last_release=$PWD/$(ls -td -- */ | head -n 1)
    cd -
}

sync_git(){
    releases  #call releases to generate the dir

    if [ -d "$last_release" ]; then
        echo -e "$execute_task Fetching from git"
        git clone git@bitbucket.org:my-username/project-name.git $last_release

	echo -e "$execute_task Creating symlink"
	ln -sfT $last_release $current_path/current
    fi
}

deploy_to_container(){
    echo -e "$execute_task Deploying the files to $container_name container"
    docker cp $current_path/current/. $container_name:$container_deploy_path
}

add_domainfile(){
    echo $PWD
    if [ ! -f $1 ]; then
        echo -e "${RED}The file '$1' was not found!${NC}"
    else
        echo -e "$execute_task Add '$1' to $container_name"
        docker cp $1 $container_name:$container_deploy_path/
    fi
}

ownership(){
    echo -e "$execute_task Change ownership to my_user:apache"
    cd $current_path/current/
    chown -R my-user:apache *
    chown -R my-user:apache .*
    cd -
}

permission(){
    echo -e "$execute_task Change permission"
    cd $current_path/current/
    chmod 0755 -R .
    chmod 0775 -R src/resources
    chmod 0775 -R src/tmp
    chmod 0775 -R src/cache
    cd -
}

run(){
    #releases 5
    sync_git
    ownership
    permission
    deploy_to_container
    add_domainfile $domain_filename
    add_hostfile $host_filename
}

#now let's run the process
echo "------- Running --------"
run

END=$(date +%s)
DIFF=$(echo "$END - $START" | bc)

echo -e "${BROWN}Deployed succesfully in $DIFF seconds${NC}"
exit 1


