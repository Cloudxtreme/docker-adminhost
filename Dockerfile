# docker container running ssh and provides some admin tools

FROM fonk/sssd
MAINTAINER Frank Grötzner <frank@unforgotten.de>

# install useful packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --force-yes \
    ssh \
    irssi \
    irssi-plugin-otr \
    irssi-plugin-xmpp \
    irssi-scripts \
    mutt \
    screen \
    tmux \
    tmux \
    vim \
    telnet \
    zip \
    unzip \
    bzip2 \
    ftp \
    lftp \
    tcpdump \
    ldap-utils \
    lsof \
    strace \
    curl \
    cifs-utils \
    man \
    ldapvi \
    sssd-ldap \
    less \
    wget

    
# install kubernetes client
RUN wget https://storage.googleapis.com/kubernetes-release/release/v1.0.1/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl

# needed to run sshd
RUN mkdir /var/run/sshd

# fix for
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=568577
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=640918
# see: http://blog.dailystuff.nl/2012/07/create-home-directory-on-first-login/
ADD usr/share/pam-configs /usr/share/pam-configs

# doesn't work - don't know why
RUN /usr/sbin/pam-auth-update --package

# ssh supervisor conf
ADD etc/supervisor/conf.d /etc/supervisor/conf.d

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22

VOLUME [ "/home" ]
VOLUME [ "/etc/ssh" ]