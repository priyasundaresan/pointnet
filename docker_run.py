#!/usr/bin/env python
import os

if __name__=="__main__":
    #cmd = "nvidia-docker run -it -p 8888:8888 -p 6006:6006 -v %s:/host priya-mrcnn" % (os.getcwd())
    cmd = "nvidia-docker run -it -p 6006:6006 -v %s:/host priya-pointnet" % (os.getcwd())
    code = os.system(cmd)
