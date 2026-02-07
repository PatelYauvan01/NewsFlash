# Flutter-managed C++ toolchain. Do not edit.

# Analytics
set(FLUTTER_TOOL_ENVIRONMENT "{"
  "\\\"electron\\\":false"
"}")

# Toolchain.
if(NOT DEFINED CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 17)
endif()

if(NOT DEFINED CMAKE_C_STANDARD)
  set(CMAKE_C_STANDARD 11)
endif()

if(NOT DEFINED CMAKE_CXX_STANDARD_REQUIRED)
  set(CMAKE_CXX_STANDARD_REQUIRED ON)
endif()

set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_LIST_DIR}")

# Define the application target. To change its name, change BINARY_NAME in CMakeLists.txt, not here.
set(BINARY_NAME "newswatch")

# Defined for convenience, used in runner CMake template. Change anything in this
# list in CMakeLists.txt, not here.
set(FLUTTER_LIBRARY_NAME "flutter")

# App-specific configuration to load into the runner's main.
list(APPEND FLUTTER_LIBRARY_NAME "flutter")

# Populated by flutter pub download.
list(APPEND FLUTTER_PLUGIN_LIST
  "shared_preferences_windows"
)

set(PLUGIN_BUNDLED_LIBRARIES)

foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_subdirectory(flutter_plugins/${plugin}/windows plugins/${plugin})
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin}_plugin)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES $<TARGET_FILE:${plugin}_plugin>)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES ${${plugin}_bundled_libraries})
endforeach(plugin)

# Add flags that are needed as of the C++ toolchain used to build Flutter's
# engine, to be of a migrated buildable state, and flutter plugins.
add_compile_options(/W4 /WX /permissive- /Zc:inline)

# Apply flags to the Flutter library and the plugins.
add_compile_options(/permissive-)
add_compile_options(/Zc:inline)

function(apply_standard_settings TARGET)
  target_compile_features(${TARGET} CXXABI PUBLIC cxx_std_17)
  target_compile_options(${TARGET} PRIVATE /W4 /WX /permissive- /Zc:inline)
  target_compile_options(${TARGET} PRIVATE "$<$<CONFIG:Debug>:/RTC1>")
  target_compile_definitions(${TARGET} PRIVATE "$<$<CONFIG:Debug>:_DEBUG>")
endfunction()

set(FLUTTER_TARGET_PLATFORM "windows-x64")

# Adds the Flutter toolchain to CMake.
list(APPEND CMAKE_MODULE_PATH "${FLUTTER_MANAGED_DIR}")
include(flutter_windows)
