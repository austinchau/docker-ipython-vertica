FROM debian:jessie

MAINTAINER Austin Chau <austin.chau@gmail.com>

RUN apt-get update
RUN apt-get -y install curl g++ make bzip2

# install unixodbc
RUN curl ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-2.3.1.tar.gz | tar xz
WORKDIR unixODBC-2.3.1
RUN ./configure --disable-gui --disable-drivers --enable-iconv --with-iconv-char-enc=UTF8 --with-iconv-ucode-enc=UTF16LE && make && make install
RUN mkdir -p /var/log/unixodbc

# install vertica odbc driver
RUN mkdir -p /opt/vertica-odbc-driver
RUN cd /opt/vertica-odbc-driver && curl https://s3-us-west-1.amazonaws.com/analytics-vertica-driver/vertica-odbc-7.1.1-0.x86_64.linux.tar.gz | tar xz
RUN cp /opt/vertica-odbc-driver/include/* /usr/include

# set up ldconfig
RUN echo "/usr/local/lib" >> /etc/ld.so.conf.d/x86_64-linux-gnu.conf
RUN echo "/opt/vertica-odbc-driver/lib64" >> /etc/ld.so.conf.d/x86_64-linux-gnu.conf
RUN ldconfig

# set up ini
ADD odbc.ini /root/.odbc.ini
ENV ODBCINI=/root/.odbc.ini
ENV VERTICAINI=/root/.odbc.ini

# install anaconda + pyodbc + other libs deps
WORKDIR /tmp
RUN curl https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda-2.2.0-Linux-x86_64.sh > Anaconda-2.2.0-Linux-x86_64.sh
ENV DEBIAN_FRONTEND noninteractive
RUN bash Anaconda-2.2.0-Linux-x86_64.sh -b
ENV PATH /root/anaconda/bin:$PATH
RUN conda install pyodbc
RUN conda install seaborn
RUN apt-get -y install libglib2.0-0 libxext6 python-matplotlib libsm-dev

# install native python vertica driver
RUN pip install --pre pytz
RUN pip install vertica-python

# home directory for ipython notebook
RUN mkdir -p /ipython-data
WORKDIR /ipython-data
EXPOSE 8888
CMD ipython notebook --ip='*' --no-browser --script