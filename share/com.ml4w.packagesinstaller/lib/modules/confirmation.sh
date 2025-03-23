if [ "$assumeyes" == "1" ]; then
    if gum confirm "${pkginst_lang['confirm_installation']}"; then
        echo
    else
        _echo "${pkginst_lang['installation_cancelled']}"
        exit
    fi
fi