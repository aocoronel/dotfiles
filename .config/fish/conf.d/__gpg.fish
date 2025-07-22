if test -z $TTY
    set TTY /dev/pts/0
end

set -x GPG_TTY $TTY

gpg-connect-agent updatestartuptty /bye &>/dev/null

if test $(gpgconf --list-options gpg-agent 2>/dev/null | awk -F: '$1=="enable-ssh-support" {print $10}') = 1
    unset SSH_AGENT_PID
    if test -z "$gnupg_SSH_AUTH_SOCK_by"
        set gnupg_SSH_AUTH_SOCK_by 0
    end
    if test "$gnupg_SSH_AUTH_SOCK_by" -ne $fish_pid
        set -x SSH_AUTH_SOCK "$(gpgconf --list-dirs agent-ssh-socket)"
    end
end
