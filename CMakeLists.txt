cmake_minimum_required(VERSION 3.5)

# Set toolchain file if not specified
if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
    set(CMAKE_TOOLCHAIN_FILE ${CMAKE_SOURCE_DIR}/LPC11xx.cmake)
    message(STATUS "Toolchain file(LPC11xx): " ${CMAKE_TOOLCHAIN_FILE})
endif()
if(NOT EXISTS ${CMAKE_TOOLCHAIN_FILE})
    message(FATAL_ERROR "Toolchain file does not exist: " ${CMAKE_TOOLCHAIN_FILE})
endif()

project(CMSIS_CORE_LPC11xx C)

set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "How to build")
set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS Debug Release)
add_definitions(-D__REDLIB__)
include_directories(inc)

add_library(CMSIS_CORE_LPC11xx
        inc/core_cm0.h
        inc/core_cmFunc.h
        inc/core_cmInstr.h
        inc/LPC11xx.h
        inc/system_LPC11xx.h
        src/system_LPC11xx.c)
