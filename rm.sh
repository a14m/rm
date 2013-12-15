#!/bin/bash

# VARIABLES
VERSION="0.3"
TO_DELETE=()
RECURSIVE=false
FOREVER=false
VERBOSE=false

# FUNCTIONS
function show_help()
{
    echo -e ""
    echo -e "This is custom script used to avoid deleting files forever"
    echo -e "instead files will be moved to $HOME/.Trash folder"
    echo -e "and this script only works if you invoked it directly from the terminal"
    echo -e "it doesn't work if for example git used rm or if you used rm in other scripts"
    echo -e ""
    echo -e "usage: rm [OPTION]...FILE..."
    echo -e "Move FILE(s) to $HOME/.Trash folder"
    echo -e ""
    echo -e "Options:"
    echo -e "  -h, --help \t\tdisplay this help text and exit."
    echo -e "  --version \t\toutput version information and exit."
    echo -e "  -r, -R, --recursive,\tmove the directories and their content to the Trash folder."
    echo -e "  -f, --forever,\tremove the directories and their content to the Trash folder."
    echo -e "                \tuse this to delete files or empty trash it calls the /bin/rm"
    echo -e ""
    echo -e ""
    echo -e "Script source 'https://github.com/artmees/rm'"
    echo -e "github page   'https://artmees.github.io/rm'"
    echo -e ""
    echo -e "Install :"
    echo -e "  sudo cp rm.sh /usr/local/bin/rm"
    echo -e "Uninstall :"
    echo -e "  sudo rm /usr/local/bin/rm"
    echo -e ""
    echo -e "you need to restart the termial for this to work"
    echo -e "or you can use source ~/.bashrc or source ~/.bash_profile"
    echo -e ""
    echo -e "Use Old rm :"
    echo -e "  /bin/rm"
    exit 0
}

function check_flags()
{
    # check the flags user used
    if [ $# -le 0 ];then
        show_help
    fi

    while test $# -gt 0; do
        case "$1" in
            -h|--help) 
                show_help
                ;;
            -r|-R|--recursive)
                shift
                RECURSIVE=true
                ;;
            -f|--forever)
                shift
                FOREVER=true
                ;;
            --version)
                echo -e "$VERSION"
                exit 0
                ;;
            -v|--verbose)
                shift
                VERBOSE=true
                ;;
            -a|-b|-c|-d|-e|-g|-h|-i|-j|-k|-l|-m|-n|-o|-p|-q|-s|-t|-u|-w|-x|-y|-z|-A|-B|-C|-D|-E|-F|-G|-H|-I|-J|-K|-L|-M|-N|-O|-P|-Q|-S|-T|-U|-V|-W|-X|-Y|-Z)
                echo -e ""
                echo -e "Invalid Argument"
                show_help
                ;;
            *)
                get_to_delete $1
                shift
                ;;
        esac
    done
}

# Helper method to populate the TO_DELETE array
function get_to_delete()
{
    while test $# -gt 0; do
        TO_DELETE=("${TO_DELETE[@]}" $1)
        shift
    done
}

function check_trash_directory()
{
    # check that global system trash exists
    # if not create it
    if [ ! -d ~/.Trash/ ];then
        mkdir ~/.Trash
    fi

    # check the files and flags passed
    check_flags $@

    if $FOREVER ;then
        # use the common system rm -r passing the same arguments
        if $VERBOSE ;then
            echo -e "`/bin/rm -r -v ${TO_DELETE[@]}`"
        else
            /bin/rm -r ${TO_DELETE[@]}
        fi
    else
        move_to_trash
    fi
    exit 0
}

# Move the deleted files to the trash
# show output if -V option was specified
function move_to_trash()
{
    for i in "${TO_DELETE[@]}";do
        FILENAME=$i
        FILENAME+="_"
        FILENAME+=$(date +"%H_%M_%S")
        if [ -d $i ] && $RECURSIVE ;then
            if $VERBOSE ;then
                echo -e "`mv -v $i ~/.Trash/$FILENAME`"
            else
                mv $i ~/.Trash/$FILENAME
            fi
        elif [ -d $i ] ;then
            echo -e "$i is a directory please use --recursive to remove directories and their content"
        elif [ -f $i ] ;then
            if $VERBOSE ;then
                echo -e "`mv -v $i ~/.Trash/$FILENAME`"
            else
                mv $i ~/.Trash/$FILENAME
            fi
        else
            # TODO add other option similar to rm -f to not output this error
            echo -e "No such file or directory '$i'"
        fi
    done
}

# Refer to http://stackoverflow.com/questions/20572934/get-the-name-of-the-caller-script-in-bash-script
# to understand the next funtion
# usage: determine if the script was invoked by a user or other script
# if it was invoked by other scripts then use the system rm instead 
# to avoid messing with other scripts behaviour.
function check_invoker()
{
    PARENT_COMMAND=$(ps $PPID | tail -n 1 | awk "{print \$5}")
    if [ $PARENT_COMMAND == '-bash' ]; then
        check_trash_directory $@
    else
        /bin/rm $@
        exit 0
    fi
}

# Main
check_invoker $@
exit 0
