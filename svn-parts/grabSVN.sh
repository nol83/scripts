#!/bin/bash

curl -s "http://10.4.0.123" > svnsource

while read line
do
  repo=$(grep '<a href="listing.php?repname=' | awk 'BEGIN{FS="="}{print $3}' | awk 'BEGIN{FS="&"}{print$1}')
 echo "$repo\n" >> repolist
done < svnsource
