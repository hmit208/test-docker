# Copyright 2016 Google Inc.
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
# limitations under the License

# The Google App Engine python runtime is Debian Jessie with Python installed
# and various os-level packages to allow installation of popular Python
# libraries. The source is on github at:
#   https://github.com/GoogleCloudPlatform/python-docker
FROM ubuntu:18.04

RUN apt-get -y update && apt-get install -y ffmpeg python python-pip && rm -rf /var/lib/apt/list/*
RUN pip install virtualenv
# Create a virtualenv for dependencies. This isolates these packages from
 # system-level packages.
RUN virtualenv /env

 # Setting these environment variables are the same as running
 # source /env/bin/activate.
ENV VIRTUAL_ENV /env
ENV PATH /env/bin:$PATH

 # Copy the application's requirements.txt and run pip to install all
 # dependencies into the virtualenv.
ADD requirements.txt /app/requirements.txt
RUN cd /app/requiremenrs.txt && pip install -r ./requirements.txt

# # Add the application source code.
ADD . /app

#CMD gunicorn -b :8080 main:app
CMD ["python", "./main.py"]