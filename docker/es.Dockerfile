## Base image - TODO: Find a smaller base image
FROM ubuntu:devel

RUN apt-get update && apt-get install -y sudo curl make wget gnupg software-properties-common
RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list

RUN apt-get update && apt-get install -y terraform

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
ARG command

ENV aws_access_key=${aws_access_key}
ENV aws_secret_key=${aws_secret_key}
ENV s3_bucket_name=${s3_bucket_name}
ENV s3_bucket_name_subdomain=${s3_bucket_name_subdomain}
ENV s3_tags=${s3_tags}
ENV route53_hostedzone_id=${route53_hostedzone_id}
ENV route53_record_name=${route53_record_name}
ENV route53_base_domain=${route53_base_domain}
ENV acm_certificate=${acm_certificate}

ENTRYPOINT ["sh", "-c", "cd easy-static"]
CMD ["/bin/bash"]