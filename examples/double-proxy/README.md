# Double-Proxy

### Generate Certificates:

All necessary commands are encapsulated in gen_cert.sh.

    ./gen_cert.sh

### Startup Proxy Servers:

Open one terminal and run the following command:

    ./init.sh

The following commands will be run by the shell script:

    sudo docker-compose pull
    sudo docker-compose up --build -d
    sudo docker-compose ps

### Current Issues

Flask service is unresponsive (see relevant issue tracking efforts).

### Terminate Proxy Servers:

In a second terminal, run the following command:
    
    ./kill.sh

The following commands will be run by the shell script:

    sudo docker kill $(sudo docker ps -q)
    sudo docker container prune -f
