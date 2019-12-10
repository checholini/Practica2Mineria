TOT_NUM_ATTRIB=$(cat $1 | grep "@at" -c)
NUM_ATTRIB=$((TOT_NUM_ATTRIB - 1))
 echo $NUM_ATTRIB
