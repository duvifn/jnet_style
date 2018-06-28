execute_async() {
    number_of_jobs=${number_of_jobs:-6}
    # wait until job number is less than number_of_jobs
    while (( (( $(jobs | grep -i -v "done" | wc -l) )) >= $number_of_jobs )) 
    do 
      sleep 1      # check again after 1 seconds
    done
    "$@" &
}
    