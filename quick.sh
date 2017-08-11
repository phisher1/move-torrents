#!/bin/bash
get_time () {
   if [[ $1 == "next_run" ]]; then
      date=$(date -d "+ 30 seconds" +'%Y-%m-%d %H:%M:%S')
   else
      date=`date +"%Y-%m-%d %H:%M:%S"`
   fi
   echo ${date}
}


#var1=$(get_time)
#date
var=`get_time`
var2=`get_time next_run`
echo "$var $var2"

#date=`date +"%Y-%m-%d %H:%M:%S"`
#echo $date
#date=$(date -d "+ 30 seconds" +'%Y-%m-%d %H:%M:%S')
#echo $date

