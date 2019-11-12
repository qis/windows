# Development
Installation and configuration of a Windows 10 development workstation.

Install [Visual Studio](https://visualstudio.microsoft.com/downloads/).

```
Workloads
+ ☑ Desktop development with C++

Individual components
+ Debuggong and testing
  ☑ JavaScript diagnostics
+ Development Activities
  ☐ IntelliCode
  ☑ JavaScript and TypeScript language support
  ☐ Live Share
```

Install [Trailing Whitespace Visualizer](https://marketplace.visualstudio.com/items?itemName=MadsKristensen.TrailingWhitespaceVisualizer).

Install [Visual Studio Code](https://code.visualstudio.com/download).

```
☐ Add "Open with Code" action to Windows Explorer file context menu
☐ Add "Open with Code" action to Windows Explorer directory context menu
☐ Register Code as an editor for supported file types
☐ Add to PATH (requires shell restart)
```

Install development tools.

* [Make](https://github.com/qis/make) into `C:\Program Files\Make`
* [CMake](https://cmake.org/download/) into `C:\Program Files\CMake`
* [Ninja](https://github.com/ninja-build/ninja/releases/download/v1.9.0/ninja-win.zip) into `C:\Program Files\Ninja`
* [NASM](https://www.nasm.us/pub/nasm/releasebuilds/2.14/win64/nasm-2.14-win64.zip) into `C:\Program Files\Nasm`
* [Perl](http://strawberryperl.com/download/5.30.0.1/strawberry-perl-5.30.0.1-64bit-portable.zip) into `C:\Perl`
* [Vulkan SDK](https://vulkan.lunarg.com/sdk/home#windows) into `C:\Vulkan`

Install [Python 3](https://www.python.org/ftp/python/3.8.0/python-3.8.0-amd64.exe).

```
Install Python
  [Customize installation]
Optional Features
  ☐ Documentation
  ☑ pip
  ☐ tcl/tk and IDLE
  ☐ Python test suite
  ☐ py launcher ☐ for all users (requires elevation)
Advanced Options
  ☑ Install for all users
  ☐ Create shortcuts for installed applications
  ☐ Add Python to environment variables
  ☑ Precompile standard library
  ☐ Download debugging symbols
  ☐ Download debug binaries (requires VS 2015 or later)
  Customize install location: C:\Python
```

Install [Node LTS](https://nodejs.org/dist/v12.13.0/node-v12.13.0-x64.msi).

```
Destination Folder
  C:\Node
Custom Setup
  ☑ Node.js runtime
  ☑ npm package manager
  ☒ Online documentation shortcuts
  ☒ Add to PATH
Tools for Native Modules
  ☐ Automatically install necessary tools.
```

## Format
Install [Clang-Format](https://llvm.org/builds/) into `C:\Program Files (x86)\LLVM\bin`.

## Environment Variables
Configure the User `Path` environment variable.

```
%UserProfile%\AppData\Local\Microsoft\WindowsApps
%UserProfile%\AppData\Roaming\npm
```

Configure the User `NODE_PATH` environment variable.

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
C:\Program Files (x86)\Sysinternals Suite
C:\Program Files\Microsoft VS Code\bin
C:\Program Files\7-Zip
C:\Program Files\Make
C:\Program Files\CMake\bin
C:\Program Files\Git\cmd
C:\Program Files\Nasm
C:\Program Files\Ninja
C:\Workspace\vcpkg
C:\Vulkan\Bin
C:\Node
C:\Python
C:\Python\Scripts
C:\Perl\perl\bin
```

Configure the User `VCPKG_ROOT` environment variable.

```
C:\Workspace\vcpkg
```

Configure the User `VCPKG_DEFAULT_TRIPLET` environment variable.

```
x64-windows
```

## Settings
Configure development environments.

<details>
<summary><b>Visual Studio 2019</b></summary>

```
Environment
+ General
  Color theme: Dark
+ Documents
  ☑ Save documents as Unicode when data cannot be saved in codepage
+ Fonts and Colors
  Text Editor: DejaVu LGC Sans Mono 9
  Printer and Cut/Copy: DejaVu LGC Sans Mono 9
  [All Text Tool Windows]: DejaVu LGC Sans Mono 9
+ Keyboard
  Build.BuildSolution: F7 (Global)
+ Startup
  On startup, open: Empty environment

Projects and Solutions
+ General
  ☐ Always show Error List if build finishes with errors
  ☐ Warn user when the project location is not trusted
+ Build and Run
  On Run, when build or deployment error occur: Do not launch

Source Control
+ Plug-in Selection
  Current source control plug-in: Git

Text Editor
+ General
  ☐ Drag and drop text editing
  ☑ Enable mouse click to perform Go to Definition
    Use modifier key: Ctrl+Alt
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
  + CodeLens
    ☐ Enable CodeLens
+ C/C++
  + Advanced
    + Browsing/Navigation
      Disable External Dependencies Folders: True
    + IntelliSense
      Enable Template IntelliSense: False
  + Formatting
    + General
      ◉ Run ClangFormat only for manually invoked formatting commands
      ☑ Use custom clang-format.exe file: C:\Program Files (x86)\LLVM\bin\clang-format.exe
    + Indentation
      ☐ Indent braces of lambdas used as parameters
      ☐ Indent namespace contents
    + New Lines
      Position of open braces for namespaces: Keep on the same line, but add a space before
      Position of open braces for types: Keep on the same line, but add a space before
      Position of open braces for functions: Keep on the same line, but add a space before
      Position of open braces for control blocks: Keep on the same line, but add a space before
      Position of open braces for lambdas: Keep on the same line, but add a space before
      ☑ Place braces on separate lines
      ☑ For empty types, move closing braces to the same line as opening braces
      ☑ For empty function bodies, move closing braces to the same line as opening braces
      ☑ Place 'catch' and similar keywords on a new line
      ☐ Place 'else' on a new line
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
+ JavaScript/TypeScript
  + Formatting
    + General
      Automatic Formatting
      ☐ Format completed line on Enter
      ☐ Format completed statement on ;
      ☐ Format opened block on {
      ☐ Format completed block on }
      Module Quote Preference
      ◉ Double (")
    + Spacing
      ☐ Insert space after function keyword for anonymous functions
+ JSON
  + Advanced
    Automatic formatting: Off

CMake
+ General
  ☑ Show CMake cache notifications
  When cache is out of date:
    ◉ Run configure step automatically only if CMakeSettings.json exists
  ☐ Enable verbose CMake output
  CMakeSettings.json Template Directory
    %UserProfile%\.vs
```

Disable telemetry.

```
Help > Send Feedback > Settings...
+ Would you like to participate in the Visual Studio Experience Improvement Program?
  ◉ No, I would not like to participate
```

Change [toolbars](res/vs-toolbars) to fit the desired workflow.

</details>

<details>
<summary><b>Visual Studio Code</b></summary>

Install extensions with the following commands with `CTRL+P`.

```
ext install ms-vscode-remote.remote-wsl
ext install ms-vscode.cpptools
ext install xaver.clang-format
> Developer: Reload Window
```

Configure editor with `> Preferences: Open Settings (JSON)`.

```json
{
  "editor.cursorSmoothCaretAnimation": true,
  "editor.detectIndentation": false,
  "editor.dragAndDrop": false,
  "editor.folding": false,
  "editor.fontFamily": "'DejaVu LGC Sans Mono', Consolas, monospace",
  "editor.fontLigatures": true,
  "editor.fontSize": 13,
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
  "workbench.startupEditor": "none",
  "window.newWindowDimensions": "maximized",
  "window.openFoldersInNewWindow": "on",
  "window.openFilesInNewWindow": "off",
  "window.restoreWindows": "none",
  "window.closeWhenEmpty": true,
  "window.zoomLevel": 0,
  "debug.internalConsoleOptions": "openOnSessionStart",
  "debug.openExplorerOnEnd": true,
  "debug.openDebug": "openOnDebugBreak",
  "clang-format.executable": "C:\\Program Files (x86)\\LLVM\\bin\\clang-format.exe",
  "[cpp]": {
    "editor.defaultFormatter": "xaver.clang-format"
  },
  "[java]": {
    "editor.defaultFormatter": "xaver.clang-format"
  },
  "[javascript]": {
    "editor.defaultFormatter": "xaver.clang-format"
  }
}
```

Register VS Code in Explorer context menus.

```cmd
set code=C:\Program Files\Microsoft VS Code\Code.exe
set codefile=\"%code%\" \"%1\"
reg add "HKCR\*\shell\code" /ve /d "Edit with Code" /f
reg add "HKCR\*\shell\code" /v Icon /d "%code%,0" /f
reg add "HKCR\*\shell\code\command" /ve /d "%codefile%" /f
set codepath=\"%code%\" .
reg add "HKCU\Software\Classes\Directory\Background\shell\code" /ve /d "Open in Code" /f
reg add "HKCU\Software\Classes\Directory\Background\shell\code" /v Icon /d "%code%,0" /f
reg add "HKCU\Software\Classes\Directory\Background\shell\code\command" /ve /d "%codepath%" /f
```

</details>

<!--
## Android Development
Extract [Android Studio](https://developer.android.com/studio) (No .exe installer) as `C:\Android\studio`.<br/>
Extract [Flutter](https://flutter.io/docs/get-started/install/windows) as `C:\Android\flutter`.

Configure the System `ANDROID_HOME` environment variable.

```
C:\Android
```

Configure the System `JAVA_HOME` environment variable.

```
C:\Android\studio\jre
```

Configure the System `Path` environment variable.

```
C:\Android\build-tools\28.0.3
C:\Android\flutter\bin
C:\Android\platform-tools
C:\Android\tools
C:\Android\tools\bin
C:\Android\studio\jre\bin
```

Start and configure Android Studio (`C:\Android\studio\bin\studio64.exe`).

```
Install Type
  ◉ Custom
SDK Components Setup
  ☐ Performance (Intel® HAXM)
  ☐ Android Virtual Device
  Android SDK Location: C:\Android
  ⚠ Target folder is neither empty nor does it point to an existing SDK installation.
```

Install missing tools, plugins and SDKs.

```
⚙ Configure > Settings...
+ Appearance & Behavior
  + System Settings
    ☐ Reopen last project on startup
    + Android SDK
      SDK Tools
        ☐ Android Emulator
        ☑ Google USB Driver
        ☑ NDK
+ Editor
  + General
    + Appearance
      ☐ Show parameter name hints
      ☐ Show chain call type hints
    + Code Completion
      ☐ Show parameter name hints on completion
  + Font
    Font: DejaVu LGC Sans Mono
  + Code Style
    + Java, C/C++, CMake, HTML, JSON, Kotlin, XML, Other File Types
      Tabs and Indents
        Tab size: 2
        Indent: 2
        Continuation indent: 2
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
    Install: Flutter, Kotlin
+ Version Control
  + Git
    SSH executable: Native
```

Search in settings for `redo` and assign `CTRL+Y` as a shortcut.

Accept android licenses.

```cmd
flutter doctor -\-android-licenses
```
-->

<!--
## Windows Sandbox
Install Windows Sandbox.

```
Start > "Turn Windows features on or off"
☑ Windows Sandbox
```
-->

## Windows Subsystem for Linux
Take ownership of `/opt`.

```sh
USER=`id -un` GROUP=`id -gn` sudo chown $USER:$GROUP /opt
```

Install development packages.

```sh
sudo apt install -y build-essential binutils-dev gdb libedit-dev nasm ninja-build python python-pip subversion swig
```

Install CMake.

```sh
rm -rf /opt/cmake; mkdir /opt/cmake
wget https://github.com/Kitware/CMake/releases/download/v3.16.0-rc3/cmake-3.16.0-rc3-Linux-x86_64.tar.gz
tar xf cmake-3.16.0-rc3-Linux-x86_64.tar.gz -C /opt/cmake --strip-components 1
```

Install NodeJS.

```sh
rm -rf /opt/node; mkdir /opt/node
wget https://nodejs.org/dist/v12.13.0/node-v12.13.0-linux-x64.tar.xz
tar xf node-v12.13.0-linux-x64.tar.xz -C /opt/node --strip-components 1
```

## Vcpkg
Install Vcpkg using the [toolchains](https://github.com/qis/toolchains) guide.
