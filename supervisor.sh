#Supervisor 

yum -y install python-pip
pip install --upgrade pip
pip install supervisor

echo_supervisord_conf > /etc/supervisord.conf


sed -i '16c file=/var/run/supervisor.sock ; the path to the socket file' /etc/supervisord.conf
sed -i '28c logfile=/var/log/supervisord.log ; main log file; default $CWD/supervisord.log' /etc/supervisord.conf
sed -i '32c pidfile=/var/run/supervisord.pid ; supervisord pidfile; default supervisord.pid' /etc/supervisord.conf
sed -i '57c serverurl=unix:///var/run/supervisor.sock ; use a unix:// URL  for a unix socket' /etc/supervisord.conf
sed -i '147c [include]' /etc/supervisord.conf
sed -i '148c files = /etc/supervisor/*.conf' /etc/supervisord.conf
mkdir /etc/supervisor/

echo "[program:gf_queue]
process_name=%(program_name)s_%(process_num)02d
command=php /home/vhost/api_gf/artisan queue:listen --timeout=0
autostart=true
autorestart=true
user=nginx
numprocs=1
redirect_stderr=true
stdout_logfile=/var/log/gf_queue.log" | tee --append /etc/supervisor/gf_queue.conf


supervisord -c /etc/supervisord.conf
supervisorctl status