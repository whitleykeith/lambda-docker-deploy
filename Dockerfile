# Copyright 2018 Sahaj Software Solutions, Inc.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM lambci/lambda-base
USER root

# Set up app directory
RUN mkdir app
WORKDIR app
ENV HOME=/app

# Installs dependencies and copies binaries to app folder
COPY ./wrapR.sh /app/wrapR.sh
RUN chmod +x /app/wrapR.sh
RUN cd /app && ./wrapR.sh

# Copy lambda functions
COPY ./handler.py /app/lambda/handler.py
COPY ./test_handler.py /app/lambda/test_handler.py



# Set workdir
WORKDIR /app/lambda
# Test everything and then zip it up
RUN python ./test_handler.py
RUN zip -r9 /app/lambda_r_survival.zip *