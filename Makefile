IMAGE=commons_vote
all: build
build:
	docker build -t ${IMAGE} .
build-no-cache:
	docker build --no-cache=true -t ${IMAGE} .
