default: build run
build:
	docker build -t gspencerfabian/goracle .
run:
	docker run -it gspencerfabian/goracle /bin/bash
