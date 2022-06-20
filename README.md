# Post-Quantum Envoy Build

![envoy-logo](https://user-images.githubusercontent.com/56026339/174647661-c6c9d1f5-e7ea-4128-af01-704daf8ac045.png)  
  
Open source implementation of quantum-resistant encryption algorithms for modular TLS communication

- [Components](https://github.com/Post-Quantum-Mesh/nginx-oqs#components)
- [Overview](https://github.com/Post-Quantum-Mesh/nginx-oqs#overview)
- [Quick Start](https://github.com/Post-Quantum-Mesh/nginx-oqs#quick-start)
  - [Local Environment Setup](https://github.com/Post-Quantum-Mesh/nginx-oqs#local-environment-setup)
  - [TLS Demo](https://github.com/Post-Quantum-Mesh/nginx-oqs#tls-demo)

## Components

### Quantum-Resistant Library/TLS Protocol
- [liboqs](https://github.com/open-quantum-safe/liboqs)
- [openssl-liboqs fork](https://github.com/open-quantum-safe/openssl)
- [openssl-1.1.1](https://github.com/openssl/openssl/tree/OpenSSL_1_1_1-stable)

### Envoy Build
- [Envoy-1.21.0 open source](https://github.com/envoyproxy/envoy/tree/release/v1.21)


## Overview

< space holder >  

### Local Environment Setup

Note:
- ./configure commands followed by indented parameters (ex: ./configure --prefix=/usr/local) are all one-line commands
- All installation paths are assuming install directory is /usr/local  
  
1. Update package manager

        apt update

2. Install Dependencies and Compiler

        apt-get update

3. Install bazelisk as bazel (paths use /usr/local, modify to your desired directory)

        wget -O /usr/local/bin/bazel https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-$([ $(uname -m) = "aarch64" ] && echo "arm64" || echo "amd64")
        chmod +x /usr/local/bin/bazel

4. Install OpenSSL

        wget http://www.openssl.org/source/openssl-1.1.1g.tar.gz
        tar -xzf openssl-1.1.1g.tar.gz
        cd openssl-1.1.1g
        ./config
        make
        make install

5. Install BoringSSL-OQS fork with liboqs

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

6. Clone modified Envoy-1.21.0 fork

        git clone --single-branch --branch main https://github.com/drouhana/envoy-fork.git

7. Download and extract [Clang+LLVM 14.0.0 binary](https://github.com/llvm/llvm-project/releases/tag/llvmorg-14.0.0). Note: your specific binary may vary depending on your OS

        wget -O clang+llvm-14.0.0 https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.0/clang+llvm-14.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz
        tar -xf clang+llvm-14.0.0.tar.xz
        cd /usr/local/envoy
        bazel/setup_clang.sh /usr/local/clang+llvm-14.0.0

8. Build user.bazelrc build file, add build parameters

        cd /usr/local/envoy
        echo "build --config=libc++ --define quiche=disabled --define wasm=disabled --define deprecated_features=disabled --//bazel:http3=false --//source/extensions/quic/crypto_stream:enabled=false --//source/extensions/quic/proof_source:enabled=false" >> user.bazelrc

9. Build Envoy

        bazel build -c opt envoy

10. Link modified static-build to PATH. Note: you may have to add this to ~./bash.rc

        export PATH=$PATH:/usr/local/envoy/bazel-bin/source/exe

11. Verify installation

        envoy-static --version

![Screenshot from 2022-06-20 10-15-40](https://user-images.githubusercontent.com/56026339/174651497-fde388e6-7de7-456b-87df-fbfe119fca15.png)

## TLS Demo

< space holder >

