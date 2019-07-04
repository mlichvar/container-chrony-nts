all:
	docker build -t chrony-nts --pull .

run:
	docker run --rm --name chrony-nts -p 11123:11123/udp -p 11443:11443 -p 443:11443/tcp chrony-nts
