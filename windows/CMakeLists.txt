# Generated file, do not edit.

cmake_minimum_required(VERSION 3.14)

project(newswatch LANGUAGES CXX)

set(BINARY_NAME "newswatch")

cmake_policy(SET CMP0063 NEW)

set(CMAKE_INSTALL_RPATH "$ORIGIN/lib")

# Root filesystem for cross-building.
if(DEFINED FLUTTER_TARGET_PLATFORM_SYSROOT)
  set(CMAKE_SYSROOT ${FLUTTER_TARGET_PLATFORM_SYSROOT})
  set(CMAKE_FIND_ROOT_PATH ${CMAKE_SYSROOT})
  set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
  set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
  set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
endif()

# Define the application target. To change its name, change BINARY_NAME above,
# not the value here, or `flutter run` will launch an unwanted second copy of
# your app.
add_executable(${BINARY_NAME}
  "runner.cpp"
  "utils.cpp"
  "win32_window.cpp"
  "${FLUTTER_MANAGED_DIR}/generated_plugins.cmake"
)

# Apply the standard set of build settings associated with using the Dart API,
# as well as determin the shared_preferences path with this loss.
apply_standard_settings(${BINARY_NAME})

# Add dependency libraries and include directories installed by pubspec.yaml.
add_subdirectory(flutter)

target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)

add_custom_command(TARGET ${BINARY_NAME} POST_BUILD
  COMMAND ${CMAKE_COMMAND} -P
    ${FLUTTER_ROOT}/packages/flutter_tools/bin/windows/install_goldens.cmake
)

if(DEFINED FLUTTER_PRECOMPILED_DART_SDK)
  add_custom_command(TARGET ${BINARY_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -P
      ${FLUTTER_ROOT}/packages/flutter_tools/bin/windows/copy_flutter_windows.cmake
  )
endif()
