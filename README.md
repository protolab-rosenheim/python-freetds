# python-freetds

This docker image may come in handy if your're trying to connect to a Microsoft SQL Server from your Python application using [PyODBC](https://github.com/mkleehammer/pyodbc) and the [FreeTDS driver](http://www.freetds.org/).

## What this image does
Basically this image does three things:
1. Install the dependencies needed to build PyODBC as described in the [docs](https://github.com/mkleehammer/pyodbc/wiki/Install#installing-on-linux)
2. Download and build the FreeTDS driver as described [here](http://www.freetds.org/userguide/config.htm)
3. Edit `/etc/odbcinst.ini` to point at our newly built driver

## Using and extending this image
The straight forward use case of this image is to install PyODBC, add your application and run it:

````dockerfile
FROM protolab/python-freetds

WORKDIR /usr/src/app

# I'm assuming your requirements.txt contains pyodbc
COPY ./requirements.txt /usr/src/app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python", "app.py"]
````

In your Python code you can connect to any SQL Server using the FreeTDS driver:

````python
connection = pyodbc.connect(driver='{FreeTDS}',
                            server='servername',
                            uid='username',
                            pwd='password')
````

## Environment variables

### ``FREETDS_VERSION``
 The version of the FreeTDS driver to download and build. The image will try to download the corresponding tarball from ftp://ftp.freetds.org/pub/freetds/stable/. Make sure the version you specify exists. Default: 1.00

