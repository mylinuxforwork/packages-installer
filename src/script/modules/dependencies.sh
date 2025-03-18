# Read Dependencies

_writeModuleHeadline "${pkginst_lang['installing_dependencies']}"

# Load Application Dependency List
pkg_deps=$(_readDependencies "$pkginst_script_folder/dependencies")

# Install Application  Dependencies
for dep in $pkg_deps; do
    if [ -f "$pkginst_script_folder/dependencies/$pkg_manager/$dep" ]; then
        source "$pkginst_script_folder/dependencies/$pkg_manager/$dep"
    else
        _installPackage "$dep"
    fi
done
