#~/bin/bash

if [ -a "userReport" ]
then
  rm userReport
fi

while read line
do
  #set author
  author="$line"

  #find all the repos this person does
  less recentRepos | grep $author | awk ' BEGIN { FS = " "}{print $3}' > $author
 
 ##Aggregate  
  echo -e "$author \n----------------------------------" >> userReport
  cat $author >> userReport
  echo -e "\n" >> userReport
  rm $author
done < authors
