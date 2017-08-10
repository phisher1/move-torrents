#!/bin/bash

# set these variables

# location of dir with .torrents
dot_torrents_dir="/usb/torrents/.dot.torrents"

# location of watch dir
watch_dir="/usb/torrents/watch"

# location of download dir of torrent program
download_dir="/usb/torrents/download"

# maximum number of torrents to add per the interval
max_per_interval=10

# internal at which it should add the above number of torrents in seconds
interval=300

# logfile
log_file=migrate.log

# move .torrent from original directory after adding to watch?
move_torrent=1

# if move_torrent is enabled, directory to move .torrent file to
move_torrent_dir=/home/dcorrigan/torrent-migrate/migrated.dot.torrents


## functions
# get time
get_time () {
   date=`date +"%Y-%m-%d %H:%M"`
   echo ${date}
}

# log and echo
log_and_echo () {
   current_time=$(get_time)
   echo -e "${current_time} - $1"
   echo -e "${current_time} - $1" >> ${log_file}
}

# move torrent after copying to watch folder
move_torrent () {
   torrent=$1
   log_and_echo "Moving \"${dot_torrents_dir}/$torrent\" to ${move_torrent_dir}"
   mv "${dot_torrents_dir}/$torrent" ${move_torrent_dir}
}

## script
torrentcount=1
filecount=0
log_and_echo "Starting Script"
ls -l ${dot_torrents_dir} |grep -v "total"| cut -c51-1000|while read torrent; do
   torrent_dir_name=`./torrent_dir_name.py "${dot_torrents_dir}/${torrent}"`
   if [ -z "${torrent_dir_name}" ] ; then
      log_and_echo "No DIR_DATA found in ${torrent}"
      if [[ ${move_torrent} -eq 1 ]]; then move_torrent "${torrent}"; fi
   else
      old_dir_name=`find ${download_dir}/old -maxdepth 1 -name "${torrent_dir_name}"`
      if [ -z "$old_dir_name" ]; then
         log_and_echo "$old_dir_name was not found -  ${torrent}"
         if [[ ${move_torrent} -eq 1 ]]; then move_torrent "${torrent}"; fi
      else
         log_and_echo "Moving \"${old_dir_name}\" to ${download_dir}/"
         mv "${old_dir_name}" ${download_dir}/
         log_and_echo "Copying \"${dot_torrents_dir}/${torrent}\" to ${watch_dir}"
         cp "${dot_torrents_dir}/${torrent}" ${watch_dir}
         if [[ ${move_torrent} -eq 1 ]]; then move_torrent "${torrent}"; fi
         filecount=$(($filecount+1))
         if [[ ${filecount} -eq ${max_per_interval} ]]; then
            torrentcount=$(($torrentcount+1))
            log_and_echo "Sleeping now.. Max torrents per interval added. ($max_per_interval per $interval seconds)"
            sleep ${interval}
            filecount=0
         fi
      fi
   fi
done
