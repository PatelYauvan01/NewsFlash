#ifndef RUNNER_WIN32_WINDOW_H_
#define RUNNER_WIN32_WINDOW_H_

#include <memory>
#include <string>

class Win32Window {
 public:
  struct Point {
    unsigned int x;
    unsigned int y;
    Point(unsigned int x, unsigned int y) : x(x), y(y) {}
  };

  Win32Window();
  virtual ~Win32Window();

  bool CreateAndShow(const std::wstring& title);

  static Point GetPhysicalScreenSize();

  HWND TopLevelWindowHandle() const {
    return window_handle_;
  }

 protected:
  virtual void Destroy();

  virtual LRESULT MessageHandler(HWND window, UINT const message,
                                 WPARAM const wparam, LPARAM const lparam) noexcept;

 private:
  friend class Win32FlutterWindow;

  static const wchar_t kWindowClassName[];

  static LRESULT CALLBACK WndProc(HWND const window, UINT const message,
                                  WPARAM const wparam,
                                  LPARAM const lparam) noexcept;

  static Win32Window* GetThisFromHandle(HWND const window) noexcept;

  static const wchar_t* RegisterWindowClass(const wchar_t* window_class_name);

  bool OnCreate();

  HWND window_handle_ = nullptr;
};

#endif  // RUNNER_WIN32_WINDOW_H_
