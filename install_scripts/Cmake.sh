#!/bin/bash

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  cores=$(nproc)
elif [[ "$OSTYPE" == "darwin"* ]]; then
  cores=$(sysctl -n hw.ncpu)
else
  echo "Unknown OSTYPE: $OSTYPE"
  exit 1
fi

apt-get install -y libssl-dev

wget -c "https://cmake.org/files/v3.16/cmake-3.16.0.tar.gz"
tar -xf cmake-3.16.0.tar.gz && cd cmake-3.16.0
./bootstrap --parallel=${cores} -- -DCMAKE_USE_OPENSSL=ON
make -j${cores}
make install
cd ..
rm -rf cmake-3.16.0.tar.gz cmake-3.16.0