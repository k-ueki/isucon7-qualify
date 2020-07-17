MYSQL_LOG := /tmp/slow-query.log
NGINX_LOG := /var/log/nginx/access.log

SLACKCAT:=slackcat --tee --channel isu

.PHONY: bench
bench:
	/home/isucon/isubata/bench/bin/bench -data=/home/isucon/isubata/bench/data -remotes=localhost -output=result.json

.PHONY: alog
alog:
	alp -f /var/log//nginx/access.log

.PHONY: kata
kata:
	sudo cat $(NGINX_LOG) | kataribe | $(SLACKCAT)

.PHONY: slow
slow:
	sudo pt-query-digest $(MYSQL_LOG) | $(SLACKCAT)

.PHONY: slow-on
slow-on:
	sudo mysql -e "set global slow_query_log_file = '$(MYSQL_LOG)'; set global long_query_time = 0; set global slow_query_log = ON;"

.PHONY: slow-off
slow-off:
	sudo mysql -e "set global slow_query_log = OFF;"

.PHONY: setup
setup:
	git config --global user.email "ku6.gatt@gmail.com"
	git config --global user.name "k-ueki"
	wget https://github.com/matsuu/kataribe/releases/download/v0.4.1/kataribe-v0.4.1_linux_amd64.zip -O kataribe.zip
	unzip -o kataribe.zip
	sudo mv kataribe /usr/local/bin/
	sudo chmod +x /usr/local/bin/kataribe
	rm kataribe.zip
	kataribe -generate
	wget https://www.percona.com/downloads/percona-toolkit/3.0.3/binary/debian/jessie/x86_64/percona-toolkit_3.0.3-1.jessie_amd64.deb
	sudo apt install ./percona-toolkit_3.0.3-1.jessie_amd64.deb
	rm percona-toolkit_3.0.3-1.jessie_amd64.deb
#	wget https://github.com/tkuchiki/alp/releases/download/v1.0.3/alp_linux_amd64.zip
#	unzip alp_linux_amd64.zip
#	sudo install ./alp /usr/local/bin
#	rm alp_linux_amd64.zip alp
	wget https://github.com/bcicen/slackcat/releases/download/v1.5/slackcat-1.5-linux-amd64 -O slackcat
	sudo mv slackcat /usr/local/bin/
	sudo chmod +x /usr/local/bin/slackcat
	slackcat --configure


# /etx/nginx/nginx.conf
# log_format with_time '$remote_addr - $remote_user [$time_local] '
#			     '"$request" $status $body_bytes_sent '
#			     '"$http_referer" "$http_user_agent" $request_time';
#	access_log /var/log/nginx/access.log with_time;
