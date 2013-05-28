#!/bin/bash

finaldate=$1

set -- $(echo "$finaldate" | awk 'BEGIN {FS="-"}{print $1,$2,$3}')
endyear=$1
endmonth=$2
endday=$3

while read line
do
  years="$(echo "$line" | awk 'BEGIN { FS = "-"}{print $1}')"
  if [ $years -ge $endyear ]
  then
     echo $line >> recentRepos
  else
    if [ $years -eq $((endyear-1)) ]
    then
      months=$(echo "$line" | awk 'BEGIN { FS = "-"}{print $2}')
      if [ $months -gt $endmonth ]
      then
        echo $line >> recentRepos
      else
        if [ $months -eq $endmonth ]
        then
          days=$(echo "$line" | awk 'BEGIN { FS = "-"}{print $3}' | awk 'BEGIN { FS = " "}{print $1}')
          if [ $days -gt $endday ]
          then
            echo $line >> recentRepos
          fi
        fi
      fi
    fi
  fi
done < svnreporeport

echo $endyear
