FROM python:3.7

EXPOSE 222/tcp

# install packages
RUN apt-get update -y
RUN apt-get install openssh-server tmux curl locales vim emacs -y

# fix locale so that our terminal works with tmux
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# ssh setup
ADD sshd_config /etc/ssh/sshd_config
RUN ssh-keygen -A
RUN mkdir /var/run/sshd
RUN chmod 0755 /var/run/sshd

ADD entrypoint.sh /bin/entrypoint

ENTRYPOINT ["/bin/entrypoint"]

