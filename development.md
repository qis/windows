# Development
Installation and configuration of a Windows 10 development workstation.

## Tools
Install various tools for development.

* [Node LTS](https://nodejs.org/dist/v10.15.0/node-v10.15.0-x64.msi)

```
Destination Folder
  C:\Node
Custom Setup
  ☑ Node.js runtime
  ☑ npm package manager
  ☒ Online documentation shortcuts
  ☒ Add to PATH
```

* [Python 2](https://www.python.org/ftp/python/2.7.16/python-2.7.16.amd64.msi)

```
Select where to install Python
  ◉ Install for all users
Select Destination Directory
  C:\Python
Customize Python
  ▣ Python
    ☑ Register Extensions
    ☑ Tcl/Tk
    ☒ Documentation
    ☑ Utility Scripts
    ☑ pip
    ☑ Test suite
    ☒ Add python.exe to Path
  [Advanced]
    ☑ Compile .py files to byte code after installation
```

<!--
* [Visual Studio Code](https://code.visualstudio.com/download) (System Installer)

```
Select Additional Tasks
  ☐ Create a desktop icon
  ☑ Add "Open with Code" action to Windows Explorer file context menu
  ☑ Add "Open with Code" action to Windows Explorer directory context menu
  ☑ Register Code as an editor for supported file types
  ☐ Add to PATH (available after restart)
```
-->

* [CFF Explorer](http://www.ntcore.com/exsuite.php)
* [Sysinternals Suite](https://technet.microsoft.com/en-us/sysinternals/bb842062.aspx)
* [CMake](https://cmake.org/files/v3.14/cmake-3.14.0-win64-x64.zip) into `%ProgramFiles%\CMake`
* [Ninja](https://github.com/ninja-build/ninja/releases/download/v1.9.0/ninja-win.zip) as `%ProgramFiles%\CMake\bin\ninja.exe`
* [Make](http://www.equation.com/servlet/equation.cmd?fa=make) as `%ProgramFiles%\GNU\make.exe`
* [NASM](https://www.nasm.us/pub/nasm/releasebuilds/2.14/win64/nasm-2.14-win64.zip) into `%ProgramFiles%\NASM`
* [x64dbg](https://x64dbg.com) into `%ProgramFiles%\x64dbg`

Install the latest standalone version of [Clang-Format](https://llvm.org/builds/) as `%ProgramFiles(x86)%\clang-format.exe`.

## Environment Variables
Configure the User `Path` environment variable.

```
%UserProfile%\AppData\Local\Microsoft\WindowsApps
%UserProfile%\AppData\Roaming\npm
```

Configure the user `NODE_PATH` environment variable.

```
%AppData%\npm\node_modules
```

Configure the System `Path` environment variable.

```
%SystemRoot%\System32
%SystemRoot%
%SystemRoot%\System32\Wbem
%SystemRoot%\System32\WindowsPowerShell\v1.0
%SystemRoot%\System32\OpenSSH
%ProgramFiles(x86)%\Sysinternals Suite
%ProgramFiles%\7-Zip
%ProgramFiles%\CMake\bin
%ProgramFiles%\Git\cmd
%ProgramFiles%\NASM
C:\Node
C:\Python
C:\Python\Scripts
C:\Workspace\vcpkg
```

Configure the System `VCPKG_DEFAULT_TRIPLET` environment variable.

```
x64-windows
```

## Visual Studio 2019
Install [Visual Studio 2019](https://visualstudio.microsoft.com/downloads/).

```
Workloads
+ ☑ Desktop development with C++

Individual components
+ Compilers, build tools, and runtimes
  ☑ MSVC v142 - VS 2019 C++ x64/x86 Spectre-mitigated libs (v14.20)
+ Debuggong and testing
  ☐ Test Adapter for Boost.Test
+ Development Activities
  ☐ Live Share
+ SDKs, libraries, and frameworks
  ☐ C++ ATL for v142 build tools (x86 & x64)
  ☐ Windows 10 SDK (10.0.17763.0)
  ☑ Windows 10 SDK (10.0.18362.0)
```

### Development Kits
* [WDK for Windows 10](https://docs.microsoft.com/en-us/windows-hardware/drivers/download-the-wdk).

### Plugins
* [Fix File Encoding](https://marketplace.visualstudio.com/items?itemName=SergeyVlasov.FixFileEncoding)
* [Trailing Whitespace Visualizer](https://marketplace.visualstudio.com/items?itemName=MadsKristensen.TrailingWhitespaceVisualizer)

### Options
```
Environment
+ General
  Color theme: Dark
+ Documents
  ☑ Save documents as Unicode when data cannot be saved in codepage
+ Fonts and Colors
  Text Editor: DejaVu LGC Sans Mono 9
  Printer and Cut/Copy: Iconsolata 10
  [All Text Tool Windows]: DejaVu LGC Sans Mono 9
+ Startup
  On startup, open: Empty environment

Projects and Solutions
+ General
  ☐ Warn user when the project location is not trusted
+ Build and Run
  On Run, when build or deployment error occur: Do not launch

Source Control
+ Plug-in Selection
  Current source control plug-in: Git

Text Editor
+ General
  ☐ Enable mouse click to perform Go to Definition
    Use modifier key: Ctrl+Alt
  ☐ Highlight current line
  ☐ Show structure guide lines
+ All Languages
  + General
    ☑ Line numbers
    ☐ Apply Cut or Copy to blank lines when there is no selection
  + Scroll Bars
    ◉ Use map mode for vertical scroll bar
      ☐ Show Preview Tooltip
      Source overview: Wide
  + Tabs
    Indenting: Smart
    Tab size: 2
    Indent size: 2
    ◉ Indent spaces
  + CodeLens
    ☐ Enable CodeLens
+ C/C++
  + Advanced
    Disable External Dependencies Folders: True
  + Formatting
    + General
      ◉ Run ClangFormat only for manually invoked formatting commands
      ☑ Use custom clang-format.exe file: C:\Program Files (x86)\clang-format.exe
    + Indentation
      ☐ Indent namespace contents
    + New Lines
      Position of open braces for namespaces: Keep on the same line, but add a space before
      Position of open braces for types: Keep on the same line, but add a space before
      Position of open braces for functions: Move to a new line
      Position of open braces for control blocks: Keep on the same line, but add a space before
      Position of open braces for lambdas: Keep on the same line, but add a space before
      ☑ Place braces on separate lines
      ☑ For empty types, move closing braces to the same line as opening braces
      ☑ For empty function bodies, move closing braces to the same line as opening braces
      ☐ Place 'else' on a new line
      ☑ Place 'catch' and similar keywords on a new line
      ☐ Place 'while' in a do-while loop on a new line
    + Wrapping
      ◉ Always apply New Lines settings for blocks
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
      ☐ Format completed line on Enter
      ☐ Format completed statement on ;
      ☐ Format opened block on {
      ☐ Format completed block on }
    + Spacing
      ☐ Insert space after function keyword for anonymous functions
+ JSON
  + Advanced
    Automatic formatting: Off

Fix File Encoding
+ General
  UTF-8 without signature files regex: \.(c|cc|cpp|cxx|h|hh|hpp|hxx|ipp|ihh|rc|manifest|in|lua|sh|conf|json|js|py|htm|html|css|txt|md)$
```

## ScyllaHide
Install the [ScyllaHide](https://github.com/x64dbg/ScyllaHide) plugin.

```cmd
git clone git@github.com:x64dbg/ScyllaHide
start ScyllaHide\ScyllaHide.sln
```

1. Replace `afxres` with `windows` and `IDC_STATIC` with `-1` in `ScyllaHideX64DBGPlugin\ScyllaHideX64DBGPlugin.rc`.
2. Switch the platform to `Win32` and change the platform toolset for all projects to `Visual Studio 2019 (v142)`.
3. Switch the platform to `x64` and change the platform toolset for all projects to `Visual Studio 2019 (v142)`.
4. Build the `HookLibrary` and `ScyllaHideX64DBGPlugin` projects for `Win32` in `Release` mode.
5. Build the `HookLibrary` and `ScyllaHideX64DBGPlugin` projects for `x64` in `Release` mode.

```cmd
cmake -E make_directory "%ProgramFiles%\x64dbg\release\x32\plugins"
cmake -E copy ^
  ScyllaHide\ConfigCollection\scylla_hide.ini ^
  ScyllaHide\ConfigCollection\NtApiCollection.ini ^
  ScyllaHide\build\Release\Win32\HookLibraryx86.dll ^
  ScyllaHide\build\Release\Win32\ScyllaHideX64DBGPlugin.dp32 ^
  "%ProgramFiles%\x64dbg\release\x32\plugins"
  
cmake -E make_directory "%ProgramFiles%\x64dbg\release\x64\plugins"
cmake -E copy ^
  ScyllaHide\ConfigCollection\scylla_hide.ini ^
  ScyllaHide\ConfigCollection\NtApiCollection.ini ^
  ScyllaHide\build\Release\x64\HookLibraryx64.dll ^
  ScyllaHide\build\Release\x64\ScyllaHideX64DBGPlugin.dp64 ^
  "%ProgramFiles%\x64dbg\release\x64\plugins"
```

<!--
## Visual Studio Code
**NOTE**: Press `CTRL+P` and type `>` followed by a command.

Configure editor with the command `Preferences: Open Settings (JSON)`

```json
{
  "editor.cursorSmoothCaretAnimation": true,
  "editor.detectIndentation": false,
  "editor.dragAndDrop": false,
  "editor.folding": false,
  "editor.fontFamily": "'Fira Code', 'DejaVu Sans Mono', Consolas, monospace",
  "editor.fontLigatures": true,
  "editor.fontSize": 12,
  "editor.largeFileOptimizations": false,
  "editor.multiCursorModifier": "ctrlCmd",
  "editor.renderLineHighlight": "none",
  "editor.rulers": [ 120 ],
  "editor.smoothScrolling": true,
  "editor.tabSize": 2,
  "editor.wordWrap": "on",
  "editor.wordWrapColumn": 120,
  "explorer.confirmDelete": false,
  "explorer.confirmDragAndDrop": false,
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
  "terminal.integrated.shell.windows": "C:\\Windows\\System32\\bash.exe",
  "window.newWindowDimensions": "maximized",
  "window.openFoldersInNewWindow": "on",
  "window.openFilesInNewWindow": "on",
  "window.restoreWindows": "none",
  "window.zoomLevel": 0,
  "workbench.startupEditor": "newUntitledFile",
  "debug.internalConsoleOptions": "openOnSessionStart",
  "debug.openExplorerOnEnd": true,
  "debug.openDebug": "openOnDebugBreak",
  "clang-format.executable": "C:\\Program Files (x86)\\clang-format.exe",
  "cmake.generator": "Ninja",
  "cmake.configureOnOpen": true,
  "cmake.installPrefix": "${workspaceRoot}",
  "cmake.buildDirectory": "${workspaceRoot}/build/code/${buildType}",
  "cmake.configureSettings": {
    "CMAKE_VERBOSE_MAKEFILE": "OFF",
    "CMAKE_INSTALL_PREFIX": "${workspaceRoot}",
    "CMAKE_TOOLCHAIN_FILE": "C:/Workspace/vcpkg/scripts/buildsystems/vcpkg.cmake",
    "VCPKG_CHAINLOAD_TOOLCHAIN_FILE": "C:/Workspace/vcpkg/scripts/toolchains/windows.cmake",
    "VCPKG_TARGET_TRIPLET": "x64-windows"
  },
  "C_Cpp.default.configurationProvider": "vector-of-bool.cmake-tools"
}
```

Install extensions with the following commands with `CTRL+P`.

```
ext install xaver.clang-format
ext install maddouri.cmake-tools-helper
ext install donjayamanne.githistory
ext install rreverser.ragel
ext install dotjoshjohnson.xml
> Developer: Reload Window
```
-->

<!--
## Android Development
Extract [Android Studio](https://developer.android.com/studio) (No .exe installer) into `C:\Android\sdk`.<br/>
Extract [Flutter](https://flutter.io/docs/get-started/install/windows) into `C:\Android\flutter`.

Start and configure Android Studio.

```
Install Type
  ◉ Custom
SDK Components Setup
  ☐ Performance (Intel® HAXM)
  ☐ Android Virtual Device
  Android SDK Location: C:\Android\sdk
```

Install missing plugins and SDKs for flutter development.

```
File > Settings...
+ Appearance & Behavior
  + System Settings
    + Android SDK
      SDK Platforms
        ☑ Android 9.0 (Pie)
        ☑ Android 8.1 (Oreo)
      SDK Tools
        ☐ Android Emulator
        ☑ Google USB Driver
        ☑ NDK
+ Editor
  + Font
    Font: Fira Code
    ☑ Enable font ligatures
  + Code Style
    + Java, C/C++, CMake, HTML, JSON, Kotlin, XML, Other File Types
      Tabs and Indents
        Tab size: 2
        Indent: 2
        Continuation indent: 4
    + C/C++
      Tabs and Indents
        Indent in lambdas: 2
        Indent members of plain structures: 2
        Indent members of classes: 2
        Indent visibility keywords in class/structure: 0
        Indent members of namespace: 0
        Preprocessor directive indent: 0
        ☑ Follow code indent
      Spaces
        Other
          ☐ Prevent > > concatenation in template
        In Template Declaration
          ☑ Before '<'
        In Template Instantiation
          ☑ Before '<'
      New File Extensions
        C++
          Source Extension: cpp
          Header Extension: hpp
          File Naming Convention: snake_case
  + File Encodings
    Global Encoding: UTF-8
    Project Encoding: UTF-8
    Default encoding for properties files: UTF-8
    Create UTF-8 files: with NO BOM
  + Layout Editor
    ☑ Prefer XML editor
+ Plugins
  [Browse repositories...]
    Install: Flutter, Flutteri18n
+ Version Control
  + Git
    SSH executable: Native
```

Search for `redo` in the settings and assign `CTRL+Y` as a shortcut.

Verify that flutter is working properly and accept android licenses.

```cmd
flutter doctor -v
flutter doctor -\-android-licenses
```
-->

## Windows Subsystem for Linux
Take ownership of `/opt`.

```sh
USER=`id -un` GROUP=`id -gn` sudo chown $USER:$GROUP /opt
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

Install CMake.

```sh
rm -rf /opt/cmake; mkdir /opt/cmake
wget https://cmake.org/files/v3.14/cmake-3.14.0-Linux-x86_64.tar.gz
tar xf cmake-3.14.0-Linux-x86_64.tar.gz -C /opt/cmake --strip-components 1
```

Install Ninja.

```sh
git clone -b release https://github.com/ninja-build/ninja
sh -c "cd ninja && CC=gcc CXX=g++ ./configure.py --bootstrap && cp ninja /opt/cmake/bin/"
```

Install NodeJS.

```sh
rm -rf /opt/node; mkdir /opt/node
wget https://nodejs.org/dist/v10.15.0/node-v10.15.0-linux-x64.tar.xz
tar xf node-v10.15.0-linux-x64.tar.xz -C /opt/node --strip-components 1
```

## Vcpkg
Install Vcpkg using the [toolchains](https://github.com/qis/toolchains) guide.
