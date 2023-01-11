FROM amazon/aws-lambda-python:3.8

ARG USER_NAME="ope"
ENV PATH ${PATH}:/home/${USER_NAME}/.local/bin

# required packages
RUN yum install -y \
    tar \
    gzip \
    unzip \
    less \
    zip \
    && yum clean all

# aws-cli
RUN pip3 install --no-cache-dir --upgrade pip
RUN curl -OL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
    && unzip awscli-exe-linux-x86_64.zip \
    && ./aws/install

# serverless
RUN curl -sL https://rpm.nodesource.com/setup_16.x | bash -
RUN yum install -y nodejs \
    && yum clean all
RUN npm install -g serverless@2.61.0 --unsafe-perm
ENV AWS_SDK_LOAD_CONFIG 1

# create user
RUN yum install -y shadow-utils \
    && yum clean all
RUN /usr/sbin/useradd ${USER_NAME} && echo "${USER_NAME} ALL=NOPASSWD: ALL" >> /etc/sudoers
USER ${USER_NAME}

CMD [ "hello.handler" ]

