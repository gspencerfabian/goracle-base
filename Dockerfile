FROM centos:7

ADD distrib /distrib

RUN yum install -y \
  libaio.x86_64 \
  glibc.x86_64 \ 
  curl \
  git \
  gcc && \
  yum localinstall -y --nogpgcheck /distrib/oracle* && \
  yum autoremove -y && \
  yum clean all && \
  rm -rf /var/cache/yum \
    /distrib

RUN curl -o golang.tar.gz  https://dl.google.com/go/go1.9.3.linux-amd64.tar.gz && \
  tar -C /usr/local -xzf golang.tar.gz && \
  rm -rf golang.tar.gz

ENV GOPATH=/go
ENV ORACLE_HOME=/usr/lib/oracle/12.2/client64
ENV PATH=$PATH:/usr/local/go/bin:$ORACLE_HOME/bin
ENV LD_LIBRARY_PATH=$ORACLE_HOME/lib
ENV TNS_ADMIN=$ORACLE_HOME/network/admin
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

RUN mkdir -p $GOPATH/{src,pkg,bin} \
  $TNS_ADMIN \
  $PKG_CONFIG_PATH

ADD oci8.pc $PKG_CONFIG_PATH/

RUN go get github.com/mattn/go-oci8

ONBUILD ADD app/tnsnames.ora $TNS_ADMIN/
