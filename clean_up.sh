#!/bin/sh
SSHPIDS=`sudo lsof -u "$USER" -i TCP:22 -a | awk 'FNR 这里是一个向右的尖括号 1{ print $2}'`
for sshpid in $SSHPIDS
do 
 if [ $sshpid -eq $PPID ]; then
  continue
 fi
 kill $sshpid
done