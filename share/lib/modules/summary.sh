if [ ! -z $pkginst_commanderrors ]; then
    echo $echo_line
    echo ${pkginst_lang['errors_detected']}
    echo $echo_line
    echo ${pkginst_lang['commands_validated']}
    for t in ${pkginst_commanderrors[@]}; do
        echo "$t"
    done
    echo ${pkginst_lang['commands_recommendation']}
fi
echo