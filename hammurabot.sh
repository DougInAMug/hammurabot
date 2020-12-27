#!/bin/bash

# post at random times in the day, to diversify exposure
echo "random sleep for up to 23 hours beginning..."
sleep $((RANDOM % 23))h

# main
lastLaw=$(cat lawCounter.log)
law=$((lastLaw + 1))
lawText=$(head codeOfHammurabi.txt -n $law | tail -n 1)
if [ "${#lawText}" -lt 475 ]; then
  echo "$lawText" > toot1
  toot post < toot1
  rm toot1
else
  # here-string array construction
  IFS=" " read -r -a lawTextArray <<< "$lawText"
  arrayCounter=0
  remainingChars=$(printf "%s " "${lawTextArray[@]}" | wc -m)
  tootCounter=1  
  while [ "$remainingChars" -gt 475 ]; do
    thisToot=$"toot"$tootCounter""
    touch $thisToot
    tootNextCycleLength=0
    while [ "$tootNextCycleLength" -lt 475 ]; do
      echo -n "${lawTextArray[arrayCounter]} " >> $thisToot
      unset "lawTextArray[arrayCounter]"
      arrayCounter=$((arrayCounter + 1))
      thisTootLength=$(wc -m < $thisToot)
      tootNextCycleLength=$((thisTootLength + ${#lawTextArray[arrayCounter]}))
    done
    echo -n "..." >> $thisToot
    remainingChars=$(printf "%s " "${lawTextArray[@]}" | wc -m)    
    tootCounter=$((tootCounter + 1))
  done
  lastToot=$"toot"$tootCounter""
  touch $lastToot
  printf "%s " "${lawTextArray[@]}" > $lastToot
  
  toot post < toot1 > lastPost.log
  postCounter=2
  while [ "$postCounter" -le "$tootCounter" ]; do
    postNext=$"toot"$postCounter""
    lastPost=$(cat lastPost.log)
    toot post -r "${lastPost//[!0-9]/}" -v unlisted < "$postNext" > lastPost.log
    postCounter=$((postCounter + 1))
  done 
  rm toot*
  rm lastPost.log
fi

# increment or reset lawcounter
if [ "$law" -lt 282 ]; then
  echo "$law" > lawCounter.log
else
  echo "0" > lawCounter.log
fi

# log date & time of posts
date >> posted.log
