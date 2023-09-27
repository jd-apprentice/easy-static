## Base image
FROM debian:stable-20230919-slim

RUN apt-get update && apt-get install -y curl unzip make wget && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-get install -y apt-transport-https && \
    echo "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && apt-get install -y terraform

RUN apt-get install -y python3-pip
RUN pip install ansible
RUN pip install --user boto3
RUN ansible-galaxy collection install amazon.aws
RUN pip3 install awscli --upgrade --user

WORKDIR /easy-static

RUN git clone https://github.com/jd-apprentice/easy-static.git
RUN cd easy-static

ARG action
ARG environment

ENV aws_access_key=${aws_access_key}
ENV aws_secret_key=${aws_secret_key}
ENV s3_bucket_name=${s3_bucket_name}
ENV s3_bucket_name_subdomain=${s3_bucket_name_subdomain}
ENV s3_tags=${s3_tags}
ENV route53_hostedzone_id=${route53_hostedzone_id}
ENV route53_record_name=${route53_record_name}
ENV route53_base_domain=${route53_base_domain}
ENV acm_certificate=${acm_certificate}

## Copy environment variables depending on environment
COPY .env /easy-static/terraform/config/${environment}.tfvars