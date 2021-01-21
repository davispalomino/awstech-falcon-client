# service - variables
PROJECT 		= falcon
ENV     		= dev
SERVICE 		= client
AWS_REGION		= us-east-1
AWS_ACCOUNT_ID = 508571872065
# docker - variable
REPO_PATH       = $(REPO_HOST)/$(PROJECT)-$(ENV)/$(SERVICE)
BUILD_UID       = $(shell id -u)
BUILD_GID       = $(shell id -g)
BUILD_USERNAME  = $(shell whoami)

image:
	# creando imagen base
	@docker build -f docker/base/Dockerfile -t $(PROJECT)-$(ENV)-$(SERVICE):base .

release:
	@docker build -f docker/latest/Dockerfile --build-arg IMAGE=$(PROJECT)-$(ENV)-$(SERVICE):base -t $(PROJECT)-$(ENV)-$(SERVICE):app .

newmantest:
	# Create image Docker build Newman
	docker build --network host -f docker/newman/Dockerfile -t $(PROJECT)-$(ENV)-$(SERVICE):newman .
	# Docker-compose UP
	
	IMAGE_APP=$(PROJECT)-$(ENV)-$(SERVICE):app IMAGE_NEWMAN=$(PROJECT)-$(ENV)-$(SERVICE):newman MICROSERVICE=$(PROJECT)-$(ENV)-$(SERVICE) docker-compose -p $(PROJECT)-$(ENV)-$(SERVICE) up -d
	@export IPADDRESS=$$(docker inspect $$(docker-compose -p $(PROJECT)-$(ENV)-$(SERVICE) ps -q latest) | jq '.[].NetworkSettings.Networks."'$(PROJECT)-$(ENV)-$(SERVICE)'_default".IPAddress' | cut -d '"' -f 2) && \
	timeout 30s bash -c 'while true; do if [[ "$$(curl -s -o /dev/null -w ''%{http_code}'' -X GET $$IPADDRESS:80/health" = "200" ]]; then sleep 1; echo "IMAGE-READY" > ./status-imagen.txt; docker run --rm -v $(PWD)/test/tmp:/opt/test --network="$(PROJECT)-$(ENV)-$(SERVICE)_default" $(REPO_HOST)/ci-tools/postman:latest; break; else echo "IMAGE-NO-READY" > ./status-imagen.txt; sleep 10; fi;  done '; exit 0 
	IMAGE_APP=$(PROJECT)-$(ENV)-$(SERVICE):app IMAGE_NEWMAN=$(PROJECT)-$(ENV)-$(SERVICE):newman MICROSERVICE=$(PROJECT)-$(ENV)-$(SERVICE) docker-compose -p $(PROJECT)-$(ENV)-$(SERVICE) down

pushecr:
	aws ecr describe-repositories --repository-names $(PROJECT)-$(ENV)-$(SERVICE) --query "repositories[0].repositoryUri" --region $(AWS_REGION) --output text 2>/dev/null || aws ecr create-repository --repository-name $(PROJECT)-$(ENV)-$(SERVICE)  --query "repository.repositoryUri" --region $(AWS_REGION) --output text && \
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com && \
	docker tag $(PROJECT)-$(ENV)-$(SERVICE):app $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(PROJECT)-$(ENV)-$(SERVICE):$(BUILD_TIMESTAMP) && \
	docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(PROJECT)-$(ENV)-$(SERVICE):$(BUILD_TIMESTAMP) 

infraestructure:
	@if [[ "IMAGE-READY" = "IMAGE-READY" ]]; then\
		cd terraform ;\
		terraform init -backend-config="bucket=$(PROJECT)-terraform" -backend-config="key=$(SERVICE)/$(ENV)/terraform.tfstate" -backend-config="region=${AWS_REGION}" ;\
		terraform plan \
		-var 'image='$(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(PROJECT)-$(ENV)-$(SERVICE):$(BUILD_TIMESTAMP)'' \
		-var 'owner='$(PROJECT)'' \
		-var 'env='$(ENV)'' \
		-var 'service='$(SERVICE)'' ;\
		terraform apply \
		-var 'image='$(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(PROJECT)-$(ENV)-$(SERVICE):$(BUILD_TIMESTAMP)'' \
		-var 'owner='$(PROJECT)'' \
		-var 'env='$(ENV)'' \
		-var 'service='$(SERVICE)'' \
		-auto-approve ; \
	else \
		echo -ne "\e[41m[ERROR]\e[0m CONTAINER NO RESPONDE A LA COMPROBACION DE SALUD\e[0m\n" ;\
    fi