cmake_minimum_required(VERSION 3.14)
project(invobox_erp LANGUAGES CXX)

set(BINARY_NAME "invobox_erp")

cmake_policy(SET CMP0063 NEW)

set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install")

include(flutter/generated_plugins.cmake)

add_subdirectory(flutter)
add_subdirectory(runner)

install(TARGETS ${BINARY_NAME} RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}"
  COMPONENT Runtime)

set(CMAKE_VS_INCLUDE_INSTALL_TO_DEFAULT_BUILD 1)
