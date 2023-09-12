## Application

deploy: 
	$(MAKE) start action=apply environment=$(environment)

destroy:
	$(MAKE) start action=destroy environment=$(environment)

list:
	$(MAKE) start action=show environment=$(environment)

.PHONY: install
install:
	@echo "Running installation script..."
	chmod +x scripts/run.sh
	scripts/run.sh

## Development

environment ?= dev

### S3

git_submodule:
	git submodule add $(submodule) app/$(app_name)

build_app:
	cd app/$(app_name)
	npm install
	npm run build

bucket_sync:
	aws s3 sync app/Boilerplate/build s3://dyallab

bucket_rm:
	aws s3 rm --recursive s3://dyallab

### Terraform

init:
	cd terraform && terraform init

modules:
	cd terraform && terraform get

upgrade:
	cd terraform && terraform init -upgrade
	
start:
	cd terraform && terraform $(action) -var-file="config/$(environment).tfvars" -compact-warnings

plan:
	cd terraform && terraform plan -var-file="config/$(environment).tfvars" -compact-warnings

refresh:
	cd terraform && terraform refresh -var-file="config/$(environment).tfvars" -compact-warnings

output:
	cd terraform && terraform output

### Ansible

playbook:
	ansible-playbook ansible/playbook/$(playbook) -i ansible/inventory