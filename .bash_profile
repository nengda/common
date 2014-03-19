
# User specific environment and startup programs

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

PATH=$PATH:$HOME/bin
PATH=$PATH:/home/y/bin/
PATH=$PATH:/home/y/sbin/
PATH=$PATH:/home/y/libexec/maven/bin/
PATH=$PATH:/home/y/libexec/git-core/

export PATH

export SVN_SSH=/usr/bin/ssh
export SAST_DTS_HOME=/home/nengda/sast_current
export SAST_RESELLER_HOME=/home/nengda/sast_reseller/trunk
export SVN_EDITOR=/home/y/bin/vim
export LC_ALL='C'
export LANG='zh_CN.utf8'
export FLEX_HOME=$HOME/flex

export ANT_HOME="/home/y/libexec/ant"
export PATH="$PATH:~/bin:$ANT_HOME/bin"

if [ -d /home/y/conf/dts_zshrc ]; then
    for FILE in `ls /home/y/conf/dts_zshrc/*`; do
            source $FILE;
    done
fi

alias ..='cd ..'
alias ...='cd ../..'

SSH_ENV="$HOME/.ssh/environment"

function start_agent {
        echo "Initialising new SSH agent..."
        /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
        echo succeeded
        chmod 600 "${SSH_ENV}"
        . "${SSH_ENV}" > /dev/null
        /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
        . "${SSH_ENV}" > /dev/null
        #ps ${SSH_AGENT_PID} doesn't work under cywgin
        ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
        }
else
        start_agent;
fi
