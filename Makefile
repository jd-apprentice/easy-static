## Application

deploy: 
	$(MAKE) start action=apply

destroy:
	$(MAKE) start action=destroy

list:
	$(MAKE) start action=show

.PHONY: install
install:
	@echo "Running installation script..."
	chmod +x scripts/run.sh
	scripts/run.sh

## Development

cp:
	aws s3 cp files s3://$(terraform output -raw s3_bucket_name)/ --recursive --profile terraform-user

rm:
	aws s3 rm s3://$(terraform output -raw s3_bucket_name)/ --recursive --profile terraform-user

environment ?= dev

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

playbook:
	ansible-playbook ansible/playbook/$(playbook) -i ansible/inventory