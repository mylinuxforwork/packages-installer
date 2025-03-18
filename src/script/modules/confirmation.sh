if gum confirm "${pkginst_lang['confirm_installation']}"; then
    _echo "${pkginst_lang['installation_started']}"
else
    _echo "${pkginst_lang['installation_cancelled']}"
    exit
fi