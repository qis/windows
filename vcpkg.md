# Vcpkg
Installation instructions for Vcpkg with custom toolchains for Windows and Linux.

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

Build Vcpkg.

```cmd
bootstrap-vcpkg -disableMetrics -win64
```

Replace Vcpkg toolchain files.

```cmd
rd /q /s C:\Workspace\vcpkg\scripts\toolchains
rem git clone git@github.com:qis/toolchains C:\Workspace\vcpkg\scripts\toolchains
git clone https://github.com/qis/toolchains C:\Workspace\vcpkg\scripts\toolchains
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
# Download LLVM source code.
git clone --depth 1 https://github.com/llvm-project/llvm-project-submodule llvm
for i in clang clang-tools-extra compiler-rt libcxx libcxxabi libunwind lld llvm openmp pstl; do
  sh -c "cd llvm && git submodule update --init --depth 1 -- $i"
done
ls llvm/{clang,clang-tools-extra,compiler-rt,libcxx,libcxxabi,libunwind,lld,llvm,openmp,pstl}

# Download TBB source code.
git clone -b tbb_2019 --depth 1 https://github.com/01org/tbb tbb

# Unregister toolchain.
sudo update-alternatives --remove-all cc
sudo update-alternatives --remove-all c++
sudo rm -f /etc/ld.so.conf.d/llvm.conf
sudo ldconfig

# Stage LLVM.
rm -rf llvm/stage; mkdir -p llvm/stage; pushd llvm/stage
cmake -GNinja -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="/opt/stage" \
  -DLLVM_ENABLE_PROJECTS="clang;compiler-rt;libcxx;libcxxabi;libunwind;lld" \
  -DLLVM_TARGETS_TO_BUILD="X86" \
  -DLLVM_ENABLE_ASSERTIONS=OFF \
  -DLLVM_ENABLE_WARNINGS=OFF \
  -DLLVM_ENABLE_PEDANTIC=OFF \
  -DLLVM_INCLUDE_EXAMPLES=OFF \
  -DLLVM_INCLUDE_TESTS=OFF \
  -DLLVM_INCLUDE_DOCS=OFF \
  -DCLANG_DEFAULT_STD_C="c99" \
  -DCLANG_DEFAULT_STD_CXX="cxx17" \
  -DCLANG_DEFAULT_CXX_STDLIB="libc++" \
  -DCLANG_DEFAULT_RTLIB="compiler-rt" \
  -DCLANG_DEFAULT_LINKER="lld" \
  -DLIBUNWIND_ENABLE_SHARED=OFF \
  -DLIBUNWIND_ENABLE_STATIC=ON \
  -DLIBCXXABI_ENABLE_SHARED=OFF \
  -DLIBCXXABI_ENABLE_STATIC=ON \
  -DLIBCXXABI_USE_COMPILER_RT=ON \
  -DLIBCXXABI_USE_LLVM_UNWINDER=ON \
  -DLIBCXXABI_ENABLE_STATIC_UNWINDER=ON \
  -DLIBCXXABI_ENABLE_ASSERTIONS=OFF \
  -DLIBCXXABI_ENABLE_EXCEPTIONS=ON \
  -DLIBCXX_ENABLE_SHARED=ON \
  -DLIBCXX_ENABLE_STATIC=OFF \
  -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON \
  -DLIBCXX_ENABLE_ASSERTIONS=OFF \
  -DLIBCXX_ENABLE_EXCEPTIONS=ON \
  -DLIBCXX_ENABLE_FILESYSTEM=ON \
  -DLIBCXX_ENABLE_EXPERIMENTAL_LIBRARY=ON \
  -DLIBCXX_INSTALL_EXPERIMENTAL_LIBRARY=ON \
  -DLIBCXX_INCLUDE_BENCHMARKS=OFF \
  ../llvm
/usr/bin/time cmake --build . --target install -- -j7
# 30 min
popd

# Install LLVM.
rm -rf llvm/build; mkdir -p llvm/build; pushd llvm/build
PATH="/opt/stage/bin:$PATH" CC="clang" CXX="clang++" \
CFLAGS="-march=broadwell -mavx2" CXXFLAGS="$CFLAGS" LDFLAGS="-Wl,-S" \
LD_LIBRARY_PATH="/opt/stage/lib:/opt/stage/lib/clang/9.0.0/lib/linux:$LD_LIBRARY_PATH" \
cmake -GNinja -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="/opt/llvm" \
  -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;compiler-rt;libcxx;libcxxabi;libunwind;lld" \
  -DLLVM_TARGETS_TO_BUILD="X86;WebAssembly" \
  -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="WebAssembly" \
  -DLLVM_ENABLE_ASSERTIONS=OFF \
  -DLLVM_ENABLE_WARNINGS=OFF \
  -DLLVM_ENABLE_PEDANTIC=OFF \
  -DLLVM_ENABLE_LTO=Thin \
  -DLLVM_ENABLE_LLD=ON \
  -DLLVM_INCLUDE_EXAMPLES=OFF \
  -DLLVM_INCLUDE_TESTS=OFF \
  -DLLVM_INCLUDE_DOCS=OFF \
  -DCLANG_DEFAULT_STD_C="c99" \
  -DCLANG_DEFAULT_STD_CXX="cxx17" \
  -DCLANG_DEFAULT_CXX_STDLIB="libc++" \
  -DCLANG_DEFAULT_RTLIB="compiler-rt" \
  -DCLANG_DEFAULT_LINKER="lld" \
  -DLIBUNWIND_ENABLE_SHARED=OFF \
  -DLIBUNWIND_ENABLE_STATIC=ON \
  -DLIBCXXABI_ENABLE_SHARED=OFF \
  -DLIBCXXABI_ENABLE_STATIC=ON \
  -DLIBCXXABI_USE_COMPILER_RT=ON \
  -DLIBCXXABI_USE_LLVM_UNWINDER=ON \
  -DLIBCXXABI_ENABLE_STATIC_UNWINDER=ON \
  -DLIBCXXABI_ENABLE_ASSERTIONS=OFF \
  -DLIBCXXABI_ENABLE_EXCEPTIONS=ON \
  -DLIBCXX_ENABLE_SHARED=ON \
  -DLIBCXX_ENABLE_STATIC=OFF \
  -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON \
  -DLIBCXX_ENABLE_ASSERTIONS=OFF \
  -DLIBCXX_ENABLE_EXCEPTIONS=ON \
  -DLIBCXX_ENABLE_FILESYSTEM=ON \
  -DLIBCXX_ENABLE_EXPERIMENTAL_LIBRARY=ON \
  -DLIBCXX_INSTALL_EXPERIMENTAL_LIBRARY=ON \
  -DLIBCXX_INCLUDE_BENCHMARKS=OFF \
  ../llvm
LD_LIBRARY_PATH="/opt/stage/lib:/opt/stage/lib/clang/9.0.0/lib/linux:$LD_LIBRARY_PATH" \
/usr/bin/time cmake --build . --target install -- -j7
# 80 min
popd

# Install OpenMP
rm -rf llvm/build-openmp; mkdir -p llvm/build-openmp; pushd llvm/build-openmp
PATH="/opt/llvm/bin:$PATH" CC="clang" CXX="clang++" \
CFLAGS="-march=broadwell -mavx2 -flto=thin" CXXFLAGS="$CFLAGS" LDFLAGS="-Wl,-S -flto=thin" \
LD_LIBRARY_PATH="/opt/llvm/lib:/opt/llvm/lib/clang/9.0.0/lib/linux:$LD_LIBRARY_PATH" \
cmake -GNinja -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="/opt/llvm" \
  ../openmp
LD_LIBRARY_PATH="/opt/llvm/lib:/opt/llvm/lib/clang/9.0.0/lib/linux:$LD_LIBRARY_PATH" \
cmake --build . --target install -- -j7
popd

# Install PSTL headers.
cp -R llvm/pstl/include/pstl /opt/llvm/include/c++/v1/

# Install TBB.
pushd tbb
rm -rf build/*_release
PATH="/opt/llvm/bin:$PATH" CC="clang" CXX="clang++" \
CFLAGS="-march=broadwell -mavx2" CXXFLAGS="$CFLAGS" LDFLAGS="-fuse-ld=ld -Wl,-S" \
LD_LIBRARY_PATH="/opt/llvm/lib:/opt/llvm/lib/clang/9.0.0/lib/linux:$LD_LIBRARY_PATH" \
make compiler=clang arch=intel64 stdver=c++17 cfg=release
chmod 0644 build/*_release/lib*.so*
cp -R build/*_release/lib*.so* /opt/llvm/lib/
cp -R include/tbb /opt/llvm/include/c++/v1/
tee /opt/llvm/include/c++/v1/execution <<'EOF'
#pragma once
#include "pstl/algorithm"
#include "pstl/execution"
#include "pstl/memory"
#include "pstl/numeric"
EOF
popd

# Create distribution.
pushd llvm
tar czf /opt/llvm-9.0.0-$(git rev-parse --short HEAD).tar.gz -C /opt llvm
popd

# Register toolchain.
sudo update-alternatives --install /usr/bin/cc cc /opt/llvm/bin/clang 100
sudo update-alternatives --install /usr/bin/c++ c++ /opt/llvm/bin/clang++ 100
sudo tee /etc/ld.so.conf.d/llvm.conf <<'EOF'
/opt/llvm/lib
/opt/llvm/lib/clang/9.0.0/lib/linux
EOF
sudo ldconfig
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
#   git clone git@github.com:qis/toolchains /opt/vcpkg/scripts/toolchains
git clone https://github.com/qis/toolchains /opt/vcpkg/scripts/toolchains
```

Install Vcpkg ports.

```sh
vcpkg install benchmark gtest \
  bzip2 date fmt liblzma libzip mio nlohmann-json openssl pugixml zlib
```
