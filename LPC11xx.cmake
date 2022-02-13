if(NOT LPC11XX_CHAIN_INITIALIZED)
    # only do this on the first pass through to avoid overwriting user added options.
    set( LPC11XX_CHAIN_INITIALIZED "yes" CACHE INTERNAL
            "Has the LPC11xx toolchain been pulled?" )

    if(NOT TOOLCHAIN_PREFIX)
        message(FATAL_ERROR "No TOOLCHAIN_PREFIX specified.")
    endif()

    get_filename_component(SBTOP_DIR ${CMAKE_CURRENT_LIST_DIR}/.. REALPATH CACHE)
    message(STATUS "selfbus top dir: ${SBTOP_DIR}")
    set(SBLPC_DIR ${SBTOP_DIR}/CMSIS_CORE_LPC11xx CACHE STRING
            "Where the LPC11xx lib is")
    set(SBLIB_DIR ${SBTOP_DIR}/software-arm-lib/sblib CACHE STRING
            "Where the selfbus lib is")
    set(SBLOG_DIR ${SBTOP_DIR}/software-arm-lib/logging CACHE STRING
            "Where the selfbus logger is")

    get_filename_component(BUILD_DIR_PREFIX ${CMAKE_BINARY_DIR} NAME CACHE)

    # mcuxpresso version check
    string(REGEX MATCH "mcuxpressoide" MATCH_STR ${TOOLCHAIN_PREFIX})
    if(NOT ${MATCH_STR} STREQUAL "")
        # Get version from specified path prefix
        string(REGEX MATCH "([0-9]+.[0-9]+.[0-9]+)" MCUXPRESSO_VERSION
                ${TOOLCHAIN_PREFIX})
        if(NOT ${MCUXPRESSO_VERSION} STREQUAL "")
            message(STATUS "mcuxpresso detected: v" ${MCUXPRESSO_VERSION})
            # Check if version is supported
            if(${MCUXPRESSO_VERSION} VERSION_LESS "7.6.2")
                message(FATAL_ERROR "MCUXPRESSO version not supported: "
                        ${MCUXPRESSO_VERSION})
            endif()
        else()
            message(STATUS "WARNING: Could not check mcuxpresso version. "
                    "Build may not work correctly.")
        endif()
    endif()

    set(TARGET_TRIPLET "arm-none-eabi")

    # Where we find NXP tools for flashing and debugging
    get_filename_component(MCUX_IDE_BIN ${TOOLCHAIN_PREFIX}/../binaries/
            REALPATH CACHE)
    set(BOOT_LINK1 ${MCUX_IDE_BIN}/boot_link2 CACHE INTERNAL "link1")
    set(BOOT_LINK2 ${MCUX_IDE_BIN}/boot_link2 CACHE INTERNAL "link2")
    set(REDLINK ${MCUX_IDE_BIN}/crt_emu_cm_redlink CACHE INTERNAL "redlink")

    get_filename_component(TOOLCHAIN_BIN_DIR
            ${TOOLCHAIN_PREFIX}/bin REALPATH CACHE)
    get_filename_component(TOOLCHAIN_INC_DIR
            ${TOOLCHAIN_PREFIX}/${TARGET_TRIPLET}/include REALPATH CACHE)
    get_filename_component(TOOLCHAIN_LIB_DIR
            ${TOOLCHAIN_PREFIX}/${TARGET_TRIPLET}/lib REALPATH CACHE)

    set(CMAKE_SYSTEM_NAME Generic)
    set(CMAKE_SYSTEM_VERSION 1)
    set(CMAKE_SYSTEM_PROCESSOR arm)

    set(CMAKE_C_COMPILER ${TOOLCHAIN_BIN_DIR}/${TARGET_TRIPLET}-gcc${EXECUTABLE_SUFFIX}
            CACHE INTERNAL "c compiler")
    set(CMAKE_CXX_COMPILER ${TOOLCHAIN_BIN_DIR}/${TARGET_TRIPLET}-g++${EXECUTABLE_SUFFIX}
            CACHE INTERNAL "cxx compiler")
    set(CMAKE_ASM_COMPILER ${TOOLCHAIN_BIN_DIR}/${TARGET_TRIPLET}-as${EXECUTABLE_SUFFIX}
            CACHE INTERNAL "asm compiler")

    set(CMAKE_OBJCOPY ${TOOLCHAIN_BIN_DIR}/${TARGET_TRIPLET}-objcopy${EXECUTABLE_SUFFIX}
            CACHE INTERNAL "objcopy")
    set(CMAKE_OBJDUMP ${TOOLCHAIN_BIN_DIR}/${TARGET_TRIPLET}-objdump${EXECUTABLE_SUFFIX}
            CACHE INTERNAL "objdump")

    set(CMAKE_AR ${TOOLCHAIN_BIN_DIR}/${TARGET_TRIPLET}-ar${EXECUTABLE_SUFFIX}
            CACHE INTERNAL "archiver")

    set(CMAKE_STRIP ${TOOLCHAIN_BIN_DIR}/${TARGET_TRIPLET}-strip${EXECUTABLE_SUFFIX}
            CACHE INTERNAL "strip")
    set(CMAKE_SIZE ${TOOLCHAIN_BIN_DIR}/${TARGET_TRIPLET}-size${EXECUTABLE_SUFFIX}
            CACHE INTERNAL "size")

    # Adjust the default behaviour of the FIND_XXX() commands:
    # i)    Search headers and libraries in the target environment
    # ii)   Search programs in the host environment
    set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
    set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
    set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

    set(CMAKE_COMPILER_IS_GNUCC     1)
    set(CMAKE_C_COMPILER_ID         GNU)
    set(CMAKE_C_COMPILER_ID_RUN     TRUE)
    set(CMAKE_C_COMPILER_FORCED     TRUE)
    set(CMAKE_CXX_COMPILER_ID       GNU)
    set(CMAKE_CXX_COMPILER_ID_RUN   TRUE)
    set(CMAKE_CXX_COMPILER_FORCED   TRUE)

    set(CMAKE_CXX_FLAGS "-fno-rtti -fno-exceptions" CACHE INTERNAL "c++ compiler")

endif(NOT LPC11XX_CHAIN_INITIALIZED)

add_definitions(
        -fmessage-length=0 -fno-builtin -ffunction-sections -fdata-sections
        -fstack-usage -mcpu=cortex-m0 -mthumb
        -DCORE_M0 -D__NEWLIB__
        -D__USE_CMSIS=CMSIS_CORE_LPC11xx -D__LPC11XX__
)

