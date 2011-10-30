include(/usr/share/cmake/rosbuild/parse_arguments.cmake)
include(/usr/share/cmake/rosbuild/wg_python.cmake)
include(/usr/share/cmake/rosbuild/debian-util.cmake)

macro(install_cmake_infrastructure PACKAGE_NAME)
  parse_arguments(PACKAGE "VERSION;INCLUDE_DIRS;LIBRARIES;CFG_EXTRAS;MSG_DIRS" "" ${ARGN})

  message("install_cmake_infrastructure ${PACKAGE_NAME} at version ${PACKAGE_VERSION} in /usr")
  set(pfx ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_FILES_DIRECTORY})
  set(PACKAGE_NAME ${PACKAGE_NAME})
  set(PACKAGE_VERSION ${PACKAGE_VERSION})
  set(PACKAGE_INCLUDE_DIRS ${PACKAGE_INCLUDE_DIRS})
  set(PACKAGE_LIBRARIES ${PACKAGE_LIBRARIES})
  set(PACKAGE_CFG_EXTRAS ${PACKAGE_CFG_EXTRAS})
  set(PACKAGE_CMAKE_CONFIG_FILES_DIR ${CMAKE_INSTALL_PREFIX}/share/cmake/${PACKAGE_NAME})
  set(PACKAGE_MSG_DIRS ${PACKAGE_MSG_DIRS})

  set(INSTALLABLE_CFG_EXTRAS "")
  foreach(extra ${PACKAGE_CFG_EXTRAS})
    list(APPEND INSTALLABLE_CFG_EXTRAS ${CMAKE_CURRENT_BINARY_DIR}/${extra})
    configure_file(${extra}.in
      ${extra}
      @ONLY
      )
  endforeach()

  configure_file(/usr/share/cmake/rosbuild/pkg-config.cmake.in
    ${pfx}/${PACKAGE_NAME}-config.cmake
    @ONLY
    )
  configure_file(/usr/share/cmake/rosbuild/pkg-config-version.cmake.in
    ${pfx}/${PACKAGE_NAME}-config-version.cmake
    @ONLY
    )
  install(FILES 
    ${pfx}/${PACKAGE_NAME}-config.cmake
    ${pfx}/${PACKAGE_NAME}-config-version.cmake
    ${INSTALLABLE_CFG_EXTRAS}
    DESTINATION share/cmake/${PACKAGE_NAME}
    )
  
endmacro()

macro(em_expand CONTEXT_FILE CMAKE_TEMPLATE_FILE)
  get_filename_component(CONTEXT_FILE_NOPATH ${CONTEXT_FILE} NAME)
  get_filename_component(CMAKE_TEMPLATE_FILE_NOPATH ${CMAKE_TEMPLATE_FILE} NAME)
  configure_file(${CONTEXT_FILE} ${CMAKE_BINARY_DIR}/${CONTEXT_FILE_NOPATH}.py)
  execute_process(COMMAND
    python /em_expander.py
    ${CMAKE_CURRENT_BINARY_DIR}/${CONTEXT_FILE_NOPATH}.py
    ${CMAKE_TEMPLATE_FILE}
    ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_TEMPLATE_FILE_NOPATH}.out
    )
  include(${CMAKE_BINARY_DIR}/${CMAKE_TEMPLATE_FILE_NOPATH})
endmacro()


macro(execute_code_string CODE_STRING)
  string(RANDOM CODE_FILE_RND_COMPONENT)
  set(TMP_CODE_FILE ${CMAKE_CURRENT_BINARY_DIR}/code_${CODE_FILE_RND_COMPONENT}.tmp)
  file(WRITE ${TMP_CODE_FILE} "${CODE_STRING}")
  include(${TMP_CODE_FILE})
  file(REMOVE ${TMP_CODE_FILE})
endmacro()
