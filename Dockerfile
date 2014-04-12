FROM centos
MAINTAINER Sean Clerkin

ADD sensu.repo /etc/yum.repos.d/sensu.repo

RUN yum -y install http://www.mirrorservice.org/sites/dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
RUN rpm --import http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
RUN wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.3.0/rabbitmq-server-3.3.0-1.noarch.rpm
RUN yum install -y rabbitmq-server-3.3.0-1.noarch.rpm sensu redis git supervisor

RUN /opt/sensu/embedded/bin/gem install redphone --no-rdoc --no-ri
RUN /opt/sensu/embedded/bin/gem install mail --no-rdoc --no-ri

RUN rm -rf /etc/sensu/plugins
RUN git clone https://github.com/sensu/sensu-community-plugins.git /tmp/sensu_plugins

RUN cp -Rpf /tmp/sensu_plugins/plugins /etc/sensu/
RUN find /etc/sensu/plugins/ -name *.rb -exec chmod +x {} \;

ADD supervisor.conf /etc/supervisord.conf
ADD run.sh /tmp/sensu-run.sh

VOLUME /etc/sensu
VOLUME /var/log/sensu

EXPOSE 4567
EXPOSE 5672
EXPOSE 6379
EXPOSE 8080

CMD ["/tmp/sensu-run.sh"]
