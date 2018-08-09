#! /bin/bash
# Copyright 2018 Sahaj Software Solutions, Inc.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

aws cloudformation package \
--profile $AWS_PROFILE \
--template-file sam.yaml \
--output-template-file cf.yaml \
--s3-bucket $BUCKET --s3-prefix $PREFIX

aws cloudformation deploy \
--profile $AWS_PROFILE \
--region us-west-2 \
--template-file cf.yaml \
--stack-name r-on-lambda \
--capabilities CAPABILITY_IAM