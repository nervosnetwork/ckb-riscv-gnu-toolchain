FROM nervos/ckb-riscv-gnu-toolchain:bionic-20191209
MAINTAINER Xuejie Xiao <xxuejie@gmail.com>

RUN apt-get update && apt-get install -y ruby ruby-dev && apt-get clean
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain stable -y

ENV PATH=/root/.cargo/bin:$PATH
