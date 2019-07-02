FROM buildpack-deps:xenial as builder
MAINTAINER Xuejie Xiao <xxuejie@gmail.com>

RUN apt-get update && apt-get install -y git autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev

WORKDIR /source
COPY ./ .

ENV CFLAGS_FOR_TARGET_EXTRA "-Os -DCKB_NO_MMU -D__riscv_soft_float -D__riscv_float_abi_soft"

RUN mkdir -p /riscv
RUN cd /source && ./docker/check_git
RUN cd /source && git rev-parse HEAD > /REVISION
RUN cd /source && ./configure --prefix=/riscv --with-arch=rv64imac && make -j$(nproc)

FROM buildpack-deps:xenial
MAINTAINER Xuejie Xiao <xxuejie@gmail.com>
COPY --from=builder /riscv /riscv
COPY --from=builder /REVISION /riscv/REVISION
RUN apt-get update && apt-get install -y autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev cmake && apt-get clean
ENV RISCV /riscv
ENV PATH "${PATH}:${RISCV}/bin"
CMD ["riscv64-unknown-elf-gcc", "--version"]
