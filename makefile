.PHONY: start stop restart shell reactor format build install

install: start
	docker-compose exec node npm install

start:
	docker-compose up -d node

stop:
	docker-compose down

restart: stop start

shell: start
	docker-compose exec node bash

reactor: start
	docker-compose exec node npm start

format: start
	docker-compose exec node npm run format

build: start
	docker-compose exec node npm run build