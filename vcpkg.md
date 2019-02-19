# Vcpkg
Installation instructions for Vcpkg on Windows and Linux.

## Windows
Set environment variables.

```cmd
set PATH=%PATH%;C:\Workspace\vcpkg
set VCPKG_DEFAULT_TRIPLET=x64-windows
```

Check out Vcpkg.

```cmd
git clone https://github.com/Microsoft/vcpkg C:\Workspace\vcpkg
```

Build and install Vcpkg.

```cmd
bootstrap-vcpkg -disableMetrics && vcpkg integrate install
```

Replace Vcpkg toolchain files.

```cmd
rd /q /s C:\Workspace\vcpkg\scripts\toolchains
git clone https://github.com/qis/toolchains C:\Workspace\vcpkg\scripts\toolchains
copy /Y C:\Workspace\vcpkg\scripts\toolchains\triplets\*.cmake C:\Workspace\vcpkg\triplets\
```

Install Vcpkg ports.

```cmd
vcpkg install benchmark gtest ^
  bzip2 date fmt liblzma libzip mio nlohmann-json openssl pugixml zlib ^
  angle freetype giflib harfbuzz libjpeg-turbo libpng opus
```

## Linux
Set environment variables.

```sh
export PATH="${PATH}:/opt/vcpkg"
```

Install compatible compiler.

```sh
# Remove previous LLVM version.
rm -rf /opt/llvm

# Remove dynamic linker run-time bindings.
sudo rm -f /etc/ld.so.conf.d/llvm.conf
sudo ldconfig

# Remove system-wide symbolic links.
sudo update-alternatives --remove-all cc
sudo update-alternatives --remove-all c++

# Check out LLVM.
rm -rf llvm
git clone --depth 1 https://github.com/llvm-project/llvm-project-submodule llvm && cd llvm
for i in clang clang-tools-extra compiler-rt libcxx libcxxabi libunwind lld lldb llvm openmp pstl; do
  git submodule update --init --depth 1 -- $i
done

# Configure LLVM.
rm -rf build; mkdir -p build; cd build
cmake -GNinja -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;compiler-rt;libcxx;libcxxabi;libunwind;lld;lldb;openmp" \
  -DCMAKE_INSTALL_PREFIX="/opt/llvm" \
  -DLLVM_TARGETS_TO_BUILD="AArch64;ARM;X86;WebAssembly" \
  -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="WebAssembly" \
  -DLLVM_ENABLE_ASSERTIONS=OFF \
  -DLLVM_ENABLE_WARNINGS=OFF \
  -DLLVM_ENABLE_PEDANTIC=OFF \
  -DLLVM_INCLUDE_EXAMPLES=OFF \
  -DLLVM_INCLUDE_TESTS=OFF \
  -DLLVM_INCLUDE_DOCS=OFF \
  -DCLANG_DEFAULT_CXX_STDLIB="libc++" \
  -DLIBCXXABI_ENABLE_ASSERTIONS=OFF \
  -DLIBCXXABI_ENABLE_EXCEPTIONS=ON \
  -DLIBCXXABI_ENABLE_SHARED=ON \
  -DLIBCXXABI_ENABLE_STATIC=OFF \
  -DLIBCXXABI_USE_LLVM_UNWINDER=ON \
  -DLIBCXX_ENABLE_ASSERTIONS=OFF \
  -DLIBCXX_ENABLE_EXCEPTIONS=ON \
  -DLIBCXX_ENABLE_SHARED=ON \
  -DLIBCXX_ENABLE_STATIC=OFF \
  -DLIBCXX_ENABLE_ASSERTIONS=OFF \
  -DLIBCXX_ENABLE_FILESYSTEM=ON \
  -DLIBCXX_ENABLE_EXPERIMENTAL_LIBRARY=ON \
  -DLIBCXX_INSTALL_EXPERIMENTAL_LIBRARY=ON \
  -DLIBCXX_INCLUDE_BENCHMARKS=OFF \
  ../llvm

# Build and install LLVM.
cmake --build . --target install -- -j7
cp -R ../pstl/include/pstl /opt/llvm/include/c++/v1/
cd

# Check out TBB.
git clone -b tbb_2019 --depth 1 https://github.com/01org/tbb tbb && cd tbb

# Build and install TBB.
make compiler=clang arch=intel64 tbb tbbmalloc
chmod 0644 build/*_release/lib{tbb,tbbmalloc}.so*
cp -R build/*_release/lib{tbb,tbbmalloc}.so* /opt/llvm/lib/
cp -R include/tbb /opt/llvm/include/c++/v1/
tee /opt/llvm/include/c++/v1/execution <<EOF
#pragma once
#include "pstl/algorithm"
#include "pstl/execution"
#include "pstl/memory"
#include "pstl/numeric"
EOF
cd

# Configure system-wide symbolic links.
sudo update-alternatives --install /usr/bin/cc cc /opt/llvm/bin/clang 100
sudo update-alternatives --install /usr/bin/c++ c++ /opt/llvm/bin/clang++ 100

# Configure dynamic linker run-time bindings.
sudo tee /etc/ld.so.conf.d/llvm.conf <<EOF
/opt/llvm/lib
/opt/llvm/lib/clang/9.0.0/lib/linux
EOF
sudo ldconfig

# Create distribution.
cd /opt/llvm/lib
tar cvzf /opt/llvm-9.0.0-lib.tar.gz lib{c++,c++abi,unwind,omp,tbb,tbbmalloc}.so*
```

Check out Vcpkg.

```sh
git clone https://github.com/Microsoft/vcpkg /opt/vcpkg
```

Build and install Vcpkg.

```sh
bootstrap-vcpkg.sh -disableMetrics -useSystemBinaries
rm -rf /opt/vcpkg/toolsrc/build.rel
```

Replace Vcpkg toolchain files.

```sh
rm -rf /opt/vcpkg/scripts/toolchains
git clone https://github.com/qis/toolchains /opt/vcpkg/scripts/toolchains
cp /opt/vcpkg/scripts/toolchains/triplets/*.cmake /opt/vcpkg/triplets/
sed s/dynamic/static/g /opt/vcpkg/triplets/x64-linux.cmake > /opt/vcpkg/triplets/x64-linux-static.cmake
```

Install Vcpkg ports.

```sh
vcpkg install benchmark gtest \
  bzip2 date fmt liblzma libzip mio nlohmann-json openssl pugixml zlib
```
