report_errors() {
    local input_dir=$1
    local number_of_errors=`find $input_dir -iname '*.error.log' -exec echo {} \; | wc -l`
    if [ "$number_of_errors" -ne "0" ]; then
        echo `date`": $number_of_errors Errors were reported:"
        for error_file in `ls $input_dir/*.error.log`
        do
            cat $error_file
        done
        echo `date`": $number_of_errors Errors were reported. run: \"find $input_dir -iname '*.error.log' -exec cat {} \;\" to list them."
        return 1
    else
        return 0
    fi
}
