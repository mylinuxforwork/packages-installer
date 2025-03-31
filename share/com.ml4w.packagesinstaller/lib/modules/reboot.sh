_writeModuleHeadline "${pkginst_lang['installation_completed']}"
if [ "$assumeyes" == "1" ]; then
    if gum confirm "${pkginst_lang['reboot_question']}"; then
        reboot
    fi
fi
