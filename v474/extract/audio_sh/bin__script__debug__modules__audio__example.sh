#!/bin/sh
#set -x
PID=$$

root_dir="$(dirname $(dirname $(dirname $0)))"
# Import function: write_interactive()
source "$root_dir/utils/loggers.sh"
# Import comman arugments
#   1.) log_fp      =>  kernel log file path
#   2.) act_log_fp  =>  interactive log file path
source "$root_dir/utils/arguments.sh"

#========================================================
#                 Pre-process functions
# Define:
#   ) $module_arg<n> = Arguments passed from main script
#========================================================
echo "=========== (PID=$PID) from $0 ============="

module_arg1=$1
module_arg2=$2
module_arg3=$3


echo "log_fp=$log_fp"
echo "act_log_fp=$act_log_fp"
echo "module_arg1=$module_arg1"
echo "module_arg2=$module_arg2"
echo "module_arg3=$module_arg3"


#========================================================
#                   Main codes here
#========================================================

# DO SOMETHING


# Demo interactive flow
echo "-------- Interactive demo --------"

function question1()
{
  read -p "Do you see pokemon on the screen? [Y/N]? " bug
  case $bug in 
  Y | y) 
        rst="See Pokemon";;
  N | n)
        rst="Keep trying";;
  *)
        rst=$bug;;
  esac

  write_interactive screen_pokemon "$rst"
  echo "$bug"
}

function question2()
{
  read -p "Do you have master ball now? [Y/N]? " bug
  case $bug in
  Y | y)
        rst="Go get it!";;
  N | n)
        rst="To bad..";;
  *)
        rst=$bug;;
  esac
  write_interactive screen_have_master_ball "$rst"
  echo "$bug"
}

rst1=$(question1)
if [ "$rst1" == "Y" ] || [ "$rst1" == "y" ]; then
  rst2=$(question2)
fi

echo
echo "================================"


