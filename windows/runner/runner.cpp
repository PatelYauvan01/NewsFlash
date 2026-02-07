#include <flutter/flutter_window.h>
#include <windows.h>

#include "runner.h"
#include "utils.h"
#include "win32_window.h"

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  CreateAndAttachConsole();

  std::unique_ptr<flutter::FlutterWindow> window =
      std::make_unique<flutter::FlutterWindow>(show_command, instance,
                                               L"NewsWatch", L"assets/");
  Win32Window::Point client_area = window->GetPhysicalScreenSize();

  if (!window->OnCreate()) {
    return EXIT_FAILURE;
  }

  window->Show();

  return EXIT_SUCCESS;
}
