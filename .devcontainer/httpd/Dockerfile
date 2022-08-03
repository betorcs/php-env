FROM httpd:2.4

COPY httpd-vhost.conf /usr/local/apache2/conf/extra/
COPY httpd-ssl.conf /usr/local/apache2/conf/extra/

ADD apache-selfsigned.key /usr/local/apache2/conf/server.key
ADD apache-selfsigned.crt /usr/local/apache2/conf/server.crt

RUN echo "Include conf/extra/httpd-vhost.conf" >> /usr/local/apache2/conf/httpd.conf

RUN sed -i \
		-e 's/^#\(LoadModule .*mod_proxy.so\)/\1/' \
		# -e 's/^#\(LoadModule .*mod_proxy_http.so\)/\1/' \
		-e 's/^#\(LoadModule .*mod_proxy_fcgi.so\)/\1/' \
		-e 's/^#\(LoadModule .*mod_rewrite.so\)/\1/' \
		-e 's/^#\(Include .*httpd-ssl.conf\)/\1/' \
		-e 's/^#\(LoadModule .*mod_ssl.so\)/\1/' \
		-e 's/^#\(LoadModule .*mod_socache_shmcb.so\)/\1/' \
		/usr/local/apache2/conf/httpd.conf
