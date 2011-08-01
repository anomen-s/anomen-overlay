#!/bin/sh -x

if [ -n "$SSH_AUTH_SOCK" -a -S "$SSH_AUTH_SOCK" ]; then

 /usr/bin/ssh-add -l > /dev/null  2>&1
 RESULT=$?

 if [ "$RESULT" -le 1 ]; then
    echo exec
    exec /usr/bin/env -- "$@"
 else
    echo agent kill
    test -n "$SSH_AGENT_PID" && /usr/bin/ssh-agent -k > /dev/null 2>&1
    rm -f "$SSH_AUTH_SOCK"
 fi
fi

SHARED_SOCKET=$HOME/.ssh/agent-$HOSTNAME

export SSH_AUTH_SOCK="$SHARED_SOCKET"


if [ -S "$SSH_AUTH_SOCK" ]; then

 /usr/bin/ssh-add -l > /dev/null  2>&1
 RESULT=$?

 if [ "$RESULT" -le 1 ]; then
    echo exec shared
    exec /usr/bin/env -- "$@"
 else
    echo agent kill
    test -n "$SSH_AGENT_PID" && /usr/bin/ssh-agent -k > /dev/null 2>&1
    rm -f "$SSH_AUTH_SOCK"
 fi
fi

echo agent start

exec /usr/bin/ssh-agent -a "$SHARED_SOCKET" -- "$@"
