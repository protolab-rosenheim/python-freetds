FROM python:3

ENV FREETDS_VERSION 1.00

#Install dependencies for PyODBC
RUN apt-get update \
    && apt-get install unixodbc-dev -y --no-install-recommends \
    && apt install unixodbc-bin -y --no-install-recommends \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src

#Download sources for FreeTDS driver
RUN wget -q -P . ftp://ftp.freetds.org/pub/freetds/stable/freetds-$FREETDS_VERSION.tar.gz \
    && tar -xzf freetds-$FREETDS_VERSION.tar.gz \
    && rm freetds-$FREETDS_VERSION.tar.gz \
    && apt-get remove wget -y

WORKDIR /usr/src/freetds-$FREETDS_VERSION

#Build FreeTDS driver
#Watch out for --prefix, as our driver will be stored at /prefix/libtdsodbc.so
#See the docs: http://www.freetds.org/userguide/config.htm
RUN ./configure --prefix=/usr/local \
    && make \
    && make install

RUN path=$(dpkg --search libtdsS.so) \
    && echo "[FreeTDS]\n\
    Description = FreeTDS unixODBC Driver\n\
    Driver = /usr/local/lib/libtdsodbc.so\n\
    Setup = ${path#* }" >> /etc/odbcinst.ini
