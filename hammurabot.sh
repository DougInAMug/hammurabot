#!/bin/bash

# post at random times in the day, to diversify exposure
echo "random sleep for up to 23 hours beginning..."
sleepTime="$((RANDOM % 23))h"
# log script start and sleep times... because I still don't fully trust cron
echo -n "START: $(date +"%Y-%m-%d %T")	SLEEP: $sleepTime	" >> log
#sleep "$sleepTime"

# create lawCounter.log and set to 0 if not present
if [ ! -f lawCounter.log ]
then
  touch lawCounter.log
  echo "0" > lawCounter.log
fi

# main
lastLaw=$(cat lawCounter.log)
law=$((lastLaw + 1))
echo -n "LAW: $law	" >> log
lawText=$(head codeOfHammurabi.txt -n $law | tail -n 1)

# line smaller than one standard toot? Easy:
if [ "${#lawText}" -lt 475 ]; then
  echo "$lawText" > toot1
  toot post < toot1
  rm toot1
# line longer than a toot? Here we go...
else
  # here-string array construction https://tldp.org/LDP/abs/html/x17837.html in order to be POSIX compliant
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

  toot post --no-color < toot1 > lastPost.log
  postCounter=2
  while [ "$postCounter" -le "$tootCounter" ]; do
    postNext=$"toot"$postCounter""
    lastPost=$(cat lastPost.log)
    toot post --no-color -r "${lastPost//[!0-9]/}" -v unlisted < "$postNext" > lastPost.log
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
echo "POST: $(date +"%Y-%m-%d %T")" >> log
