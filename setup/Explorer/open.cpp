#include <windows.h>
#include <shellapi.h>
#include <string>
#include <string_view>

std::wstring path() {
  DWORD size = 0;
  std::wstring str;
  do {
    str.resize(str.size() + MAX_PATH);
    size = GetModuleFileName(nullptr, &str[0], static_cast<DWORD>(str.size()));
  } while (GetLastError() == ERROR_INSUFFICIENT_BUFFER);
  str.resize(size);
  return str;
}

int WINAPI wWinMain(HINSTANCE hinstance, HINSTANCE, LPWSTR cmd, int show) {
  auto argc = 0;
  auto argv = CommandLineToArgvW(cmd, &argc);

  DWORD size = 0;
  std::wstring path;
  do {
    path.resize(path.size() + MAX_PATH);
    size = GetModuleFileName(nullptr, path.data(), static_cast<DWORD>(path.size()));
  } while (GetLastError() == ERROR_INSUFFICIENT_BUFFER);
  path.resize(size);
  if (const auto pos = path.rfind(L'\\'); pos != std::wstring::npos) {
    path.erase(pos);
  }

  std::wstring file = L"C:\\Windows\\System32\\cmd.exe /K cls";
  std::wstring link = path + L"\\icons\\Console.lnk";
  for (auto i = 0; i < argc; i++) {
    if (argv[i] == std::wstring_view(L"terminal")) {
      file = L"C:\\Windows\\System32\\bash.exe";
      link = path + L"\\icons\\Terminal.lnk";
      break;
    }
  }

  STARTUPINFO si = {};
  si.cb = sizeof(si);
  si.dwFlags = 0x800;
  si.lpTitle = link.data();
  si.wShowWindow = show;
  PROCESS_INFORMATION pi = {};
  if (CreateProcess(nullptr, file.data(), nullptr, nullptr, FALSE, 0, nullptr, nullptr, &si, &pi)) {
    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);
  }
  return 0;
}
