FROM centos:7
MAINTAINER Ion Pantalon <nanu_rtc@yahoo.com>

# install http
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# install httpd
RUN yum -y install httpd vim-enhanced bash-completion unzip

# install mysql
RUN yum install -y mysql mysql-server
RUN echo "NETWORKING=yes" > /etc/sysconfig/network
# start mysqld to create initial tables
# RUN service mysqld start

# install php
RUN yum install -y php php-mysql php-devel php-gd php-pecl-memcache php-pspell php-snmp php-xmlrpc php-xml

# install supervisord
#RUN yum -y install python-pip
#RUN pip install supervisor

# install sshd
RUN yum install -y openssh-server openssh-clients passwd

ADD phpinfo.php /var/www/html/
ADD supervisord.conf /etc/
EXPOSE 22 80
CMD ["supervisord", "-n"]
