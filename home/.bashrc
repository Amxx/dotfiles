#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


PS1='[\u@\h \W]\$ '



if [ `whoami` = root ]; then
	PS1='\[\033[01;32m\][\[\033[31m\]\u@\h\[\033[32m\]:\[\033[33m\]\w\[\033[32m\]]$\[\033[00;00m\] '
else
	PS1='\[\033[01;34m\][\[\033[32m\]\u@\h\[\033[34m\]:\[\033[33m\]\w\[\033[34m\]]$\[\033[00;00m\] '
fi
#export PS1='\[$(__vte_ps1)\]'$PS1



export EDITOR=vim



alias ls='ls --color=auto'
#alias yaourt='yaourt --noconfirm'
alias gnomereset='pkill -HUP gnome-shell'
alias gpucheck='cat /proc/acpi/bbswitch'


# --- [LibGridRCPDM] For Diet ---
#export OMNINAMES_LOGDIR=/dev/shm/GRPCDM_TESTS
#export OMNIORB_CONFIG=/home/amxx/Work/M1_Stage/code/diet-2.8.1/install/etc/omniORB4.cfg
#export LD_LIBRARY_PATH=/home/amxx/Work/M1_Stage/code/diet-2.8.1/install/lib:$LD_LIBRARY_PATH
# --- [LibGridRPCDM] For GridRPC DM library
#export LD_LIBRARY_PATH=/home/amxx/Work/M1_Stage/code/gridrpcdm/install/lib:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=/home/amxx/Work/M2/commun/Aquisition/code/LibImAMXX/install/lib:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=/home/amxx/Work/M2/recherche/RenduAvance/code/AcquisitionHDR/install/lib:$LD_LIBRARY_PATH

export LD_LIBRARY_PATH=/home/amxx/Work/M2_Stage/sync/code/install/lib:$LD_LIBRARY_PATH

export PATH=/home/amxx/Work/These/Runtimes/Natron:$PATH
