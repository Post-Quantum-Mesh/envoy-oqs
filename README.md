# Post-Quantum Envoy Deployment

![envoy-logo](https://user-images.githubusercontent.com/56026339/174647661-c6c9d1f5-e7ea-4128-af01-704daf8ac045.png)  
  
Open source implementation of quantum-resistant encryption algorithms for modular TLS communication

- [Components](https://github.com/Post-Quantum-Mesh/envoy-oqs#components)
- [Overview](https://github.com/Post-Quantum-Mesh/envoy-oqs#overview)
- [Quick Start](https://github.com/Post-Quantum-Mesh/envoy-oqs#quick-start)
  - [Docker Image]()
  - [Local Environment Setup](https://github.com/Post-Quantum-Mesh/envoy-oqs#local-environment-setup)
- [Post-Quantum Enabled Demos](https://github.com/Post-Quantum-Mesh/envoy-oqs#post-quantum-enabled-demos)
  - [Transport Layer Security (TLS)](https://github.com/Post-Quantum-Mesh/envoy-oqs#transport-layer-security-tls)
  - [Front Proxy](https://github.com/Post-Quantum-Mesh/envoy-oqs#front-proxy)

## Components

### Quantum-Resistant Library/TLS Protocol
- [liboqs](https://github.com/open-quantum-safe/liboqs)
- [modified boringssl-liboqs fork](https://github.com/drouhana/boringssl.git)
- [openssl-liboqs fork](https://github.com/open-quantum-safe/openssl)
- [openssl-1.1.1](https://github.com/openssl/openssl/tree/OpenSSL_1_1_1-stable)

### Envoy Build
- [Envoy-1.23.0 open source](https://github.com/Post-Quantum-Mesh/envoy-oqs.git)


## Overview

< space holder >  

## Quick Start

### Docker Image

A compiled [docker image](https://hub.docker.com/layers/drouhana/envoy-oqs/envoy/images/sha256-e779ccfd8707e31fbf3f47f1f2ac99cb52ea56f6e923a87fbb12b7fa1dbca114?context=repo) has been provided for development use.

To incorporate into a dockerfile, set the base image build stage as

    FROM drouhana/envoy-oqs:envoy

The envoy-static binary has been already added to path, and symlinked to "envoy." To invoke in a dockerfile, the command is the same as the standard envoy implementation. Example:

    CMD ["envoy", "-c", "/etc/example/envoy.yaml"]

### Local Environment Setup

Installation Notes:
- All installation paths are assuming install directory is /usr/local
- Commands will likely need to be run as sudo
- ./configure commands followed by indented parameters (ex: ./configure --prefix=/usr/local) are all one-line commands

  
1. Update package manager

        apt-get update

2. Install Dependencies and Compiler

        apt-get install -y autoconf automake cmake curl libtool make ninja-build patch python3-pip unzip virtualenv

3. Install bazelisk as bazel (paths use /usr/local, modify to your desired directory)

        wget -O /usr/local/bin/bazel https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-$([ $(uname -m) = "aarch64" ] && echo "arm64" || echo "amd64")
        chmod +x /usr/local/bin/bazel

4. Install OpenSSL

        cd /usr/local
        wget http://www.openssl.org/source/openssl-1.1.1g.tar.gz
        tar -xzf openssl-1.1.1g.tar.gz
        cd openssl-1.1.1g
        ./config
        make
        make install

5. Install BoringSSL-OQS fork with liboqs

        cd /usr/local
        git clone --branch master https://github.com/open-quantum-safe/boringssl.git 
        git clone --branch main https://github.com/open-quantum-safe/liboqs.git
        cd liboqs
        mkdir build && cd build
        cmake -G"Ninja" -DCMAKE_INSTALL_PREFIX=/usr/local/boringssl/oqs -DOQS_USE_OPENSSL=OFF ..
        ninja
        ninja install
        cd /usr/local/boringssl
        mkdir build && cd build
        cmake -GNinja ..
        ninja

6. Clone modified Envoy-1.23.0 fork

        cd /usr/local
        git clone --single-branch --branch main https://github.com/Post-Quantum-Mesh/envoy-oqs.git envoy

7. Download and extract [Clang+LLVM 14.0.0 binary](https://github.com/llvm/llvm-project/releases/tag/llvmorg-14.0.0). Note: your specific binary may vary depending on your OS

        cd /usr/local
        wget https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.0/clang+llvm-14.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz
        tar -xf clang+llvm-14.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz
        cd /usr/local/envoy
        bazel/setup_clang.sh /usr/local/clang+llvm-14.0.0-x86_64-linux-gnu-ubuntu-18.04

8. Build user.bazelrc build file, add build parameters

        cd /usr/local/envoy
        echo "build --config=libc++" >> user.bazelrc

   Note: If echo command errors out with "permission denied," create the file manually and change ownership. Example:

        touch user.bazelrc
        chown $USER user.bazelrc
        echo "build --config=libc++" >> user.bazelrc

9. Build Envoy (Note: do not run command as sudo)

        bazel build -c opt envoy

10. Link modified static-build to PATH. Note: you may have to add this to ~./bash.rc

        export PATH=$PATH:/usr/local/envoy/bazel-bin/source/exe

11. Verify installation

        envoy-static --version

![image](https://user-images.githubusercontent.com/56026339/188688403-69b4d2cb-1ee4-4a26-b17f-d90f3166cd79.png)

# Post-Quantum Enabled Demos

Note: All post-quantum enabled demos are located in [./examples/](https://github.com/Post-Quantum-Mesh/envoy-oqs/tree/main/examples)

## Transport Layer Security (TLS)

### Generate Certificates:

All necessary commands are encapsulated in gen_cert.sh. In order to change the encryption algorith, change the term following "-newkey" flag in lines 3 and 5. To execute, navigate to ./certs and run the following command:

    ./gen_cert.sh

### Startup TLS Server:

Open one terminal and run the following command:

    ./init.sh

The following commands will be run by the shell script:

    sudo docker-compose pull
    sudo docker-compose up --build -d
    sudo docker-compose ps

### Query TLS Server:

In a second terminal, run the following command:
	
    curl -k https://localhost:10000

### Terminate TLS Server:

In a second terminal, run the following command:
    
    ./kill.sh

The following commands will be run by the shell script:

    sudo docker kill $(sudo docker ps -q)
    sudo docker container prune -f


## Front-Proxy

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
