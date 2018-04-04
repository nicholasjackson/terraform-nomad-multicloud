build_linux:
	CGO_ENABLED=0 GOOS=linux go build -o test-server .

build_docker: build_linux
	docker build -t nicholasjackson/test-server:latest .

push_docker:
	docker push nicholasjackson/test-server:latest
