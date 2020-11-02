# Development
Installation and configuration of a Windows 10 development workstation.

Install [Visual Studio](https://visualstudio.microsoft.com/downloads/).

```
Workloads
+ ☑ Desktop development with C++
+ ☑ Node.js development

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

Install [Trailing Whitespace Visualizer](https://marketplace.visualstudio.com/items?itemName=MadsKristensen.TrailingWhitespaceVisualizer).

Install [Visual Studio Code](https://code.visualstudio.com/download).

```
☐ Add "Open with Code" action to Windows Explorer file context menu
☐ Add "Open with Code" action to Windows Explorer directory context menu
☐ Register Code as an editor for supported file types
☐ Add to PATH (requires shell restart)
```

Install [CMake](https://github.com/Kitware/CMake/releases/download/v3.18.4/cmake-3.18.4-win64-x64.msi).

```
Install Options
  ◉ Do not add CMake to the system PATH
```


Install [Ninja](https://github.com/ninja-build/ninja/releases).

```
C:\Program Files (x86)\Ninja\ninja.exe
```

Install [Node LTS](https://nodejs.org/dist/v12.19.0/node-v12.19.0-x64.msi).

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
C:\Program Files (x86)\Sysinternals Suite
C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Tools\Llvm\x64\bin
C:\Program Files (x86)\Ninja
C:\Program Files\7-Zip
C:\Program Files\CMake\bin
C:\Program Files\Git\cmd
C:\Program Files\Microsoft VS Code\bin
C:\Workspace\vcpkg
C:\Vulkan\Bin
C:\Node
```

Create the System `VSCMD_SKIP_SENDTELEMETRY` environment variable.

```
1
```

Configure npm.

```cmd
npm set init.author.email "name@example.com"
npm config set init.author.name "Name Surname"
npm config set scripts-prepend-node-path false
npm config set prefix "%UserProfile%\AppData\Roaming\npm"
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
      Disable Automatic Precompiled Header: True
      Enable Template IntelliSense: False
  + Formatting
    + General
      ◉ Run ClangFormat only for manually invoked formatting commands
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
      Module Quote Preference
      ◉ Double (")
      Semicolon Preference
      ◉ Insert semicolons at statement ends
    + Spacing
      ☐ Insert space after function keyword for anonymous functions
  + Linting
    + General
      ☑ Enable ESLint
      [Reset global .eslintrc]
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

Install [Hide Suggestion And Outlining Margins](https://marketplace.visualstudio.com/items?itemName=MussiKara.HideSuggestionAndOutliningMargins) extension.

Install [Trailing Whitespace Visualizer](https://marketplace.visualstudio.com/items?itemName=MadsKristensen.TrailingWhitespaceVisualizer) extension.

Install [Struct Layout](https://marketplace.visualstudio.com/items?itemName=RamonViladomat.StructLayout) extension.

</details>

<details>
<summary><b>Visual Studio Code</b></summary>

Install extensions with the following commands with `CTRL+P`.

```
ext install aeschli.vscode-css-formatter
ext install alefragnani.rtf
ext install donjayamanne.githistory
ext install marvhen.reflow-markdown
ext install dbaeumer.vscode-eslint
ext install ms-vscode.cpptools
ext install ms-vscode.cmake-tools
ext install twxs.cmake
ext install xaver.clang-format
ext install esbenp.prettier-vscode
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
  "editor.links": false,
  "editor.fontSize": 12,
  "editor.largeFileOptimizations": false,
  "editor.multiCursorModifier": "ctrlCmd",
  "editor.renderWhitespace": "selection",
  "editor.renderLineHighlight": "all",
  "editor.rulers": [ 128 ],
  "editor.smoothScrolling": true,
  "editor.minimap.scale": 2,
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
  "window.zoomLevel": 0,
  "terminal.integrated.rendererType": "experimentalWebgl",
  "terminal.integrated.shell.windows": "C:\\Windows\\System32\\cmd.exe",
  "debug.internalConsoleOptions": "openOnSessionStart",
  "debug.openExplorerOnEnd": true,
  "debug.openDebug": "openOnDebugBreak",
  "debug.onTaskErrors": "showErrors",
  "C_Cpp.vcpkg.enabled": false,
  "C_Cpp.default.cStandard": "c11",
  "C_Cpp.default.cppStandard": "c++20",
  "C_Cpp.enhancedColorization": "Enabled",
  "C_Cpp.experimentalFeatures": "Enabled",
  "C_Cpp.configurationWarnings": "Disabled",
  "C_Cpp.workspaceParsingPriority": "highest",
  "C_Cpp.intelliSenseEngineFallback": "Disabled",
  "C_Cpp.default.configurationProvider": "vector-of-bool.cmake-tools",
  "C_Cpp.clang_format_path": "C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Community\\VC\\Tools\\Llvm\\x64\\bin\\clang-format.exe",
  "clang-format.executable": "C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Community\\VC\\Tools\\Llvm\\x64\\bin\\clang-format.exe",
  "cmake.generator": "Ninja",
  "cmake.buildDirectory": "${workspaceFolder}/build/windows",
  "cmake.installPrefix": "${workspaceFolder}/build/install",
  "cmake.cmakeCommunicationMode": "fileApi",
  "cmake.configureOnOpen": true,
  "launch": {
    "version": "0.2.0",
    "configurations": [
      {
        "name": "run",
        "type": "cppvsdbg",
        "request": "launch",
        "internalConsoleOptions": "openOnSessionStart",
        "program": "${command:cmake.launchTargetPath}",
        "cwd": "${workspaceRoot}",
        "externalConsole": false,
        "stopAtEntry": false,
        "environment": [],
        "args": []
      }
    ]
  },
  "html.format.indentInnerHtml": false,
  "html.format.extraLiners": "",
  "[c]": {
    "editor.defaultFormatter": "xaver.clang-format",
    "editor.formatOnSave": true
  },
  "[cpp]": {
    "editor.defaultFormatter": "xaver.clang-format",
    "editor.formatOnSave": true
  },
  "[svelte]": {
    "editor.defaultFormatter": "JamesBirtles.svelte-vscode",
    "editor.formatOnSave": true
  },
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.formatOnSave": true
  },
  "[html]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.formatOnSave": true
  },
  "[css]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.formatOnSave": true
  }
}
```

Configure keyboard shortcuts with `> Preferences: Open Keyboard Shortcuts (JSON)`.

```json
[
  { "key": "ctrl+f5", "command": "workbench.action.debug.run" },
  { "key": "f5", "command": "workbench.action.debug.start", "when": "!inDebugMode" },
  { "key": "f5", "command": "workbench.action.debug.restart", "when": "inDebugMode" },
  { "key": "f6", "command": "workbench.action.debug.pause", "when": "debugState == 'running'" },
  { "key": "f6", "command": "workbench.action.debug.continue", "when": "debugState != 'running'" },
  { "key": "f7", "command": "workbench.action.tasks.build" }
]
```

Configure CMake Tools kits with `> CMake: Edit User-Local CMake Kits`.

```json
[
  {
    "keep": true,
    "name": "x64-windows-ipo",
    "visualStudio": "VisualStudio.16.0",
    "visualStudioArchitecture": "amd64",
    "toolchainFile": "${env.VCPKG_ROOT}\\triplets\\toolchains\\windows.cmake",
    "cmakeSettings": {
      "CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG": "debug",
      "CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE": "release"
    }
  }
]
```

Register VS Code in Explorer context menus.

```cmd
set code=C:\Users\Qis\AppData\Local\Programs\Microsoft VS Code\Code.exe
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
C:\Android\build-tools\29.0.3
C:\Android\platform-tools
```

Extract the [German Dictionary](http://www.winedt.org/dict/de_neu.zip) file as `C:\Android\dict\de_neu.dic`.

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
      ☐ Show external annotations inline
    + Code Completion
      ☐ Show the parameter info popup in [1000] ms
  + Font
    Font: DejaVu LGC Sans Mono
    Size: 12
    Line spacing: 1.0
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
    + Java, C/C++, CMake, Groovy, HTML, JSON, Kotlin, XML, Other File Types
      Tabs and Indents
        Tab size: 2
        Indent: 2
        Continuation indent: 2
      Wrapping and Braces
        > 'try' statement
          ☑ 'catch' on new line
          ☑ 'finally' on new line
    + C/C++
      Tabs and Indents
        Indent in lambdas: 2
        Indent members of plain structures: 2
        Indent members of classes: 2
        Indent members of namespace: 0
      Spaces
        Other
          ☐ Prevent > > concatenation in template
        In Template Declaration
          ☑ Before '<'
        In Template Instantiation
          ☑ Before '<'
      New File Extensions
        C++
          Header Extension: hpp
          File Naming Convention: snake_case
        C
          File Naming Convention: snake_case
    + EditorConfig
      Spaces
        > Around Operators
          ☑ After ':'
    + Properties
      Insert space around key-value delimiter: ☑
  + File Encodings
    Global Encoding: UTF-8
    Project Encoding: UTF-8
    Default encoding for properties files: UTF-8
    Create UTF-8 files: with NO BOM
  + Layout Editor
    ☑ Prefer XML editor
  + Spelling
    Custom Dictionaries: [+]
    C:\Android\dict\de_neu.dic
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
sudo chown `id -un`:`id -gn` /opt
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
