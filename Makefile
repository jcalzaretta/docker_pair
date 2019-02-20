HOSTNAME = `hostname -f`
UID = `id -u $(whoami)`

build:
	sudo docker build -t pair .

run:
	sudo docker run --name pair -d -p 222:222 -v ${workdir}:/home/pair/workspace -e base_uid=$(UID) pair ${USER} ${buddy}
	@echo "Paste the below to connect:"
	@echo "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $(HOSTNAME) -p222 -lpair"

clean:
	sudo docker stop pair
	sudo docker rm pair
