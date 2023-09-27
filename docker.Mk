.PHONY: build
build:
	docker build -t $(image_name) . -f docker/es.Dockerfile --env-file $(env_file)

.PHONY: run
run:
	docker run \
	-e "action=${action}" \
	-e "environment=${environment}" \