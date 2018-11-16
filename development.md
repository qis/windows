# Development
Installation and configuration of a Windows 10 development workstation.


## Tools
Install various tools for development. Do not add anything to `Path` during the installation.

* [Git](https://git-scm.com/downloads) into `C:\Program Files\Git`
* [CMake](https://cmake.org) into `C:\Program Files\CMake`
* [Ninja](https://github.com/ninja-build/ninja/releases) into `C:\Program Files\Ninja`
* [NASM](http://www.nasm.us) into `C:\Program Files\NASM`
* [Node LTS](https://nodejs.org) into `C:\Node`
* [Perl 5 (Portable)](http://strawberryperl.com/releases.html) into `C:\Perl`
* [Python 2](https://www.python.org/downloads/) into `C:\Python`
* [VS Code](https://code.visualstudio.com/download) using the System Installer.
* [Java SE Development Kit (JDK) 8](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
* [Gradle](https://gradle.org/releases/) into `C:\Program Files\Gradle`

Install various tools for debugging.

* [HxD](https://mh-nexus.de/en/hxd)
* [CFF Explorer](http://www.ntcore.com/exsuite.php)
* [Resource Hacker](http://www.angusj.com/resourcehacker)
* [Sysinternals Suite](https://technet.microsoft.com/en-us/sysinternals/bb842062.aspx)

Install a standalone version of `clang-format`.

* [Clang Format](https://llvm.org/builds/)


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
%ProgramFiles%\Java\jdk1.8.{version}\bin
%ProgramFiles%\Gradle\bin
%ProgramFiles%\CMake\bin
%ProgramFiles%\Git\cmd
%ProgramFiles%\NASM
%ProgramFiles%\Ninja
C:\Workspace\android\flutter\bin
C:\Workspace\android\build-tools\28.0.3
C:\Workspace\android\platform-tools
C:\Workspace\android\tools\bin
C:\Workspace\android\tools
C:\Workspace\vcpkg
C:\Perl\perl\bin
C:\Python\Scripts
C:\Python
C:\Node
```

Configure the System `ANDROID_HOME` environment variable.

```
C:\Workspace\android
```

Configure the System `ANDROID_NDK_HOME` environment variable.

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


## VS Code
Install [VS Code](https://code.visualstudio.com/docs/?dv=win64) plugins:

* Dart
* Flutter
* Git History
* Language Support for Java(TM) by Red Hat
* XML Tools

Configure VS Code.

```json
{
  "editor.tabSize": 2,
  "editor.wordWrapColumn": 120,
  "editor.fontSize": 12,
  "editor.fontFamily": "'DejaVu Sans Mono', Consolas, 'Courier New', monospace",
  "editor.renderLineHighlight": "none",
  "editor.detectIndentation": false,
  "editor.dragAndDrop": false,
  "editor.folding": false,
  "workbench.startupEditor": "newUntitledFile",
  "explorer.confirmDelete": false,
  "typescript.format.insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces": true,
  "javascript.format.insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces": true,
  "telemetry.enableTelemetry": false
}
```


## Android
Extract the [Android SDK Tools](https://developer.android.com/studio/#downloads) to `C:\Workspace\android\tools`.

Install Android SDK, NDK, USB driver and `adb`.

```cmd
sdkmanager --update
sdkmanager "platform-tools"
sdkmanager "platforms;android-28"
sdkmanager "extras;google;usb_driver"
sdkmanager "build-tools;28.0.3"
sdkmanager "ndk-bundle"
sdkmanager --licenses
```

Verify that `adb` works.

```cmd
adb devices
adb shell pm list users
```

Install [flutter](https://flutter.io/docs/get-started/install/windows) into `C:\Workspace\android\flutter`.

```cmd
flutter doctor
```


## Vcpkg
Install Vcpkg.

```cmd
git clone https://github.com/Microsoft/vcpkg C:\Workspace\vcpkg
C:\Workspace\vcpkg\bootstrap-vcpkg.bat && vcpkg integrate install
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

Add system programs to the triplet file.

```cmake
set(7Z "C:/Program Files/7-Zip/7z.exe" CACHE STRING "")
set(PERL "C:/Perl/perl/bin/perl.exe" CACHE STRING "")
set(PYTHON2 "C:/Python/python.exe" CACHE STRING "")
set(NASM "C:/Program Files/NASM/nasm.exe" CACHE STRING "")
set(NINJA "C:/Program Files/Ninja/ninja.exe" CACHE STRING "")
```

Install Vcpkg ports.

```cmd
vcpkg install benchmark gtest ^
  bzip2 date fmt liblzma libzip mio nlohmann-json openssl pugixml range-v3 zlib ^
  angle freetype giflib harfbuzz libjpeg-turbo libpng opus
```

<!--
Install Vcpkg ports on Android.

```cmd
set VCPKG_DEFAULT_TRIPLET=arm64-android
vcpkg install benchmark gtest ^
  bzip2 date fmt liblzma libzip mio nlohmann-json openssl pugixml range-v3 zlib ^
  freetype giflib harfbuzz libjpeg-turbo libpng opus
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
wget http://releases.llvm.org/7.0.0/clang+llvm-7.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz
tar xvf clang+llvm-7.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz -C /opt/llvm --strip-components 1
sudo tee /etc/ld.so.conf.d/llvm.conf <<EOF
/opt/llvm/lib
/opt/llvm/lib/clang/7.0.0/lib/linux
EOF
sudo ldconfig
```

Install CMake and Ninja.

```sh
rm -rf /opt/cmake; mkdir /opt/cmake
wget https://cmake.org/files/v3.12/cmake-3.12.4-Linux-x86_64.tar.gz
tar xvf cmake-3.12.4-Linux-x86_64.tar.gz -C /opt/cmake --strip-components 1
git clone -b release https://github.com/ninja-build/ninja
cd ninja && ./configure.py --bootstrap && cp ninja /opt/cmake/bin/
```

Install NodeJS.

```sh
rm -rf /opt/node; mkdir /opt/node
wget https://nodejs.org/dist/v10.13.0/node-v10.13.0-linux-x64.tar.xz
tar xvf node-v10.13.0-linux-x64.tar.xz -C /opt/node --strip-components 1
find /opt/node -type d -exec chmod 0755 '{}' ';'
```

Install Vcpkg.

```sh
bootstrap-vcpkg.sh
rm -rf /opt/vcpkg/toolsrc/build.rel
sed s/dynamic/static/g /opt/vcpkg/triplets/x64-linux.cmake > /opt/vcpkg/triplets/x64-linux-static.cmake
```

Install Vcpkg packages.

```sh
vcpkg install benchmark gtest \
  bzip2 date fmt liblzma libzip mio nlohmann-json openssl pugixml range-v3 zlib
```

