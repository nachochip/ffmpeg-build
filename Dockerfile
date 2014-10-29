# ffmpeg build
# based on Julien Rottenberg <julien@rottenberg.info>
# based on docker image  rottenberg/ffmpeg

FROM		debian:wheezy
MAINTAINER	Nachochip <blockchaincolony@gmail.com>

ENV	FFMPEG_VERSION		2.4.2
ENV	FDKAAC_VERSION  	0.1.3
ENV	YASM_VERSION    	1.3.0
#ENV	LAME_VERSION    	3.99.5
#ENV	FAAC_VERSION    	1.28
#ENV	XVID_VERSION    	1.3.3
#ENV	MPLAYER_VERSION 	1.1.1
ENV	SRC             	/usr/local
ENV	LD_LIBRARY_PATH 	${SRC}/lib
ENV	PKG_CONFIG_PATH 	${SRC}/lib/pkgconfig

RUN bash -c 'set -euo pipefail'
RUN apt-get update
RUN apt-get install -y autoconf automake gcc build-essential git libtool make nasm zlib1g-dev tar curl

# yasm
RUN DIR=$(mktemp -d) && cd ${DIR} && \
              curl -Os http://www.tortall.net/projects/yasm/releases/yasm-${YASM_VERSION}.tar.gz && \
              tar xzvf yasm-${YASM_VERSION}.tar.gz && \
              cd yasm-${YASM_VERSION} && \
              ./configure --prefix="$SRC" --bindir="${SRC}/bin" && \
              make && \
              make install && \
              make distclean && \
              rm -rf ${DIR}

# x264
RUN DIR=$(mktemp -d) && cd ${DIR} && \
              git clone --depth 1 git://git.videolan.org/x264 && \
              cd x264 && \
              ./configure --prefix="$SRC" --bindir="${SRC}/bin" --enable-static && \
              make && \
              make install && \
              make distclean&& \
              rm -rf ${DIR}

# libmp3lame
#DIR=$(mktemp -d) && cd ${DIR} && \
#              curl -L -Os http://downloads.sourceforge.net/project/lame/lame/${LAME_VERSION%.*}/lame-${LAME_VERSION}.tar.gz  && \
#              tar xzvf lame-${LAME_VERSION}.tar.gz  && \
#              cd lame-${LAME_VERSION} && \
#              ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --disable-shared --enable-nasm && \
#              make && \
#              make install && \
#              make distclean&& \
#              rm -rf ${DIR}


# faac + http://stackoverflow.com/a/4320377
#DIR=$(mktemp -d) && cd ${DIR} && \
#              curl -L -Os http://downloads.sourceforge.net/faac/faac-${FAAC_VERSION}.tar.gz  && \
#              tar xzvf faac-${FAAC_VERSION}.tar.gz  && \
#              cd faac-${FAAC_VERSION} && \
#              sed -i '126d' common/mp4v2/mpeg4ip.h && \
#              ./bootstrap && \
#              ./configure --prefix="${SRC}" --bindir="${SRC}/bin" && \
#              make && \
#              make install &&\
#              rm -rf ${DIR}

# xvid
#DIR=$(mktemp -d) && cd ${DIR} && \
#              curl -L -Os  http://downloads.xvid.org/downloads/xvidcore-${XVID_VERSION}.tar.gz  && \
#              tar xzvf xvidcore-${XVID_VERSION}.tar.gz && \
#              cd xvidcore/build/generic && \
#              ./configure --prefix="${SRC}" --bindir="${SRC}/bin" && \
#              make && \
#              make install&& \
#              rm -rf ${DIR}

# fdk-aac
RUN DIR=$(mktemp -d) && cd ${DIR} && \
              curl -s https://codeload.github.com/mstorsjo/fdk-aac/tar.gz/v${FDKAAC_VERSION} | tar zxvf - && \
              cd fdk-aac-${FDKAAC_VERSION} && \
              autoreconf -fiv && \
              ./configure --prefix="${SRC}" --disable-shared && \
              make && \
              make install && \
              make distclean && \
              rm -rf ${DIR}

# ffmpeg
# removed these flags from configure:  --enable-libfaac --enable-libmp3lame  --enable-libxvid
RUN DIR=$(mktemp -d) && cd ${DIR} && \
              curl -Os http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz && \
              tar xzvf ffmpeg-${FFMPEG_VERSION}.tar.gz && \
              cd ffmpeg-${FFMPEG_VERSION} && \
              ./configure --prefix="${SRC}" --extra-cflags="-I${SRC}/include" --extra-ldflags="-L${SRC}/lib" --bindir="${SRC}/bin" \
              --extra-libs=-ldl --enable-version3 --enable-libx264 --enable-gpl \
              --enable-postproc --enable-nonfree --enable-avresample --enable-libfdk_aac --disable-debug --enable-small && \
              make && \
              make install && \
              make distclean && \
              hash -r && \
              rm -rf ${DIR}

# mplayer
#DIR=$(mktemp -d) && cd ${DIR} && \
#              curl -Os http://mplayerhq.hu/MPlayer/releases/MPlayer-${MPLAYER_VERSION}.tar.xz && \
#              tar xvf MPlayer-${MPLAYER_VERSION}.tar.xz && \
#              cd MPlayer-${MPLAYER_VERSION} && \
#              ./configure --prefix="${SRC}" --extra-cflags="-I${SRC}/include" --extra-ldflags="-L${SRC}/lib" --bindir="${SRC}/bin" && \
#              make && \
#              make install && \
#              rm -rf ${DIR}

RUN apt-get purge -y autoconf automake gcc build-essential git libtool make nasm zlib1g-dev curl
RUN apt-get clean
RUN apt-get autoclean

#RUN rm -rf /var/lib/yum/yumdb/*
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/libc.conf

CMD           ["--help"]
ENTRYPOINT    ["ffmpeg"]

