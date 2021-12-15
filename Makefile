IMAGE=commons_vote
all: build
build:
	docker build -t ${IMAGE} .
