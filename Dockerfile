FROM python:3

ENV FREETDS_VERSION 1.00

#Install dependencies for PyODBC
RUN apt-get update && apt-get install -y unixodbc-dev \
 && apt install unixodbc-bin -y  \
 && apt-get clean -y

WORKDIR /usr/src

#Download sources for FreeTDS driver
RUN wget -P . ftp://ftp.freetds.org/pub/freetds/stable/freetds-$FREETDS_VERSION.tar.gz \
 && tar -xvzf freetds-$FREETDS_VERSION.tar.gz

WORKDIR /usr/src/freetds-$FREETDS_VERSION

#Build FreeTDS driver
#Watch out for --prefix, as our driver will be stored at /prefix/libtdsodbc.so
#See the docs: http://www.freetds.org/userguide/config.htm
RUN ./configure --prefix=/usr/local \
 && make \
 && make install

RUN echo "[FreeTDS]\n\
Description = FreeTDS unixODBC Driver\n\
Driver = /usr/local/lib/libtdsodbc.so\n\
Setup = /usr/lib/arm-linux-gnueabi/odbc/libtdsS.so" >> /etc/odbcinst.ini
