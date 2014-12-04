#!/bin/bash

#judgement
if [[ -a /etc/supervisor/conf.d/supervisord.conf ]]; then
  exit 0
fi

#supervisor
cat > /etc/supervisor/conf.d/supervisord.conf <<EOF
[supervisord]
nodaemon=true
loglevel=debug
[program:postfix]
command=/opt/postfix.sh
#command=/usr/lib/postfix/master
#user=postfix
[program:rsyslog]
command=/usr/sbin/rsyslogd -n -c3
[program:taillog]
command=/opt/taillog.sh
EOF

##############
# taillog
############
cat >> /opt/taillog.sh << EOF
#!/bin/bash
tail -F /var/log/mail.log /var/log/mail.err /var/log/syslog
EOF
############
#  postfix
############
cat >> /opt/postfix.sh <<EOF
#!/bin/bash
service postfix start
#/usr/lib/postfix/master
sleep 5

while ps ax|grep master > /dev/null
do
# echo 'post master still running'
 sleep 10

done
#/usr/lib/postfix/master
EOF
chmod +x /opt/postfix.sh
chmod +x /opt/taillog.sh
postconf -e myhostname=$maildomain
postconf -F '*/*/chroot = n'

