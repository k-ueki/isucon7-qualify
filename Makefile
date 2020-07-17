MYSQL_LOG:=/tmp/slow-query.log

.PHONY: alog
alog:
	alp -f /var/log//nginx/access.log

.PHONY: slow
slow:
	sudo pt-query-digest $(MYSQL_LOG)

.PHONY: setup
setup:
	git config --global user.email "ku6.gatt@gmail.com"
	git config --global user.name "k-ueki"
	sudo apt install percona-toolkit unzip
	wget https://github.com/tkuchiki/alp/releases/download/v1.0.3/alp_linux_amd64.zip
	unzip alp_linux_amd64.zip
	sudo install ./alp /usr/local/bin
	rm alp_linux_amd64.zip alp
