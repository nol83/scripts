#!/bin/bash

if [ -a recentRepos ]
then
  rm recentRepos
fi

while read line
do
  years=$(echo "$line" | awk 'BEGIN { FS = "-"}{print $1}')
  if [ $years -ge 2013 ]
  then
     echo $line >> recentRepos
  else
    if [ $years -eq 2012 ]
    then
      months=$(echo "$line" | awk 'BEGIN { FS = "-"}{print $2}')
      if [ $months -gt 5 ]
      then
        echo $line >> recentRepos
      else
        if [ $months -eq 5 ]
        then
          days=$(echo "$line" | awk 'BEGIN { FS = "-"}{print $3}' | awk 'BEGIN { FS = " "}{print $1}')
          if [ $days -gt 20 ]
          then
            echo $line >> recentRepos
          fi
        fi  
      fi
    fi
  fi
done < svnreporeport
