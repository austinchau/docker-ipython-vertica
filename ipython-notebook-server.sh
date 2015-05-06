#!/bin/bash
# create ipython-data dir for docker volume mapping
IPYTHON_DATA_HOME=$HOME/ipython-data
mkdir -p $IPYTHON_DATA_HOME
docker run -it -v $IPYTHON_DATA_HOME:/ipython-data -p 8888:8888 austinchau/ipython-vertica