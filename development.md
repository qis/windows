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

* [CMake](https://cmake.org/download/) into `C:\Program Files\CMake`
* [Ninja](https://github.com/ninja-build/ninja/releases/download/v1.10.0/ninja-win.zip) into `C:\Program Files\Ninja`
* [NASM](https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/win64/nasm-2.14.02-win64.zip) into `C:\Program Files\Nasm`
* [Perl](http://strawberryperl.com/download/5.30.1.1/strawberry-perl-5.30.1.1-64bit-portable.zip) into `C:\Perl`

Install [Python 3](https://www.python.org/ftp/python/3.8.1/python-3.8.1-amd64.exe).

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

Install [Node LTS](https://nodejs.org/dist/v12.14.1/node-v12.14.1-x64.msi).

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

## Development Kits
Install [Vulkan SDK](https://vulkan.lunarg.com/sdk/home#windows) into `C:\Vulkan`.

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
C:\Program Files\Microsoft VS Code\bin
C:\Program Files\7-Zip
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
x64-windows-static
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
      Disable Automatic Precompiled Header: True
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
  ☑ Enable verbose CMake output
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
ext install alefragnani.rtf
ext install donjayamanne.githistory
ext install jamesbirtles.svelte-vscode
ext install ms-vscode.cpptools
ext install ms-vscode.cmake-tools
ext install jeff-hykin.better-cpp-syntax
ext install xaver.clang-format
ext install twxs.cmake
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
  "editor.fontLigatures": false,
  "editor.formatOnSave": true,
  "editor.links": false,
  "editor.fontSize": 12,
  "editor.largeFileOptimizations": false,
  "editor.multiCursorModifier": "ctrlCmd",
  "editor.renderLineHighlight": "none",
  "editor.rulers": [
    128
  ],
  "editor.smoothScrolling": true,
  "editor.minimap.scale": 2,
  "editor.tabSize": 2,
  "editor.wordWrap": "on",
  "editor.wordWrapColumn": 128,
  "explorer.confirmDelete": false,
  "explorer.confirmDragAndDrop": false,
  "extensions.ignoreRecommendations": false,
  "files.eol": "\n",
  "files.hotExit": "off",
  "files.insertFinalNewline": true,
  "files.trimTrailingWhitespace": true,
  "git.autofetch": false,
  "git.autoRepositoryDetection": false,
  "git.confirmSync": false,
  "git.enableSmartCommit": true,
  "git.postCommitCommand": "push",
  "git.showPushSuccessNotification": true,
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
  "debug.onTaskErrors": "showErrors",
  "C_Cpp.vcpkg.enabled": false,
  "C_Cpp.default.cStandard": "c11",
  "C_Cpp.default.cppStandard": "c++20",
  "C_Cpp.experimentalFeatures": "Enabled",
  "C_Cpp.default.configurationProvider": "vector-of-bool.cmake-tools",
  "C_Cpp.default.compileCommands": "build\\windows\\debug\\compile_commands.json",
  "C_Cpp.clang_format_path": "C:\\Program Files (x86)\\LLVM\\bin\\clang-format.exe",
  "clang-format.executable": "C:\\Program Files (x86)\\LLVM\\bin\\clang-format.exe",
  "terminal.integrated.shell.windows": "C:\\Windows\\System32\\cmd.exe",
  "cmake.buildDirectory": "${workspaceFolder}/build/windows/debug",
  "cmake.installPrefix": "${workspaceFolder}/build/install",
  "cmake.configureOnOpen": true,
  "cmake.useCMakeServer": false,
  "cmake.generator": "Ninja",
  "cmake.buildTask": true,
  "[c]": {
    "editor.defaultFormatter": "xaver.clang-format"
  },
  "[cpp]": {
    "editor.defaultFormatter": "xaver.clang-format"
  },
  "[java]": {
    "editor.defaultFormatter": "xaver.clang-format"
  },
  "[javascript]": {
    "editor.fontLigatures": "'ss02', 'ss19'",
    "editor.defaultFormatter": "xaver.clang-format"
  }
}
```

Configure keyboard shortcuts with `> Preferences: Open Keyboard Shortcuts (JSON)`.

```json
[
  { "key": "ctrl+f5",       "command": "workbench.action.debug.run" },
  { "key": "f5",            "command": "workbench.action.debug.start", "when": "!inDebugMode" },
  { "key": "f5",            "command": "workbench.action.debug.restart", "when": "inDebugMode" },
  { "key": "f6",            "command": "workbench.action.debug.pause", "when": "debugState == 'running'" },
  { "key": "f6",            "command": "workbench.action.debug.continue", "when": "debugState != 'running'" },
  { "key": "f7",            "command": "workbench.action.tasks.build" }
]
```

Configure CMake Tools kits with `> CMake: Edit User-Local CMake Kits`.

```json
[
  {
    "name": "x64-windows",
    "visualStudio": "4ef6ec03",
    "visualStudioArchitecture": "amd64",
    "toolchainFile": "${env.VCPKG_ROOT}\\scripts\\buildsystems\\vcpkg.cmake",
    "cmakeSettings": {
      "VCPKG_CHAINLOAD_TOOLCHAIN_FILE": "${env.VCPKG_ROOT}\\scripts\\toolchains\\windows.cmake",
      "VCPKG_TARGET_TRIPLET": "x64-windows"
    }
  },
  {
    "name": "x64-windows-static",
    "visualStudio": "4ef6ec03",
    "visualStudioArchitecture": "amd64",
    "toolchainFile": "${env.VCPKG_ROOT}\\scripts\\buildsystems\\vcpkg.cmake",
    "cmakeSettings": {
      "VCPKG_CHAINLOAD_TOOLCHAIN_FILE": "${env.VCPKG_ROOT}\\scripts\\toolchains\\windows.cmake",
      "VCPKG_TARGET_TRIPLET": "x64-windows-static"
    }
  }
]
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

<details>
<summary><b>Android</b></summary>

Extract [Android Studio](https://developer.android.com/studio) (No .exe installer) as `C:\Android\studio`.<br/>

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
C:\Android\tools
C:\Android\tools\bin
C:\Android\studio\jre\bin
C:\Android\build-tools\29.0.2
C:\Android\platform-tools
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
    ☐ Confirm application exit
    + Android SDK
      SDK Tools
        ☑ NDK (Side by side)
        ☐ Android Emulator
        ☑ Google USB Driver
+ Editor
  + General
    + Appearance
      ☐ Show indent guides
      ☐ Show intention bulb
      ☐ Show parameter name hints
      ☐ Show chain call type hints
    + Code Completion
      ☐ Show the parameter info popup in [1000] ms
  + Font
    Font: DejaVu LGC Sans Mono
  + Color Scheme
    + Language Defaults
      > Comments
        > Doc Comment
          - Tag
            ☐ Effects
      > Identifiers
        - Reassigned local variable
          ☐ Effects
        - Reassigned parameter
          ☐ Effects
    + Java
      > Parameters
        - Implicit anonymous class parameter
          ☐ Effects
    + Kotlin
      > Properties and Variables
        - Var (mutable variable, parameter or property)
          ☐ Effects
  + Code Style
    Wrapping and Braces
      Hard wrap at: 128
    + Java, C/C++, CMake, HTML, JSON, Kotlin, XML, Other File Types
      Tabs and Indents
        Tab size: 2
        Indent: 2
        Continuation indent: 2
      Wrapping and Braces
        Hard wrap at: 128
        > 'try' statement
          ☑ 'catch' on new line
          ☑ 'finally' on new line
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
      Wrapping and Braces
        > 'try' statement
          ☑ 'catch' on new line
      New File Extensions
        C++
          Source Extension: cpp
          Header Extension: hpp
          File Naming Convention: snake_case
    + Dart
      Wrapping and Braces
        Hard wrap at: 128
        > 'try' statement
          ☑ 'catch' on new line
    + JSON
      Wrapping and Braces
        Hard wrap at: 128
    + Kotlin
      Wrapping and Braces
        Hard wrap at: 128
        > 'try' statement
          ☑ 'catch' on new line
          ☑ 'finally' on new line
  + File Encodings
    Global Encoding: UTF-8
    Project Encoding: UTF-8
    Default encoding for properties files: UTF-8
    Create UTF-8 files: with NO BOM
  + Layout Editor
    ☑ Prefer XML editor
```

Search in settings for `redo` and assign `CTRL+Y` as a shortcut.

</details>

<details>
<summary><b>Chrome</b></summary>

Start Chrome and Brave browsers with the following command-line flags:

```
--disable-features=OmniboxUIExperimentHideSteadyStateUrlScheme,OmniboxUIExperimentHideSteadyStateUrlTrivialSubdomains
```

</details>

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
sudo apt install -y build-essential gdb nasm ninja-build python python-pip sqlite3 swig
sudo apt install -y binutils-dev libedit-dev libnftnl-dev libmnl-dev
```

Install CMake.

```sh
rm -rf /opt/cmake /opt/cmake-3.16.3; mkdir /opt/cmake-3.16.3
wget https://github.com/Kitware/CMake/releases/download/v3.16.3/cmake-3.16.3-Linux-x86_64.tar.gz
tar xf cmake-3.16.3-Linux-x86_64.tar.gz -C /opt/cmake-3.16.3 --strip-components 1
ln -s cmake-3.16.3 /opt/cmake
```

Install NodeJS.

```sh
rm -rf /opt/node /opt/node-12.14.1; mkdir /opt/node-12.14.1
wget https://nodejs.org/dist/v12.14.1/node-v12.14.1-linux-x64.tar.xz
tar xf node-v12.14.1-linux-x64.tar.xz -C /opt/node-12.14.1 --strip-components 1
ln -s node-12.14.1 /opt/node
```

Reinstall SSH Server.

```sh
sudo apt remove openssh-server
sudo apt install openssh-server
sudo service ssh start
```

Automatically start SSH server.

```
Task Scheduler > Create Task...
+ General
  Name: WSL SSH Server
  Description: Start SSH server in WSL
  Security options: ◉ Run whether user is logged on or not
  ☑ Hidden | Configure for: Windows 10
+ Triggers > New...
  Begin the task: At startup
+ Actions > New...
  Program/script: C:\Windows\System32\wsl.exe
  Add arguments (optional): sudo service ssh start
```

## Vcpkg
Install Vcpkg using the [toolchains](https://github.com/qis/toolchains) guide.
