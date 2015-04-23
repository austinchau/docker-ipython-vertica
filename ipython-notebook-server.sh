#!/bin/bash
docker run -it -v $HOME/ipython-data:/ipython-data -p 8888:8888 austinchau/ipython-vertica
