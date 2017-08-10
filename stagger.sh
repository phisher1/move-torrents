#!/bin/bash 

# set these variables

# location of dir with .torrents
dot_torrents_dir="/usb/torrents/.dot.torrents"

# location of download dir of torrent program
download_dir="/usr/torrents/download"

# maximum number of torrents to add per the interval
max_per_interval=20

# internal at which it should add the above number of torrents in seconds
interval=3600

# logfile
log_file=migrate.log

# move torrent from original directory after adding to watch?
move_torrent=1

# if move_torrent is enabled, directory to move torrent file to
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
   mv "${dot_torrents_dir}/$torrent" ${move_torrent_dir}
   log_and_echo "Moved \"${dot_torrents_dir}/$torrent\" to ${move_torrent_dir}"
}

## script
torrentcount=1
filecount=0
log_and_echo "Starting Script"
ls -l ${dot_torrents_dir} |grep -v "total"| cut -c51-1000|while read torrent; do
   torrent_dir_name=`/torrent_dir_name.py "${dot_torrents_dir}/${torrent}"`
   if [ -z "${torrent_dir_name}" ] ; then
      log_and_echo "No DIR_DATA found in ${torrent}"
      if [[ ${move_torrent} -eq 1 ]]; then move_torrent "${torrent}"; fi
   else
      old_dir_name=`find /usb/torrents/download/old -maxdepth 1 -name "${torrent_dir_name}"`
      if [ -z "$old_dir_name" ]; then
         log_and_echo "$old_dir_name was not found -  ${torrent}"
         if [[ ${move_torrent} -eq 1 ]]; then move_torrent "${torrent}"; fi
      else
         log_and_echo "mv \"${old_dir_name}\" /usb/torrents/download/"
         mv "${old_dir_name}" /usb/torrents/download/
         log_and_echo "cp \"${dot_torrents_dir}/${torrent}\" /usb/torrents/watch"
         cp "${dot_torrents_dir}/${torrent}" /usb/torrents/watch
         if [[ ${move_torrent} -eq 1 ]]; then move_torrent "${torrent}"; fi
         filecount=$(($filecount+1))
         if [[ ${filecount} -eq ${max_per_internal} ]]; then
            torrentcount=$(($torrentcount+1))
            sleep ${interval}
            filecount=0
         fi
      fi
   fi
done
