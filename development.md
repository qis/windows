# Development
Installation and configuration of a Windows 10 development workstation.


## Tools
Install various tools for development.

* [CMake](https://cmake.org)

```
Install Options
  ◉ Do not add CMake to the system PATH
  ☐ Create CMake Desktop Icon
Destination Folder
  C:\Program Files\CMake
```

* [Node LTS](https://nodejs.org)

```
Destination Folder
  C:\Node
Custom Setup
  ☑ Node.js runtime
  ☑ npm package manager
  ☒ Online documentation shortcuts
  ☒ Add to PATH
```

* [Python 2](https://www.python.org/downloads/)

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

* [Visual Studio Code](https://code.visualstudio.com/download) (System Installer)

```
Select Additional Tasks
  ☐ Create a desktop icon
  ☑ Add "Open with Code" action to Windows Explorer file context menu
  ☑ Add "Open with Code" action to Windows Explorer directory context menu
  ☑ Register Code as an editor for supported file types
  ☐ Add to PATH (available after restart)
```

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
%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Community\VC\Tools\MSVC\14.16.27023\bin\Hostx64\x64
%ProgramFiles(x86)%\Windows Kits\8.1\bin\x86
%ProgramFiles(x86)%\Sysinternals Suite
%ProgramFiles%\7-Zip
%ProgramFiles%\CMake\bin
%ProgramFiles%\Git\cmd
%ProgramFiles%\Gradle\bin
%ProgramFiles%\Microsoft VS Code\bin
%ProgramFiles%\NASM
%ProgramFiles%\Ninja
C:\Android\flutter\bin
C:\Android\sdk\build-tools\28.0.3
C:\Android\sdk\platform-tools
C:\Android\studio\gradle\gradle-4.10.1\bin
C:\Android\studio\jre\bin
C:\Node
C:\Python
C:\Python\Scripts
C:\Workspace\vcpkg
```

Configure the System `ANDROID_HOME` environment variable.

```
C:\Android\sdk
```

Configure the System `ANDROID_NDK_ROOT` environment variable.

```
C:\Android\sdk\ndk-bundle
```

Configure the System `ANDROID_SDK_ROOT` environment variable.

```
C:\Android\sdk
```

Configure the System `JAVA_HOME` environment variable.

```
C:\Android\studio\jre
```

Configure the System `VCPKG_DEFAULT_TRIPLET` environment variable.

```
x64-windows
```

## Visual Studio 2017
Install and configure [Visual Studio 2017 Community](https://visualstudio.microsoft.com/downloads/).<br/>

![Workloads](res/vs2017-1.png)

![Individual Components](res/vs2017-2.png)

Configure the IDE.

```
Tools > Options
Environment
+ General
  Color theme: Dark
+ Documents
  ☑ Detect when file is changed outside the environment
    ☑ Reload modified files unless there are unsaved changes
  ☑ Save documents as Unicode when data cannot be saved in codepage
+ Fonts and Colors
  Text Editor: DejaVu LGC Sans Mono 9
  Printer and Cut/Copy: Iconsolata 10
  [All Text Tool Windows]: DejaVu LGC Sans Mono 9
+ Quick Launch
  ☐ Enable Quick Launch
+ Startup
  At startup: Show empty environment
  ☐ Download content every: 60 minutes
Projects and Solutions
+ General
  ☐ Always show Error list if build finishes with errors
  ☐ Warn user when the project location is not trusted
+ Build and Run
  On Run, when projects are out of date: Always build
  On Run, when build or deployment error occur: Do not launch
Source Control
+ Plug-in Selection
  Current source control plug-in: Git
Text Editor
+ General
  ☐ Enable mouse click to perform Go to Definition
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
+ C/C++
  + Formatting
    + General
      ◉ Run ClangFormat only for manually invoked formatting commands
      ☑ Use custom clang-format.exe file: (Latest version from <https://llvm.org/builds/>.)
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
```


### Windows Driver Kit
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
  ☐ bold
+ Display items: NPL.NPLSelf
  Item foreground: R:0 G:204 B:204
  ☐ bold
```


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
  "cmake.generator": "Ninja",
  "cmake.installPrefix": "${workspaceRoot}",
  "cmake.buildDirectory": "${workspaceRoot}/build/code/${buildType}",
  "cmake.configureOnOpen": true,
  "cmake.configureSettings": {
    "CMAKE_TOOLCHAIN_FILE": "C:/Workspace/vcpkg/scripts/buildsystems/vcpkg.cmake",
    "VCPKG_CHAINLOAD_TOOLCHAIN_FILE": "C:/Workspace/vcpkg/scripts/toolchains/windows.cmake",
    "VCPKG_TARGET_TRIPLET": "x64-windows",
    "CMAKE_INSTALL_PREFIX": "${workspaceRoot}"
  },
  "clang-format.executable": "C:\\Program Files (x86)\\clang-format.exe"
}
```

Install extensions with the following commands with `CTRL+P`.

```
ext install donjayamanne.githistory
ext install dotjoshjohnson.xml
ext install ms-vscode.cpptools
ext install maddouri.cmake-tools-helper
ext install xaver.clang-format
> Reload Window
```


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
flutter doctor --android-licenses
```


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

## Vcpkg
Install Vcpkg using [this](vcpkg.md) guide.
