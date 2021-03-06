# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM jupyter/base-notebook

USER root

COPY jupyter_notebook_config.py /etc/jupyter/

RUN fix-permissions /etc/jupyter/

RUN apt-get update && apt-get install -y curl apt-transport-https ca-certificates gnupg \
  && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
  && echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
  && apt-get update && apt-get install -y google-cloud-sdk \
  && apt-get install -y graphviz libgraphviz-dev unzip git tree
  
RUN pip install torch==1.7.1+cpu torchvision==0.8.2+cpu torchaudio==0.7.2 -f https://download.pytorch.org/whl/torch_stable.html \
  && pip install graphviz \
  && pip install fastai

RUN mkdir /notebooks

COPY version_tests.ipynb /notebooks/

RUN git clone https://github.com/fastai/fastbook.git /notebooks/fastbook \
  && fix-permissions /notebooks/

USER $NB_UID

EXPOSE 8080
