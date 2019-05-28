# Splits a list of commands joined by the colon, found in PATH environment variables
__enhancd::filepath::split_list()
{
    local item str

    if [[ -z ${1} ]]; then
        return 1
    fi

    # str should be list like "a:b:c" concatenated by a colon
    str="${1}:"

    while [[ -n ${str} ]]; do
        # the first remaining entry
        item=${str%%:*}
        # reset str
        str=${str#*:}

        if __enhancd::command::which "${item%% *}"; then
            echo "${item}"
            return 0
        else
            continue
        fi
    done

    return 1
}

# Splits a path with a slash
__enhancd::filepath::split()
{
    __enhancd::command::awk \
        -f "$ENHANCD_ROOT/src/share/split.awk" \
        -v arg="${1:-$PWD}"
}

# Lists a path step-wisely
__enhancd::filepath::list_step()
{
    __enhancd::command::awk \
        -f "$ENHANCD_ROOT/src/share/step_by_step.awk" \
        -v dir="${1:-$PWD}"
}

__enhancd::filepath::walk()
{
    find "${1:-$PWD}" -maxdepth 1 -type d \
        | __enhancd::command::grep -v "\/\."
}

__enhancd::filepath::current_dir()
{
    echo "${PWD:-$(command pwd)}"
}
