#!/bin/bash

. abi_settings.sh $1 $2 $3

pushd ffmpeg

case $1 in
  armeabi-v7a | armeabi-v7a-neon)
    CPU='cortex-a8'
  ;;
  x86)
    CPU='i686'
  ;;
esac

make clean

./configure \
--target-os="$TARGET_OS" \
--cross-prefix="$CROSS_PREFIX" \
--arch="$NDK_ABI" \
--cpu="$CPU" \
--enable-runtime-cpudetect \
--sysroot="$NDK_SYSROOT" \
--enable-pic \
--enable-libx264 \
--enable-libass \
--enable-libfreetype \
--enable-libfribidi \
--enable-libmp3lame \
--enable-fontconfig \
--enable-pthreads \
--disable-debug \
--disable-ffserver \
--enable-version3 \
--enable-hardcoded-tables \
--disable-ffplay \
--disable-ffprobe \
--enable-gpl \
--enable-yasm \
--disable-doc \
--disable-shared \
--enable-static \
--disable-bsfs      --enable-bsf=h264_mp4toannexb \
--disable-filters   --enable-filter=scale,aresample \
--disable-parsers   --enable-parser=h264,aac,aac_latm \
--disable-protocols --enable-protocol=file,pipe,concat \
--disable-encoders  --enable-encoder=libmp3lame,wav,pcm_s16le,pcm_s32le \
--disable-decoders  --enable-decoder=aac,flv,h264,mp3,x264,mpeg4,wav,vc1,vorbis,vp8,pcm_s16le,pcm_s32le \
--disable-demuxers  --enable-demuxer=flv,matroska,mov,mp3,x264,mp4,wav,sox,h264,mpegts,pcm_s16le \
--disable-muxers    --enable-muxer=flv,matroska,mov,mp3,mp4,x264,ismv,tgp,tg2,wav,webm,sox,h264,mpegts,null,pcm_s16le \
--pkg-config="${2}/ffmpeg-pkg-config" \
--prefix="${2}/build/${1}" \
--extra-cflags="-I${TOOLCHAIN_PREFIX}/include $CFLAGS" \
--extra-ldflags="-L${TOOLCHAIN_PREFIX}/lib $LDFLAGS" \
--extra-libs="-lpng -lexpat -lm" \
--extra-cxxflags="$CXX_FLAGS" || exit 1

make -j${NUMBER_OF_CORES} && make install || exit 1

popd
