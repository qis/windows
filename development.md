# Development
Installation and configuration of a Windows 10 development workstation.

## Symbolic Link Policy
Allow local user to create symbolic links.

```
secpol.msc
+ Security Settings > Local Policies > User Rights Assignment
  Create symbolic links
  + Add User or Group...
    1. Enter own user name.
    2. Click on "Check Names".
    3. Click on "OK".
```

Update group policy.

```cmd
gpupdate /force
```

Reboot the system.

## Git
Install [Git](https://git-scm.com/downloads).

```
Select Components
☐ Windows Explorer integration
☐ Associate .git* configuration files with the default text editor
☐ Associate .sh files to be run with Bash

Choosing the default editor used by Git
Use Visual Studio Code as Git's default editor

Adjusting the name of the initial branch in new repositories
◉ Override the default branch name for new repositories
Specify the name "git init" should use for the initial branch: master

Configuring the line ending conversions
◉ Checkout as-is, commit as-is

Configuring the terminal emulator to use Git Bash
◉ Use Windows' default console window

Choose the default behavior of `git pull`
◉ Rebase

Choose a credential helper
◉ None
```

## Visual Studio
Install [Visual Studio](https://visualstudio.microsoft.com/downloads/).

```
Workloads
☑ Desktop development with C++
☑ Node.js development

Individual components
+ Cloud, database, and server
  ☐ Web Deploy
+ Code tools
  ☐ NuGet package manager
+ Debugging and testing
  ☐ C++ AddressSanitizer (Experimental)
  ☐ Test Adapter for Boost.Test
  ☐ Test Adapter for Google Test
+ Development activities
  ☐ Live Share
```

Add the following directories to the system environment variable `Path`.

```
C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja
C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin
C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Msbuild\Microsoft\VisualStudio\NodeJs
```

Set the system environment variable `VSCMD_SKIP_SENDTELEMETRY` to `1`.

<details>
<summary><b>Configuration</b></summary>

Install extensions.

* [Hide Suggestion And Outlining Margins][hi]
* [Trailing Whitespace Visualizer][ws]

[hi]: https://marketplace.visualstudio.com/items?itemName=MussiKara.HideSuggestionAndOutliningMargins
[ws]: https://marketplace.visualstudio.com/items?itemName=MadsKristensen.TrailingWhitespaceVisualizer

Configure with `Tools > Options...`.

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
  On Run, when projects are out of date: Always build
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
    ☐ Navigation bar
    ☑ Automatic brace completion
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
  + Code Style
    + General
      Generated documentation comments style: Doxygen (///)
    + Formatting
      + General
        ◉ Run ClangFormat only for manually invoked formatting commands
        ☑ Use custom clang-format.exe file: C:\Program Files\LLVM\bin\clang-format.exe
      + Indentation
        ☐ Indent braces of lambdas used as parameters
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
        ☑ Place 'catch' and similar keywords on a new line
        ☐ Place 'else' on a new line
        ☐ Place 'while' in a do-while loop on a new line
      + Wrapping
        ◉ Always apply New Lines settings for blocks
  + View
    + Code Squiggles
      Macros in Skipped Browsing Regions: None
      Macros Convertible to constexpr: None
    + Outlining
      Enable Outlining: False
+ CSS
  + Advanced
    Color picker format: #000
    Automatic formatting: Off
    Brace positions: Compact
+ JavaScript/TypeScript
  + Formatting
    + General
      Automatic Formatting
      ☐ Format completed line on Enter
      ☐ Format completed statement on ;
      ☐ Format opened block on {
      ☐ Format completed block on }
      ☑ Format on paste
      Module Quote Preference
      ◉ Double (")
      Semicolon Preference
      ◉ Insert semicolons at statement ends
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
```

Disable telemetry.

```
Help > Send Feedback > Settings...
+ Would you like to participate in the Visual Studio Experience Improvement Program?
  ◉ No, I would not like to participate
```

Change [toolbars](res/vs.png) to fit the desired workflow.

</details>

## CLion
Install [CLion](https://www.jetbrains.com/clion/download/).

<details>
<summary><b>Configuration</b></summary>

```
Appearanace & Behavior
+ System Settings
  ☐ Confirm before exiting the IDE
  Project
  ☐ Reopen projects on startup
  Default project directory: C:\Workspace
  + Data Sharing
    ☐ Send usage statistics
  + Date Formats
    ☑ Override system date and time format
    Date format: yyyy-MM-dd

Keymap
Keymap: Visual Studio
Main Menu > Run > Debug: F5 (Remove)
Main Menu > Run > Debugging Actions > Resume Program: F9 (Remove)
Main Menu > Run > Toggle Breakpoint > Toggle Line Breakpoint: F8

Editor
+ General
  Rich-Text Copy
  ☐ Copy (Ctrl+C) as rich text
  + Code Folding
    ☐ Show code folding outline
+ Code Style
  ClangFormat
  ☑ Enable ClangFormat (only for C/C++/Objective-C)
  + C/C++
    Scheme: Default
    + Tabs and Indents
      Tab size: 2
      Indent: 2
      Continuation indent: 2
      Indent in lambdas: 2
      Indent members of plain structures: 2
      Indent members of classes: 2
      Indent members of namespace: 0
    + Spaces
      + Within
        ☑ Initializer lists braces
      + Other
        ☑ Prevent >> concatenation in template
        ☐ Before '*' in declarations
        ☑ After '*' in declarations
        ☐ Before '&' in declarations
        ☑ After '&' in declarations
        ☑ Keep spaces between the same-type brackets
      + In Template Declaration
        ☑ Before '<'
    + Wrapping and Braces
      + Function declaration parameters
        ☐ Align when multiline
      + Function call arguments
        ☐ Align when multiline
      + 'switch' statement
        ☐ Indent 'case' branches
      + 'try' statement
        ☑ 'catch' on new line
      + Binary expressions
        ☐ Align when multiline
        ☑ New line after '('
      + Assignment statement
        ☐ Align when multiline
      + Ternary operation
        ☐ Align when multiline
        ☐ '?' and ':' signs on next line
      + Initializer lists
        ☐ Align when multiline
    + New File Extensions
      + C++
        Source Extensions: cpp
        Header Extensions: hpp
        File Naming Convention: snake_case
      + C
        File Naming Convention: snake_case
      + CUDA
        File Naming Convention: snake_case
  + CMake
    Scheme: Default
    + Tabs and Indents
      Tab size: 2
      Indent: 2
      Continuation indent: 2
    + Spaces
      ☐ 'if' parentheses
      ☐ 'for' parentheses
      ☐ 'while' parentheses
        
+ Inlay Hints
  ☐ Show hints for:

Plugins
String Manipulation

Build, Execution, Deployment
+ Toolchains
  + Visual Studio
    Architecture: amd64
+ CMake
  + Debug
    CMake options:
      -GNinja
      -DCMAKE_TOOLCHAIN_FILE="C:/Workspace/vcpkg/triplets/toolchains/windows.cmake"
      -DVCPKG_TARGET_TRIPLET="x64-windows-xnet"
    Build directory: build\windows\debug
  + Add: Release
    CMake options:
      -GNinja
      -DCMAKE_TOOLCHAIN_FILE="C:/Workspace/vcpkg/triplets/toolchains/windows.cmake"
      -DVCPKG_TARGET_TRIPLET="x64-windows-xnet"
    Build directory: build\windows\release
+ Debugger
  ☑ Hide debug window on process termination

Language & Frameworks
+ SQL Dialects
  Global SQL Dialect: SQLite

Tools
+ Terminal
  Copy to clipboard on selection
+ SSH Terminal
  Default encoding: UTF-8
```

</details>

## Visual Studio Code
Install [Visual Studio Code](https://code.visualstudio.com/download).

```
☑ Add "Open with Code" action to Windows Explorer file context menu
☑ Add "Open with Code" action to Windows Explorer directory context menu
```

<details>
<summary><b>Configuration</b></summary>

Install extensions with `CTRL+P`.

```
ext install twxs.cmake
ext install ms-vscode.cpptools
ext install ms-vscode-remote.remote-ssh
ext install ms-vscode-remote.remote-wsl
ext install donjayamanne.githistory
ext install marvhen.reflow-markdown
ext install alefragnani.rtf
> Developer: Reload Window
```

Configure editor with `> Preferences: Open Settings (JSON)`.

```json
{
  "editor.detectIndentation": false,
  "editor.dragAndDrop": false,
  "editor.folding": false,
  "editor.fontFamily": "'DejaVu LGC Sans Mono', Consolas, monospace",
  "editor.fontSize": 12,
  "editor.largeFileOptimizations": false,
  "editor.links": false,
  "editor.minimap.scale": 2,
  "editor.multiCursorModifier": "ctrlCmd",
  "editor.renderFinalNewline": false,
  "editor.renderLineHighlight": "gutter",
  "editor.renderWhitespace": "selection",
  "editor.rulers": [ 128 ],
  "editor.smoothScrolling": true,
  "editor.tabSize": 2,
  "editor.wordWrap": "on",
  "editor.wordWrapColumn": 128,
  "explorer.confirmDelete": false,
  "explorer.confirmDragAndDrop": false,
  "extensions.ignoreRecommendations": true,
  "files.eol": "\n",
  "files.hotExit": "off",
  "files.insertFinalNewline": true,
  "files.trimTrailingWhitespace": true,
  "files.defaultLanguage": "markdown",
  "git.autofetch": false,
  "git.autoRepositoryDetection": false,
  "git.confirmSync": false,
  "git.enableSmartCommit": true,
  "git.postCommitCommand": "push",
  "git.showPushSuccessNotification": true,
  "telemetry.enableCrashReporter": false,
  "telemetry.enableTelemetry": false,
  "workbench.startupEditor": "none",
  "window.newWindowDimensions": "inherit",
  "window.openFoldersInNewWindow": "on",
  "window.openFilesInNewWindow": "off",
  "window.restoreWindows": "none",
  "window.closeWhenEmpty": false,
  "terminal.integrated.rendererType": "experimentalWebgl",
  "terminal.integrated.shell.windows": "C:\\Windows\\System32\\cmd.exe",
  "C_Cpp.clang_format_path": "C:\\Program Files\\LLVM\\bin\\clang-format.exe",
  "C_Cpp.default.cStandard": "c11",
  "C_Cpp.default.cppStandard": "c++20",
  "C_Cpp.enhancedColorization": "Enabled",
  "C_Cpp.experimentalFeatures": "Enabled",
  "C_Cpp.configurationWarnings": "Disabled",
  "C_Cpp.intelliSenseEngineFallback": "Disabled",
  "C_Cpp.intelliSenseEngine": "Disabled",
  "C_Cpp.vcpkg.enabled": false,
  "cmake.configureOnOpen": false,
  "html.format.extraLiners": "",
  "html.format.indentInnerHtml": false,
  "javascript.format.insertSpaceAfterFunctionKeywordForAnonymousFunctions": false,
  "javascript.format.insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets": true,
  "typescript.format.insertSpaceAfterFunctionKeywordForAnonymousFunctions": false,
  "typescript.format.insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets": true,
  "remote.SSH.defaultExtensions": [
    "twxs.cmake",
    "ms-vscode.cpptools",
    "ms-vscode.cmake-tools"
  ]
}
```

Configure keyboard shortcuts with `> Preferences: Open Keyboard Shortcuts (JSON)`.

```json
[
  { "key": "f5", "command": "cmake.debugTarget", "when": "!inDebugMode" },
  { "key": "f5", "command": "workbench.action.debug.pause", "when": "inDebugMode && debugState == 'running'" },
  { "key": "f5", "command": "workbench.action.debug.continue", "when": "inDebugMode && debugState != 'running'" },
  { "key": "ctrl+b", "command": "cmake.selectLaunchTarget" },
  { "key": "ctrl+f5", "command": "cmake.launchTarget" }
]
```

Open a directory in WSL and install remote extensions.

```
CMake (from local)
C/C++ (from local)
ms-vscode.cmake-tools
```

Configure remote editor with `> Preferences: Open Remote Settings (WSL: Ubuntu)` while editing a directory in WSL.

```json
{
  "C_Cpp.vcpkg.enabled": false,
  "C_Cpp.default.cStandard": "c11",
  "C_Cpp.default.cppStandard": "c++20",
  "C_Cpp.default.configurationProvider": "vector-of-bool.cmake-tools",
  "C_Cpp.default.intelliSenseMode": "clang-x64",
  "C_Cpp.intelliSenseEngine": "Default",
  "C_Cpp.clang_format_path": "/opt/llvm/bin/clang-format",
  "cmake.buildDirectory": "${workspaceFolder}/build/vscode",
  "cmake.cmakePath": "/opt/cmake/bin/cmake",
  "cmake.generator": "Ninja Multi-Config",
  "cmake.installPrefix": "${workspaceFolder}",
  "cmake.configureSettings": { "VSCODE": "ON" },
  "cmake.configureOnOpen": true,
  "cmake.debugConfig": {
    "version": "0.2.0",
    "configurations": [
      {
        "name": "Debug",
        "type": "cppdbg",
        "request": "launch",
        "cwd": "${workspaceFolder}",
        "program": "${command:cmake.launchTargetPath}",
        "MIMode": "gdb",
        "stopAtEntry": false,
        "externalConsole": false,
        "internalConsoleOptions": "neverOpen",
        "setupCommands": [
          {
            "description": "Enable pretty printing.",
            "text": "-enable-pretty-printing",
            "ignoreFailures": true,
          }
        ]
      }
    ]
  }
}
```

Configure remote toolkits with `CMake: Edit User-Local CMake Kits` while editing a directory in WSL.

```json
[
  {
    "keep": true,
    "name": "Ace",
    "toolchainFile": "/opt/ace/toolchain.cmake"
  },
  {
    "keep": true,
    "name": "Xnet",
    "toolchainFile": "/opt/vcpkg/triplets/toolchains/linux.cmake",
    "cmakeSettings": { "VCPKG_TARGET_TRIPLET": "x64-linux-xnet" }
  }
]
```

</details>

## LLVM
Install [LLVM](https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/LLVM-11.0.0-win64.exe).

```
Install Options
◉ Add LLVM to the system PATN for all users
```

## NASM
Install [NASM](https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/win64/nasm-2.15.05-installer-x64.exe)

```
☐ RDOFF
☐ Manual
☐ VS8 integration
```

Add the following directories to the system environment variable `Path`.

```
C:\Program Files\NASM
```

## Vulkan
Install [Vulkan](https://vulkan.lunarg.com/sdk/home#windows).

```
Choose Install Location
C:\Vulkan
```

## Ubuntu
Install basic development packages after installing [Ubuntu](wsl/ubuntu.md) in WSL.

```sh
sudo apt install -y binutils-dev gcc g++ gdb make nasm ninja-build manpages-dev pkg-config
```

Take ownership of the `/opt` directory.

```sh
sudo chown $(id -un):$(id -gn) /opt
```

Install [CMake](https://cmake.org/).

```sh
rm -rf /opt/cmake; mkdir -p /opt/cmake
wget https://github.com/Kitware/CMake/releases/download/v3.18.4/cmake-3.18.4-Linux-x86_64.tar.gz
tar xf cmake-3.18.4-Linux-x86_64.tar.gz -C /opt/cmake --strip-components=1
rm -f cmake-3.18.4-Linux-x86_64.tar.gz

sudo tee /etc/profile.d/cmake.sh >/dev/null <<'EOF'
export PATH="/opt/cmake/bin:${PATH}"
EOF

sudo chmod 0755 /etc/profile.d/cmake.sh
. /etc/profile.d/cmake.sh
```

Install [Node](https://nodejs.org/).

```sh
rm -rf /opt/node; mkdir -p /opt/node
wget https://nodejs.org/dist/v12.16.3/node-v12.16.3-linux-x64.tar.xz
tar xf node-v12.16.3-linux-x64.tar.xz -C /opt/node --strip-components=1
rm -f node-v12.16.3-linux-x64.tar.xz

sudo tee /etc/profile.d/node.sh >/dev/null <<'EOF'
export PATH="/opt/node/bin:${PATH}"
EOF

sudo chmod 0755 /etc/profile.d/node.sh
. /etc/profile.d/node.sh
```

Install [LLVM](https://llvm.org/).

```sh
rm -rf /opt/llvm; mkdir -p /opt/llvm
wget https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/clang+llvm-11.0.0-x86_64-linux-gnu-ubuntu-20.04.tar.xz
tar xf clang+llvm-11.0.0-x86_64-linux-gnu-ubuntu-20.04.tar.xz -C /opt/llvm --strip-components=1
rm -f clang+llvm-11.0.0-x86_64-linux-gnu-ubuntu-20.04.tar.xz

sudo tee /etc/profile.d/llvm.sh >/dev/null <<'EOF'
export PATH="/opt/llvm/bin:${PATH}"
EOF

sudo chmod 0755 /etc/profile.d/llvm.sh
. /etc/profile.d/llvm.sh

sudo tee /etc/ld.so.conf.d/llvm.conf >/dev/null <<'EOF'
/opt/llvm/lib
EOF

sudo ldconfig
```

Set system LLVM C and C++ compiler.

```sh
for i in clang clang++; do sudo update-alternatives --remove-all $i; done
sudo update-alternatives --install /usr/bin/clang   clang   /opt/llvm/bin/clang   100
sudo update-alternatives --install /usr/bin/clang++ clang++ /opt/llvm/bin/clang++ 100
```

Set system C and C++ compiler.

```sh
for i in c++ cc; do sudo update-alternatives --remove-all $i; done
sudo update-alternatives --install /usr/bin/cc  cc  /usr/bin/clang   100
sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100
```

Set system `clang-format` tool.

```sh
sudo update-alternatives --remove-all clang-format
sudo update-alternatives --install /usr/bin/clang-format clang-format /opt/llvm/bin/clang-format 100
```
