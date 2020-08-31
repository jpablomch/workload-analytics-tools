#!/bin/bash

# TODO Add args for dirs and other config
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  cores=$(nproc)
elif [[ "$OSTYPE" == "darwin"* ]]; then
  cores=$(sysctl -n hw.ncpu)
else
  echo "Unknown OSTYPE: $OSTYPE"
  exit 1
fi

apt-get update -qq && apt-get -y install \
  autoconf \
  automake \
  build-essential \
  git \
  libass-dev \
  libfreetype6-dev \
  libsdl2-dev \
  libtool \
  libva-dev \
  libvdpau-dev \
  libvorbis-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  pkg-config \
  texinfo \
  wget \
  zlib1g-dev \
  gnutls-bin \
  libgnutls28-dev

  #  cmake \

export CC=gcc-8
export CXX=g++-8
export CPP=gcc-8

INSTALL_PREFIX=/usr/local
BUILD_DIR=build
#cd $BUILD_DIR
rm -fr $BUILD_DIR/ffmpeg_build
mkdir -p $BUILD_DIR/ffmpeg_build && cd $BUILD_DIR/ffmpeg_build

# Building SVT-HEVC
#git clone https://github.com/OpenVisualCloud/SVT-HEVC
#cd SVT-HEVC/Build/linux
#./build.sh release
#cd Release
#make install
## Add these to your path. TODO: Add instructions
#export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib
#export PKG_CONFIG_PATH=${PKG_CONFIG_PATH}:/usr/local/lib/pkgconfig

# FFMPEG
#cd $BUILD_DIR/ffmpeg_build
#git clone -b n4.2 https://git.ffmpeg.org/ffmpeg.git && cd ffmpeg && \
git clone https://github.com/FFmpeg/FFmpeg ffmpeg && cd ffmpeg
git checkout release/4.2
# Patch SVT-HEVC
#git am ../SVT-HEVC/ffmpeg_plugin/0001*.patch
#		        --enable-libx265 \
                # Replacing libx265 for svt-hevc
#                --enable-libsvthevc \

apt-get install -y libx265-dev libx264-dev libnuma-dev nasm yasm libvpx-dev libfdk-aac-dev libmp3lame-dev
./configure --prefix=$INSTALL_PREFIX \
                --enable-shared --disable-stripping \
                --disable-decoder=libschroedinger \
                --enable-avresample \
                --enable-libx264 \
                --enable-nonfree \
                --enable-gpl \
                --enable-gnutls \
                --enable-libx265 \
                $(echo $CMDS) && \
make -j${cores} && make install
touch ffmpeg.done \
        || { echo 'Installing ffmpeg failed!' ; exit 1; }
echo "Done installing ffmpeg 4.2"

apt-get install -y libeigen3-dev libgflags-dev libgtest-dev libgoogle-glog-dev libatlas-base-dev libsuitesparse-dev \
      libgflags-dev libopenblas-dev \
      liblapacke-dev

#### OpenCV
mkdir -p $BUILD_DIR/opencv_build
cd $BUILD_DIR/opencv_build
rm -rf opencv opencv_contrib ceres-solver
#git clone https://github.com/jpablomch/opencv && \
git clone https://github.com/opencv/opencv && \
git clone -b 4.2.0  https://github.com/opencv/opencv_contrib \
    --depth 1 && \
git clone -b 1.14.0 https://github.com/ceres-solver/ceres-solver \
    --depth 1 && \
cd ceres-solver && mkdir -p build_cmake && cd build_cmake && \
cmake .. -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX && \
make install -j$cores && \
mkdir -p $BUILD_DIR/opencv/build && cd $BUILD_DIR/opencv/build && \
rm -r $BUILD_DIR/opencv_build
mkdir -p $BUILD_DIR/opencv_build && cd $BUILD_DIR/opencv_build && \
cmake -D CMAKE_BUILD_TYPE=Release \
              -D CMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
              -D BUILD_TESTS=OFF -D BUILD_PERF_TESTS=OFF -D ENABLE_FAST_MATH=1 \
              -D WITH_CUDA=ON -D CUDA_FAST_MATH=1 -D WITH_CUBLAS=1 -D WITH_NVCUVID=1 \
              -D BUILD_opencv_rgbd=OFF \
              -D BUILD_opencv_cnn_3dobj=OFF \
              -D BUILD_opencv_cudacodec=OFF \
              -D BUILD_opencv_xfeatures2d=OFF \
              -D WITH_PROTOBUF=OFF \
              -D BUILD_PROTOBUF=OFF \
              -D OPENCV_EXTRA_MODULES_PATH=$BUILD_DIR/opencv_contrib/modules \
              -D WITH_INF_ENGINE=ON \
              -D ENABLE_CXX11=ON \
              -D BUILD_opencv_dnn=ON \
              -D OPENCV_ENABLE_NONFREE=ON \
              -D WITH_PROTOBUF=ON \
              -D BUILD_PROTOBUF=ON \
              -D BUILD_LIBPROTOBUF_FROM_SOURCES=OFF \
              -D WITH_FFMPEG=ON \
              -D BUILD_WEBP=OFF \
              -D WITH_WEBP=OFF \
              -D WITH_OPENMP=ON \
	      $(echo $CMDS) -DCMAKE_PREFIX_PATH=$(echo $PY_EXTRA_CMDS) ../opencv
        make install -j$cores && touch opencv.done \
            || { echo 'Installing OpenCV failed!' ; exit 1; }
    echo "Done installing OpenCV 4.2.0"

cd ..
rm -r build

