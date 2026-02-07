#include "win32_window.h"

#include <windows.h>

const wchar_t kWindowClassName[] = L"FLUTTER_RUNNER_WIN32_WINDOW";

Win32Window::Win32Window() {
  ::SecureZeroMemory(this, sizeof(*this));
}

Win32Window::~Win32Window() {
  Destroy();
}

bool Win32Window::CreateAndShow(const std::wstring& title) {
  Destroy();

  const wchar_t* window_class =
      RegisterWindowClass(L"FLUTTER_RUNNER_WIN32_WINDOW");
  if (!window_class) {
    return false;
  }

  HWND window = CreateWindowEx(
      0, window_class, title.c_str(), WS_OVERLAPPEDWINDOW | WS_VISIBLE, 100,
      100, 1280, 720, nullptr, nullptr, GetModuleHandle(nullptr), this);

  if (!window) {
    return false;
  }

  return OnCreate();
}

Win32Window::Point Win32Window::GetPhysicalScreenSize() {
  return {GetSystemMetrics(SM_CXSCREEN), GetSystemMetrics(SM_CYSCREEN)};
}

void Win32Window::Destroy() {
  if (window_handle_) {
    DestroyWindow(window_handle_);
    window_handle_ = nullptr;
  }

  UnregisterClass(kWindowClassName, nullptr);
}

LRESULT CALLBACK Win32Window::WndProc(HWND const window, UINT const message,
                                      WPARAM const wparam,
                                      LPARAM const lparam) noexcept {
  if (message == WM_CREATE) {
    auto window_struct = reinterpret_cast<CREATESTRUCT*>(lparam);
    SetWindowLongPtr(window, GWLP_USERDATA,
                     (long)window_struct->lpCreateParams);

    auto that = static_cast<Win32Window*>(window_struct->lpCreateParams);
    that->window_handle_ = window;

    return 0;
  }

  auto that = GetThisFromHandle(window);

  if (!that) {
    return DefWindowProc(window, message, wparam, lparam);
  }

  return that->MessageHandler(window, message, wparam, lparam);
}

LRESULT
Win32Window::MessageHandler(HWND hwnd, UINT const message, WPARAM const wparam,
                            LPARAM const lparam) noexcept {
  switch (message) {
    case WM_DESTROY:
      window_handle_ = nullptr;
      Destroy();
      break;
  }

  return DefWindowProc(hwnd, message, wparam, lparam);
}

WNDCLASS Win32Window::RegisterWindowClass(const wchar_t* window_class_name) {
  static bool window_class_registered = false;

  if (window_class_registered) {
    return GetClassInfoEx(nullptr, window_class_name, nullptr) ? window_class_name : nullptr;
  }

  WNDCLASS window_class{};
  window_class.hInstance = GetModuleHandle(nullptr);
  window_class.lpszClassName = window_class_name;
  window_class.lpfnWndProc = WndProc;
  window_class.hCursor = LoadCursor(nullptr, IDC_ARROW);
  window_class.hIcon =
      LoadIcon(GetModuleHandle(nullptr), MAKEINTRESOURCE(IDI_APP_ICON));
  if (!RegisterClass(&window_class)) {
    return false;
  }

  window_class_registered = true;
  return window_class_name;
}

Win32Window* Win32Window::GetThisFromHandle(HWND const window) noexcept {
  return reinterpret_cast<Win32Window*>(
      GetWindowLongPtr(window, GWLP_USERDATA));
}

bool Win32Window::OnCreate() {
  return true;
}
