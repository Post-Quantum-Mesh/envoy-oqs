## Front-Proxy Demo

### Generate Certificates:

All necessary commands are encapsulated in gen_cert.sh. In order to change the encryption algorith, change the term following "-newkey" flag in lines 3 and 5. To execute, navigate to ./certs and run the following command:

    ./gen_cert.sh

### Startup Proxy Servers:

Open one terminal and run the following command:

    ./init.sh

The following commands will be run by the shell script:

    sudo docker-compose pull
    sudo docker-compose up --build -d
    sudo docker-compose ps

### Query Proxy Servers:

A shell script with all instructions has been provided to query the servers and run the demo. To print instructions, run the following
	
    ./query.sh -h

#### Select Service to Query

To query service 1 or 2, pass the numerical argument with the "-s" flag. Example:

    ./query.sh -s 1

#### Query Post-Quantum Servers Using Pre-Quantum Curl Implementation

This command will fail. To attempt TLS authentication using pre-quantum curl, run the following

    ./query.sh -f -s <SERVICE>

#### Query Post-Quantum Servers Using Post-Quantum Curl Implementation

To perform TLS authentication using post-quantum curl, run the following

    ./query.sh -q -s <SERVICE>

### Terminate Proxy Servers:

In a second terminal, run the following command:
    
    ./kill.sh

The following commands will be run by the shell script:

    sudo docker kill $(sudo docker ps -q)
    sudo docker container prune -f
