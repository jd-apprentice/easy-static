.PHONY: build
build:
	docker build . -t $(image_name) -f docker/es.Dockerfile

.PHONY: run
run:
	docker run \
	-e "action=${action}" \
	-e "environment=${environment}" \
	-e "command=${command}"
	-v ${PWD}/tf_persist:/terraform
	-i $(image_name)

.PHONY: init-dev
init-dev:
	docker run \
	-e "action=init" \
	-e "environment=dev" \
	-e "command=start_noargs" \
	-v ${PWD}/tf_persist:/terraform \
	-i $(image_name)