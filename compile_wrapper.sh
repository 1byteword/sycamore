#!/bin/bash

g++ -std=c++11 -fPIC -shared hnswlib_wrapper.cpp -I./hnswlib -o libhnswlib_wrapper.so
