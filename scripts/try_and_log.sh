try_and_log() {
    local exit_on_error=${global_exit_on_error:-no}
    local log_path_loc=${log_path:-"./log.txt"}
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
        echo `date`": Error while excuting '$@'. Exit code was $status" >> $log_path_loc
        if [ "$exit_on_error" = "yes" ]; then
            exit 1
        fi
    fi
}
