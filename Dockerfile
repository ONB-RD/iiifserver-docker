FROM centos:7

ENV KAKADU_VERSION v7_9_1-XXXXXX

ADD nginx.repo /etc/yum.repos.d/
RUN yum -y install epel-release && \
	yum -y update && \
	yum -y install \
	memcached git gcc-c++ autoconf automake libtool libtiff-devel.x86_64 libjpeg-turbo-devel.x86_64 libpng-devel wget nginx unzip java-1.8.0-openjdk-devel.x86_64 spawn-fcgi
RUN mkdir -p /opt && \
	wget -nv --output-document=/opt/libmemcached-1.0.18.tar.gz https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz && \
	tar -C /opt --extract --file /opt/libmemcached-1.0.18.tar.gz && \
	/opt/libmemcached-1.0.18/configure --disable-sasl -libdir=/usr/lib64/ && \
	make /opt/libmemcached-1.0.18/ && \
	make install /opt/libmemcached-1.0.18/
ADD $KAKADU_VERSION.zip /opt/
RUN unzip /opt/$KAKADU_VERSION.zip -d /opt/ && \
	export JAVA_HOME=/usr/lib/jvm/java-openjdk/ && \
	cd /opt/$KAKADU_VERSION/make;make -f Makefile-Linux-x86-64-gcc && \
	cp /opt/$KAKADU_VERSION/lib/Linux-x86-64-gcc/libkdu_v79R.so /usr/lib64/ && \
	ln -s /usr/lib64/libkdu_v77R.so /usr/lib64/libkdu.so
RUN cd /opt/;git clone https://github.com/klokantech/iiifserver.git && \
	cd /opt/iiifserver;./autogen.sh && \
	./configure --with-kakadu=/opt/$KAKADU_VERSION/ && \
	make && \
	mkdir /usr/bin/fcgi && \
	cp /opt/iiifserver/src/iipsrv.fcgi /usr/bin/fcgi/iipsrv.fcgi
ADD imageserver.conf /etc/nginx/conf.d/
RUN useradd imageserver
ADD iipimage_conf /etc/sysconfig/iipimage
RUN touch /var/log/iipsrv.log && \
	chown imageserver:imageserver /var/log/iipsrv.log
RUN mkdir /mnt/images/
ADD 00000001.jp2 /mnt/images/
ADD start.sh /opt/start.sh
RUN rm /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["/bin/bash", "/opt/start.sh"]
