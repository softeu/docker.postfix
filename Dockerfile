FROM softeu/ubuntu-base

MAINTAINER Jindrich Vimr <jvimr@softeu.com>


RUN apt-get -qqy install debconf-utils

RUN apt-get -qqy install supervisor



# Install Postfix.
run echo "postfix postfix/main_mailer_type string Internet site" > preseed.txt
run echo "postfix postfix/mailname string postfix.docker" >> preseed.txt
RUN echo "postfix postfix/mynetworks      string  127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 172.0.0.0/8 " >> preseed.txt

run debconf-set-selections preseed.txt

ENV HOSTNAME postfix.docker

RUN apt-get -qqy install postfix



RUN sed -i 's/^myhostname = [0-9a-z]*/myhostname = posfix.docker/g' /etc/postfix/main.cf

# Add files
ADD assets/install.sh /opt/install.sh

ADD assets/run_supervisord.sh opt/run_supervisord.sh

EXPOSE 25

# Run

CMD /opt/run_supervisord.sh
