#!/bin/sh
# Copyright 2016 Station X, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# keep track of current directory since it has handler and we will need to package it
INITIAL_DIR=`pwd`

# First, make sure everything is up-to-date:
yum -y update
yum -y upgrade

# install everything
# readline is needed for rpy2, and fortran is needed for R
yum install -y python27-devel python27-pip gcc gcc-c++ readline-devel libgfortran.x86_64 R.x86_64
yum install -y wget
echo "installing zip and unzip"
yum install -y zip unzip

# setup virtualenv and install rpy2
pip install virtualenv
virtualenv ~/env && source ~/env/bin/activate
pip install rpy2==2.8.6

# create a directory called lambda for our package
mkdir $HOME/lambda && cd $HOME/lambda
# copy R
rm /usr/lib64/R/lib/libRrefblas.so
cp -r /usr/lib64/R/* $HOME/lambda/
cp /usr/lib64/R/lib/libR.so lambda/lib/libR.so

# all the binaries we need
cp /usr/lib64/libgomp.so.1 $HOME/lambda/lib/
cp /usr/lib64/libgfortran.so.3 $HOME/lambda/lib/
cp /usr/lib64/libquadmath.so.0 $HOME/lambda/lib/
cp /usr/lib64/libblas.so.3 $HOME/lambda/lib/
cp /usr/lib64/liblapack.so.3 $HOME/lambda/lib/
cp /usr/lib64/libtre.so.5 $HOME/lambda/lib/

# we also need to grab this one (as we learned from trial and error)
cp /usr/lib64/liblapack.so.3 $HOME/lambda/lib/

# copy R executable to root of package
cp $HOME/lambda/bin/exec/R $HOME/lambda/

#Add the libraries from the activated Python virtual environment
cp -r $VIRTUAL_ENV/lib64/python2.7/site-packages/* $HOME/lambda
# we could copy all of $VIRTUAL_ENV/lib/python2.7/site-packages/, but let's grab the esseentials only
cp -r $VIRTUAL_ENV/lib/python2.7/site-packages/singledispatch* $HOME/lambda