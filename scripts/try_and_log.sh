try_and_log() {
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
        echo `date`": Error while excuting '$@'. Exit code was $status" >> $log_path
    fi
}
