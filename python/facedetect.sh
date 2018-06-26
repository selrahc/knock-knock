#!/bin/bash

sudo modprobe bcm2835-v4l2
python facedetect.py --cascade=face.xml 1
