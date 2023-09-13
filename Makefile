include config.mk

## Application

deploy: 
	$(MAKE) start action=apply environment=$(environment)

destroy:
	$(MAKE) start action=destroy environment=$(environment)

list:
	$(MAKE) show

.PHONY: install
install:
	@echo "Running installation script..."
	chmod +x scripts/run.sh
	scripts/run.sh

### S3

community:
	ansible-galaxy collection install community.aws
	pip install --user ansible[community.aws]
	pip install --user boto3

git_submodule:
	git submodule add $(submodule) app/$(app_name)

build_app:
	cd app/$(app_name) && npm i && npm run build

# Requires boto3 installed with pip
# https://boto3.amazonaws.com/v1/documentation/api/latest/guide/quickstart.html#installation
ansible_list:
	ansible-playbook ansible/playbook/s3_list.yml -e "bucket_name=$(bucket_name)" -e "access_key=$(access_key)" -e "secret_key=$(secret_key)" -i ansible/inventory/hosts

ansible_sync:
	ansible-playbook ansible/playbook/s3_sync.yml -e "bucket_name=$(bucket_name)" -e "app_name=$(app_name)" -i ansible/inventory/hosts

ansible_rm: 
	ansible-playbook ansible/playbook/s3_rm.yml -e "bucket_name=$(bucket_name)"

### Terraform

init:
	cd terraform && terraform init

modules:
	cd terraform && terraform get

upgrade:
	cd terraform && terraform init -upgrade
	
start:
	cd terraform && terraform $(action) -var-file="config/$(environment).tfvars" -compact-warnings

show:
	cd terraform && terraform show -json -compact-warnings | jq

plan:
	cd terraform && terraform plan -var-file="config/$(environment).tfvars" -compact-warnings

refresh:
	cd terraform && terraform refresh -var-file="config/$(environment).tfvars" -compact-warnings

output:
	cd terraform && terraform output