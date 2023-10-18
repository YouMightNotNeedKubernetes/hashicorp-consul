docker_stack_name := consul
service_replicas := 3

compose_files := -c docker-compose.yml
ifneq ("$(wildcard docker-compose.override.yml)","")
	compose_files += -c docker-compose.override.yml
endif

-include .env.default
-include .env

it:
	@echo "make [configs|deploy|destroy]"

.PHONY: configs
configs:
	test -f configs/config.hcl || cp configs/config.default.hcl configs/config.hcl

deploy: configs
	docker stack deploy $(compose_files) ${docker_stack_name}

destroy:
	docker stack rm ${docker_stack_name}

scale:
	docker service scale ${docker_stack_name}_server=${service_replicas}
