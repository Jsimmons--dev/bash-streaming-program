#counter for the aggregation loop
counter=0
#current batch of input
currentBatch=""
#batch size to send
maxbatch=10
#joining string
join=","
#length of join string
joinlen=${#join}
while IFS= read -r line || [[ -n "$line" ]]; do
        if [ $counter -lt $maxbatch ]
        then
                #add the new line and the join string to the batch
                currentBatch="$currentBatch$line$join"
                counter=$(($counter+1))
        else
                #batch size is ready send a batch with the last join char popped off
                echo "${currentBatch::-$(($joinlen))}"
                #start a new batch with the current line
                currentBatch="$line,"
                #counter is 1 since a new item is placed in the new batch
                counter=1
        fi
done
#if there is less than a full batch size left over
if [ ${#currentBatch} -gt 0 ]
then
        #send it with the join char popped off
        echo "${currentBatch::-$(($joinlen))}"
fi
