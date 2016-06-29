#!/bin/bash

HAZELCAST_CONFIG="/opt/config/hazelcast.xml";
LOG="/var/log/cluster_manager.log"

function addHost(){
    [ ! -z "$host" ] && { grep -q "$host" $HAZELCAST_CONFIG || sed -i "/<member-list/a \\\t\t\t<member>${host}</member>" $HAZELCAST_CONFIG;
    echo "HOST $host ADEED"  >>  $LOG; }
}


function removeHost(){
    [ ! -z "$host" ] && sed -i "/${host}/d" $HAZELCAST_CONFIG && echo "HOST $host REMOVED"  >>  $LOG;

}

while [ "$1" != "" ];
   do
    case $1 in

    --addhost )                     shift;
                                    host="$1";
                                    addHost;
                                    ;;
    --removehost )                  shift;
                                    host="$1";
                                    removeHost;
                                    ;;
    esac
    shift
  done
