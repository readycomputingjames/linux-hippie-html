#!/bin/bash

HOST_FILE=$1
INPUT_COMMAND=$2

TIMESTAMP=`date`
HOSTNAME=`hostname`
USER=`whoami`

FROM="$USER@$HOSTNAME"
TO="james.hipp@va.gov"

SUBJECT="Hippie-Mon Script Results Executed from $HOSTNAME for $HOST_FILE"

hippie_mon_dssh ()
{

   # Generate HTML Message
   echo "From: $FROM"
   echo "To: $TO"
   echo "MIME-Version: 1.0"
   echo "Content-Type: multipart/alternative; "
   echo ' boundary="some.unique.value.ABC123/server.xyz.com"'
   echo "Subject: $SUBJECT"
   echo ""
   echo "This is a MIME-encapsulated message"
   echo ""
   echo "--some.unique.value.ABC123/server.xyz.com"
   echo "Content-Type: text/html"
   echo ""
   echo "<html>"
   echo "<head>"
   echo "   <title>HTML E-mail</title>"
   echo "</head>"
   echo "<body>"

   echo "<br>"
   echo "<div>Timestamp = $TIMESTAMP</div>"
   echo "<br>"

   for HOST in `cat $HOST_FILE`
   do
      echo $HOST
      /bin/ssh -o ConnectTimeout=5 $HOST $INPUT_COMMAND
      echo "<div>####################################</div>"
      echo "<br>"
   done

   echo "</body>"
   echo "</html>"

}

hippie_mon_dssh

