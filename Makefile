version = 1.0.0

build:
	docker build -t docker.clarin.eu/lindat-dspace:${version} .

all: build
