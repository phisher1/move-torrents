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



## functions
# get time
get_time () {
   date=`date +"%Y-%m-%d %H:%M"`
   echo $date
}

# log and echo
log_and_echo () {
   current_time=$(get_time)
   echo -e "$current_time - $1"
   echo -e "$current_time - $1" >> ${log_file}
}


## script
torrentcount=1
filecount=0
log_and_echo "Starting Script"
ls -l ${dot_torrents_dir} |grep -v "total"| cut -c51-1000|while read torrent; do
   torrent_dir_name=`/torrent_dir_name.py "${dot_torrents_dir}/$torrent"`
   if [ -z "${torrent_dir_name}" ] ; then
      log_and_echo "No DATA found in ${torrent}"

         # temp
         log_and_echo "mv \"${dot_torrents_dir}/$torrent\" /home/dcorrigan/torrent-migrate/migrated.dot.torrents"
         mv "${dot_torrents_dir}/$torrent" /home/dcorrigan/torrent-migrate/migrated.dot.torrents

   else
      old_dir_name=`find /usb/torrents/download/old -maxdepth 1 -name "${torrent_dir_name}"`
      if [ -z "$old_dir_name" ]; then
         log_and_echo "No DIR found for ${torrent}"

         # temp
         log_and_echo "mv \"${dot_torrents_dir}/$torrent\" /home/dcorrigan/torrent-migrate/migrated.dot.torrents"
         mv "${dot_torrents_dir}/$torrent" /home/dcorrigan/torrent-migrate/migrated.dot.torrents

      else

         log_and_echo "mv \"${old_dir_name}\" /usb/torrents/download/"
         mv "${old_dir_name}" /usb/torrents/download/
         log_and_echo "cp \"${dot_torrents_dir}/$torrent\" /usb/torrents/watch"
         cp "${dot_torrents_dir}/$torrent" /usb/torrents/watch

         # temp
         log_and_echo "mv \"${dot_torrents_dir}/$torrent\" /home/dcorrigan/torrent-migrate/migrated.dot.torrents"
         mv "${dot_torrents_dir}/$torrent" /home/dcorrigan/torrent-migrate/migrated.dot.torrents


         filecount=$(($filecount+1))
         if [[ $filecount -eq $max_per_internal ]]; then
            torrentcount=$(($torrentcount+1))
            sleep $interval
            filecount=0
         fi
      fi
   fi
done
