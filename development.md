# Development
Installation and configuration of a Windows 10 development workstation.


## Tools
Install various tools for development.

* [Git](https://git-scm.com/downloads)

```
Select Destination Location
  C:\Program Files\Git
Select Components
  [✓] Git LFS (Large File Support)
Select Start Menu Folder
  [✓] Don't create a Start Menu folder
Choosing the default editor used by Git
  [Select other editor as Git's default editor]
  Location of editor: C:\Program Files (x86)\Vim\vim81\gvim.exe
  [Test Custom Editor]
Adjusting your PATH environment
  (•) Use Git from Git Bash only
Choosing the SSH executable
  (•) Use OpenSSH
Choosing HTTPS transport backend
  (•) Use the OpenSSL library
Configuring the line ending conversions
  (•) Checkout as-is, commit as-is
Configuring the terminal emulator to use with Git Bash
  (•) Use Windows' default console window
Configuring file system caching
  [✓] Enable file system caching
  [✓] Enable Git Credential Manager
  [✓] Enable symbolic links
```

* [CMake](https://cmake.org)

```
Install Options
  (•) Do not add CMake to the system PATH
  [ ] Create CMake Desktop Icon
Destination Folder
  C:\Program Files\CMake
```

* [Node LTS](https://nodejs.org)

```
Destination Folder
  C:\Node
Custom Setup
  [✓] Node.js runtime
  [✓] npm package manager
  [✗] Online documentation shortcuts
  [✗] Add to PATH
```

* [Python 2](https://www.python.org/downloads/)

```
Select where to install Python
  (•) Install for all users
Select Destination Directory
  C:\Python
Customize Python
  [■] Python
    [✓] Register Extensions
    [✓] Tcl/Tk
    [✗] Documentation
    [✓] Utility Scripts
    [✓] pip
    [✓] Test suite
    [✗] Add python.exe to Path
  [Advanced]
    [✓] Compile .py files to byte code after installation
```

* [Java SE Development Kit (JDK) 8](http://www.oracle.com/technetwork/java/javase/downloads/index.html)

```
Select optional features
  [✓] Development Tools
  [✗] Source Code
  [✗] Public JRE
  Install to: C:\Program Files\Java
```

* [Visual Studio Code](https://code.visualstudio.com/download) (System Installer)

```
Select Additional Tasks
  [ ] Create a desktop icon
  [✓] Add "Open with Code" action to Windows Explorer file context menu
  [✓] Add "Open with Code" action to Windows Explorer directory context menu
  [✓] Register Code as an editor for supported file types
  [ ] Add to PATH (available after restart)
```

* [Gradle](https://gradle.org/releases/) into `C:\Program Files\Gradle`
* [Ninja](https://github.com/ninja-build/ninja/releases) into `C:\Program Files\Ninja`
* [NASM](http://www.nasm.us) into `C:\Program Files\NASM`

Install various tools for debugging.

* [CFF Explorer](http://www.ntcore.com/exsuite.php)
* [Resource Hacker](http://www.angusj.com/resourcehacker)
* [Sysinternals Suite](https://technet.microsoft.com/en-us/sysinternals/bb842062.aspx)

Install a standalone version of `clang-format`.

* [Clang Format](https://llvm.org/builds/) as `C:\Program Files (x86)\clang-format.exe`


## Environment Variables
Configure the User `Path` environment variable.

```
%UserProfile%\AppData\Local\Microsoft\WindowsApps
%UserProfile%\AppData\Roaming\npm
```

Configure the System `Path` environment variable.

```
%SystemRoot%\System32
%SystemRoot%
%SystemRoot%\System32\Wbem
%SystemRoot%\System32\WindowsPowerShell\v1.0
%SystemRoot%\System32\OpenSSH
%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Community\Common7\IDE
%ProgramFiles(x86)%\Windows Kits\8.1\bin\x86
%ProgramFiles(x86)%\Sysinternals Suite
%ProgramFiles%\Microsoft VS Code\bin
%ProgramFiles%\7-Zip
%ProgramFiles%\Java\bin
%ProgramFiles%\Gradle\bin
%ProgramFiles%\CMake\bin
%ProgramFiles%\Git\cmd
%ProgramFiles%\NASM
%ProgramFiles%\Ninja
C:\Workspace\android\emulator
C:\Workspace\android\flutter\bin
C:\Workspace\android\build-tools\28.0.3
C:\Workspace\android\platform-tools
C:\Workspace\android\tools\bin
C:\Workspace\android\tools
C:\Workspace\vcpkg
C:\Python\Scripts
C:\Python
C:\Node
```

Configure the System `ANDROID_SDK_ROOT` environment variable.

```
C:\Workspace\android
```

Configure the System `ANDROID_NDK_ROOT` environment variable.

```
C:\Workspace\android\ndk-bundle
```

Configure the System `VCPKG_DEFAULT_TRIPLET` environment variable.

```
x64-windows
```

## Visual Studio 2017
Install and configure [Visual Studio 2017 Community](https://visualstudio.microsoft.com/downloads/).<br/>

![Workloads](res/vs2017-1.png)

![Individual Components](res/vs2017-2.png)

<!--
### Configuration
```
Tools > Options
Environment
+ General
  Color theme: Dark
+ Documents
  [✓] Detect when file is changed outside the environment
      [✓] Reload modified files unless there are unsaved changes
  [✓] Save documents as Unicode when data cannot be saved in codepage
+ Fonts and Colors
  Text Editor: DejaVu LGC Sans Mono 9
  Printer and Cut/Copy: Iconsolata 10
  [All Text Tool Windows]: DejaVu LGC Sans Mono 9
+ Quick Launch
  [ ] Enable Quick Launch
+ Startup
  At startup: Show empty environment
  [ ] Download content every: 60 minutes
Projects and Solutions
+ General
  [ ] Always show Error list if build finishes with errors
  [ ] Warn user when the project location is not trusted
+ Build and Run
  On Run, when projects are out of date: Always build
  On Run, when build or deployment error occur: Do not launch
Source Control
+ Plug-in Selection
  Current source control plug-in: Git
Text Editor
+ General
  [ ] Enable mouse click to perform Go to Definition
  [ ] Highlight current line
  [ ] Show structure guide lines
+ All Languages
  + General
    [✓] Line numbers
    [ ] Apply Cut or Copy to blank lines when there is no selection
  + Scroll Bars
    (•) Use map mode for vertical scroll bar
        [ ] Show Preview Tooltip
        Source overview: Wide
  + Tabs
    Indenting: Smart
    Tab size: 2
    Indent size: 2
    (•) Indent spaces
+ C/C++
  + Formatting
    + General
      (•) Run ClangFormat only for manually invoked formatting commands
      [✓] Use custom clang-format.exe file: (Latest version from <https://llvm.org/builds/>.)
    + Indentation
      [ ] Indent namespace contents
    + New Lines
      Position of open braces for namespaces: Keep on the same line, but add a space before
      Position of open braces for types: Keep on the same line, but add a space before
      Position of open braces for functions: Move to a new line
      Position of open braces for control blocks: Keep on the same line, but add a space before
      Position of open braces for lambdas: Keep on the same line, but add a space before
      [✓] Place braces on separate lines
      [✓] For empty types, move closing braces to the same line as opening braces
      [✓] For empty function bodies, move closing braces to the same line as opening braces
      [ ] Place 'else' on a new line
      [✓] Place 'catch' and similar keywords on a new line
      [ ] Place 'while' in a do-while loop on a new line
    + Wrapping
      (•) Always apply New Lines settings for blocks
  + View
    + Outlining
      Enable Outlining: False
+ CSS
  + Advanced
    Color picker format: #000
    Automatic formatting: Off
+ JavaScript/TrueScript
  + Formatting
    + General
      [ ] Format completed line on Enter
      [ ] Format completed statement on ;
      [ ] Format opened block on {
      [ ] Format completed block on }
    + Spacing
      [ ] Insert space after function keyword for anonymous functions
+ JSON
  + Advanced
    Automatic formatting: Off
```


## Windows Driver Kit
Install [WDK for Windows 10](https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/).


### Plugins
Install [Trailing Whitespace Visualizer](https://marketplace.visualstudio.com/items?itemName=MadsKristensen.TrailingWhitespaceVisualizer).

Install and configure [Line Endings Unifier](https://marketplace.visualstudio.com/items?itemName=JakubBielawa.LineEndingsUnifier).

```
Tools > Options > Line Endings Unifier
+ General Settings
  Add Newline On The Last Line: True
  Default Line Ending: Linux
  Force Default Line Ending On Document Save: True
  Save Files After Unifying: True
  Supported File Formats: .c; .cc; .cpp; .h; .hh; .hpp; .in; .lua; .js; .json; .html; .md; .sh; .conf; .txt
  Supported File Names: makefile
```

Install [NPL LuaLanguageService](https://marketplace.visualstudio.com/items?itemName=Xizhi.NPLLuaLanguageService).

```
Tools > Options > Environment > Fonts and Colors
+ Display items: NPL.NPLFunction
  Item foreground: R:0 G:215 B:0
  [ ] bold
+ Display items: NPL.NPLSelf
  Item foreground: R:0 G:204 B:204
  [ ] bold
```
-->

## Visual Studio Code
**NOTE**: Press `CTRL+P` and type `>` followed by a command.

Configure editor with the command `Preferences: Open Settings (JSON)`

```json
{
  "editor.cursorSmoothCaretAnimation": true,
  "editor.detectIndentation": false,
  "editor.dragAndDrop": false,
  "editor.folding": false,
  "editor.fontFamily": "'Fira Code', 'DejaVu Sans Mono', Consolas, 'Courier New', monospace",
  "editor.fontLigatures": true,
  "editor.fontSize": 12,
  "editor.largeFileOptimizations": false,
  "editor.renderLineHighlight": "none",
  "editor.rulers": [ 120 ],
  "editor.tabSize": 2,
  "editor.wordWrap": "on",
  "editor.wordWrapColumn": 120,
  "explorer.confirmDelete": false,
  "extensions.ignoreRecommendations": false,
  "files.eol": "\n",
  "files.insertFinalNewline": true,
  "files.trimTrailingWhitespace": true,
  "git.autoRepositoryDetection": false,
  "git.confirmSync": false,
  "git.enableSmartCommit": true,
  "git.postCommitCommand": "push",
  "telemetry.enableCrashReporter": false,
  "telemetry.enableTelemetry": false,
  "terminal.integrated.shell.windows": "C:\\Windows\\System32\\cmd.exe",
  "window.openFoldersInNewWindow": "on",
  "window.openFilesInNewWindow": "on",
  "workbench.startupEditor": "newUntitledFile",
  "cmake.buildDirectory": "${workspaceRoot}/build/msvc/${buildType}",
  "cmake.configureOnOpen": true,
  "cmake.configureSettings": {
    "CMAKE_EXPORT_COMPILE_COMMANDS": "ON",
    "CMAKE_TOOLCHAIN_FILE": "C:/Workspace/vcpkg/scripts/buildsystems/vcpkg.cmake",
    "VCPKG_CHAINLOAD_TOOLCHAIN_FILE": "C:/Workspace/vcpkg/scripts/toolchains/windows.cmake",
    "VCPKG_TARGET_TRIPLET": "x64-windows"
  },
  "cmake.generator": "Ninja",
  "cmake.installPrefix": "${workspaceRoot}",
  "clang-format.executable": "C:\\Program Files (x86)\\clang-format.exe",
  "dart.lineLength": 120
}
```

Install extensions witht he command `Extensions: Install Extensions`.

* C/C++ (Microsoft)
* CMake (twxs)
* CMake Tools (vector-of-bool)
* Clang-Format (xaver)
* Flutter (Dart Code)
* Git History (Don Jayamanne)
* hexdump for VSCode (slevesque)
* Java Extension Pack (Microsoft)
* Markdown All in One (Yu Zhang)
* XML Tools (Josh Johnson)


## Android
Extract the [Android SDK Tools](https://developer.android.com/studio/#command-tools) to `C:\Workspace\android\tools`.

Install Android SDK, Build Tools, NDK, USB driver and `adb`.

```cmd
sdkmanager --update
sdkmanager --licenses
sdkmanager "platforms;android-28" "build-tools;28.0.3" "ndk-bundle" "extras;google;usb_driver" "platform-tools"
```

Register the SDK as Administrator.

```cmd
reg add "HKLM\SOFTWARE\Wow6432Node\Android SDK Tools" /v "Path" /t REG_SZ /d "C:\Workspace\android" /f
reg add "HKLM\SOFTWARE\Wow6432Node\Android SDK Tools" /v "StartMenuGroup" /t REG_SZ /d "Android SDK Tools" /f
```

<!--
Install and configure emulator.

```cmd
sdkmanager "emulator" "system-images;android-28;google_apis;x86_64"
echo WindowsHypervisorPlatform=on>> %UserProfile%\.android\advancedFeatures.ini
```

Create and configure virtual device.

```cmd
avdmanager create avd -n Phone -d "Nexus 4" -k "system-images;android-28;google_apis;x86_64"
echo hw.lcd.density=160>> %UserProfile%\.android\avd\Phone.avd\config.ini
echo hw.lcd.height=640>>  %UserProfile%\.android\avd\Phone.avd\config.ini
echo hw.lcd.width=360>>   %UserProfile%\.android\avd\Phone.avd\config.ini
echo hw.keyboard=yes>>    %UserProfile%\.android\avd\Phone.avd\config.ini
```

Start virtual device.

```cmd
emulator -avd Phone -no-audio -no-boot-anim -no-jni -skin 360x640
```
-->

Install [flutter](https://flutter.io/docs/get-started/install/windows) into `C:\Workspace\android\flutter`.

```cmd
flutter doctor -v
```

<!--
Install [flutter-desktop-embedding](https://github.com/google/flutter-desktop-embedding).

```cmd
git clone https://github.com/google/flutter-desktop-embedding C:\Workspace\android\flutter-desktop-embedding
```

Build `C:\Workspace\android\flutter-desktop-embedding\library\windows\Flutter Windows Embedder.sln`:

- with the `Debug Dynamic Library` config
- with the `Release Dynamic Library` config

-->


## Vcpkg
Install Vcpkg.

```cmd
git clone https://github.com/Microsoft/vcpkg C:\Workspace\vcpkg
bootstrap-vcpkg -disableMetrics && vcpkg integrate install
```

<!--
Replace OpenSSL port.

```cmd
rd /q /s C:\Workspace\vcpkg\ports\openssl
git clone https://github.com/qis/openssl C:\Workspace\vcpkg\ports\openssl
```
-->

Replace Vcpkg toolchain files.

```cmd
rd /q /s C:\Workspace\vcpkg\scripts\toolchains
git clone https://github.com/qis/toolchains C:\Workspace\vcpkg\scripts\toolchains
copy /Y C:\Workspace\vcpkg\scripts\toolchains\triplets\*.* C:\Workspace\vcpkg\triplets\
```

Install Vcpkg ports.

```cmd
vcpkg install benchmark gtest ^
  bzip2 date fmt liblzma libzip mio nlohmann-json openssl pugixml zlib ^
  angle freetype giflib harfbuzz libjpeg-turbo libpng opus
```

<!--
Install Vcpkg ports on Android.

```cmd
set VCPKG_DEFAULT_TRIPLET=arm64-android
vcpkg install benchmark gtest ^
  bzip2 date fmt liblzma libzip mio nlohmann-json openssl pugixml zlib ^
  freetype giflib harfbuzz libjpeg-turbo libpng opus
```
-->

<!--
Install LLVM.

```cmd
git clone -b release_70 --depth 1 https://llvm.org/git/llvm src
git clone -b release_70 --depth 1 https://llvm.org/git/clang src\tools\clang
git clone -b release_70 --depth 1 https://llvm.org/git/clang-tools-extra src\tools\clang\tools\extra
git clone -b release_70 --depth 1 https://llvm.org/git/lld src\tools\lld
md build\host
pushd build\host
cmake -G "Visual Studio 15 2017 Win64" -Thost=x64 -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_INSTALL_PREFIX=C:/LLVM ^
  -DLLVM_TARGETS_TO_BUILD="X86;WebAssembly" ^
  -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="WebAssembly" ^
  -DLLVM_ENABLE_ASSERTIONS=OFF ^
  -DLLVM_ENABLE_WARNINGS=OFF ^
  -DLLVM_ENABLE_PEDANTIC=OFF ^
  -DLLVM_INCLUDE_EXAMPLES=OFF ^
  -DLLVM_INCLUDE_TESTS=OFF ^
  -DLLVM_INCLUDE_DOCS=OFF ^
  ..\..\src
cmake --build . --target install
popd
git clone -b wasm-prototype-1 --depth 1 https://github.com/jfbastien/musl src\musl
git clone -b release_70 --depth 1 https://llvm.org/git/compiler-rt src\projects\compiler-rt
git clone -b release_70 --depth 1 https://llvm.org/git/libcxxabi src\projects\libcxxabi
git clone -b release_70 --depth 1 https://llvm.org/git/libcxx src\projects\libcxx
md build\musl
pushd build\musl

```

```sh
rm -rf /opt/llvm; mkdir /opt/llvm; cd /opt/llvm
git clone -b release_70 --depth 1 https://llvm.org/git/llvm src && \
git clone -b release_70 --depth 1 https://llvm.org/git/lld src/tools/lld && \
git clone -b release_70 --depth 1 https://llvm.org/git/clang src/tools/clang && \
git clone -b release_70 --depth 1 https://llvm.org/git/clang-tools-extra src/tools/clang/tools/extra && \
git clone -b release_70 --depth 1 https://llvm.org/git/compiler-rt src/projects/compiler-rt && \
git clone -b release_70 --depth 1 https://llvm.org/git/libcxxabi src/projects/libcxxabi && \
git clone -b release_70 --depth 1 https://llvm.org/git/libcxx src/projects/libcxx && \
git clone -b release_70 --depth 1 https://llvm.org/git/libunwind src/runtimes/libunwind && \
git clone -b wasm-prototype-1 --depth 1 https://github.com/jfbastien/musl src/musl
sed -i "s/\s\smain()//" src/projects/libcxx/utils/merge_archives.py
mkdir -p build/host; pushd build/host
cmake -GNinja -DCMAKE_BUILD_TYPE=Release \
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
  -DLIBCXXABI_ENABLE_SHARED=OFF \
  -DLIBCXXABI_ENABLE_STATIC=ON \
  -DLIBCXXABI_USE_LLVM_UNWINDER=ON \
  -DLIBCXX_ENABLE_ASSERTIONS=OFF \
  -DLIBCXX_ENABLE_EXCEPTIONS=ON \
  -DLIBCXX_ENABLE_SHARED=OFF \
  -DLIBCXX_ENABLE_STATIC=ON \
  -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON \
  -DLIBCXX_ENABLE_ASSERTIONS=OFF \
  -DLIBCXX_ENABLE_FILESYSTEM=ON \
  -DLIBCXX_ENABLE_EXPERIMENTAL_LIBRARY=ON \
  -DLIBCXX_INSTALL_EXPERIMENTAL_LIBRARY=ON \
  -DLIBCXX_INCLUDE_BENCHMARKS=OFF \
  ../../src
cmake --build . --target install -- -j4
popd

wget -O /opt/llvm/bin/wasm https://raw.githubusercontent.com/qis/llvm/master/wasm.sh
chmod 0755 /opt/llvm/bin/wasm

pushd /opt/llvm/bin
for i in cc c++ clang clang++; do \
  echo "/opt/llvm/bin/wasm-$i -> wasm"; \
  rm -f wasm-$i; ln -s wasm wasm-$i; \
done
popd

pushd /opt/llvm/bin
for i in ar as nm objcopy objdump ranlib readelf readobj size strings; do \
  echo "/opt/llvm/bin/wasm-$i -> llvm-$i"; \
  rm -f wasm-$i; ln -s llvm-$i wasm-$i; \
done
popd

mkdir -p build/musl; pushd build/musl
CC=/opt/llvm/bin/clang CROSS_COMPILE=/opt/llvm/bin/wasm- CFLAGS=-Wno-everything \
../../src/musl/configure --prefix=/opt/llvm/wasm --disable-shared --enable-optimize=size
make all install -j4
popd
```
-->

## Windows Subsystem for Linux
Take ownership of `/opt`.

```sh
USER=`id -un` GROUP=`id -gn` sudo chown $USER:$GROUP /opt
```

Create a symlink to the host Vcpkg installation.

```sh
ln -s /mnt/c/Workspace/vcpkg /opt/vcpkg
```

Configure environment variables in `~/.bashrc`.

```sh
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"
export PATH="/opt/cmake/bin:/opt/llvm/bin:/opt/node/bin:/opt/vcpkg:${PATH}"
export NODE_PATH="/opt/node/lib/node_modules"
```

Install development packages.

```sh
sudo apt install build-essential binutils-dev gdb libedit-dev nasm python python-pip git subversion swig
```

Install LLVM.

```sh
rm -rf /opt/llvm; mkdir /opt/llvm
wget https://releases.llvm.org/7.0.0/clang+llvm-7.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz
tar xvf clang+llvm-7.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz -C /opt/llvm --strip-components 1
sudo tee /etc/ld.so.conf.d/llvm.conf <<EOF
/opt/llvm/lib
/opt/llvm/lib/clang/7.0.0/lib/linux
EOF
sudo ldconfig
sudo update-alternatives --install /usr/bin/cc cc /opt/llvm/bin/clang 100
sudo update-alternatives --install /usr/bin/c++ c++ /opt/llvm/bin/clang++ 100
```

Install CMake and Ninja.

```sh
rm -rf /opt/cmake; mkdir /opt/cmake
wget https://cmake.org/files/v3.13/cmake-3.13.2-Linux-x86_64.tar.gz
tar xvf cmake-3.13.2-Linux-x86_64.tar.gz -C /opt/cmake --strip-components 1
git clone -b release https://github.com/ninja-build/ninja
sh -c "cd ninja && ./configure.py --bootstrap && cp ninja /opt/cmake/bin/"
```

Install NodeJS.

```sh
rm -rf /opt/node; mkdir /opt/node
wget https://nodejs.org/dist/v10.14.2/node-v10.14.2-linux-x64.tar.xz
tar xvf node-v10.14.2-linux-x64.tar.xz -C /opt/node --strip-components 1
find /opt/node -type d -exec chmod 0755 '{}' ';'
```

Install Vcpkg.

```sh
bootstrap-vcpkg.sh -disableMetrics -useSystemBinaries
rm -rf /opt/vcpkg/toolsrc/build.rel
sed s/dynamic/static/g /opt/vcpkg/triplets/x64-linux.cmake > /opt/vcpkg/triplets/x64-linux-static.cmake
```

Install Vcpkg packages.

```sh
vcpkg install benchmark gtest \
  bzip2 date fmt liblzma libzip mio nlohmann-json openssl pugixml zlib
```
