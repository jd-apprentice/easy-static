include config.mk

## Application

.PHONY: deploy
deploy: 
	$(MAKE) start action=apply environment=$(environment)

.PHONY: destroy
destroy:
	$(MAKE) start action=destroy environment=$(environment)

.PHONY: list
list:
	$(MAKE) start action=show environment=$(environment)
	cat files/$(environment).json | jq

.PHONY: install
install:
	@echo "Running installation script..."
	chmod +x scripts/run.sh
	scripts/run.sh

### S3

.PHONY: community
community:
	@if ! ansible-galaxy collection list | grep -i 'community.aws'; then \
		ansible-galaxy collection install community.aws; \
	fi
	@if ! pip show boto3; then \
		pip install --user boto3; \
	fi
	@echo "Ansible Galaxy community.aws and boto3 already installed"

.PHONY: git_submodule
git_submodule:
	git submodule add $(submodule) app/$(app_name)

.PHONY: build_app
build_app:
	cd app/$(app_name) && npm i && npm run build

# Requires boto3 installed with pip
# https://boto3.amazonaws.com/v1/documentation/api/latest/guide/quickstart.html#installation

.PHONY: echo
echo:
	@echo "🪣 Bucket name: $(bucket_name)"
	@echo "🍎 App name: $(app_name)"
	@echo "📩 Environment: $(environment)"

.PHONY: ansible_list
ansible_list:
	$(MAKE) echo
	ansible-playbook ansible/playbook/s3_list.yml -e "bucket_name=$(bucket_name)" -e "access_key=$(access_key)" -e "secret_key=$(secret_key)" -i ansible/inventory/hosts

.PHONY: ansible_sync
ansible_sync:
	$(MAKE) echo
	ansible-playbook ansible/playbook/s3_sync.yml -e "bucket_name=$(bucket_name)" -e "app_name=$(app_name)" -i ansible/inventory/hosts

.PHONY: ansible_rm
ansible_rm:
	$(MAKE) echo
	ansible-playbook ansible/playbook/s3_rm.yml -e "bucket_name=$(bucket_name)"

### Terraform

.PHONY: upgrade
upgrade:
	cd terraform && terraform init -upgrade

#### init - get - output ####
.PHONY: start_noargs
start_noargs:
	@echo "Running terraform $(action)... with no args"
	cd terraform && terraform $(action)

#### apply - destroy - plan - show - refresh ####
.PHONY: start	
start:
ifeq ($(action), show)
	cd terraform && terraform show -json -compact-warnings > ../files/$(environment).json
else
	@echo "Running terraform $(action)..."
	cd terraform && terraform $(action) -var-file="config/$(environment).tfvars" -compact-warnings
endif