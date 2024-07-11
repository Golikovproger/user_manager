cmake_minimum_required(VERSION 3.14)

project(user_manager LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(QT_VERSION 5)

find_package(Qt${QT_VERSION} COMPONENTS Core Gui Qml Quick Sql REQUIRED)

set(PROJECT_SOURCES
    src/main.cpp
    src/users.cpp
    src/loger.cpp
)

set(PROJECT_HEADERS
    src/users.h
    src/loger.h
)

add_executable(user_manager
    assets.qrc
    qml.qrc
    ${PROJECT_SOURCES}
    ${PROJECT_HEADERS}
)

target_link_libraries(user_manager PRIVATE Qt${QT_VERSION}::Core Qt${QT_VERSION}::Gui Qt${QT_VERSION}::Sql Qt${QT_VERSION}::Qml Qt${QT_VERSION}::Quick)

set_source_files_properties(qml.qrc PROPERTIES
    OBJECT_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/qml/main.qml"
)

set(CMAKE_INSTALL_PREFIX "/usr/local" CACHE PATH "Installation Directory" FORCE)

install(TARGETS user_manager RUNTIME DESTINATION bin)

# CPack Configuration
set(CPACK_GENERATOR "DEB")
set(CPACK_PACKAGE_NAME "user_manager")
set(CPACK_PACKAGE_VERSION "1.0.0")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "User Manager Application")
set(CPACK_PACKAGE_CONTACT "maksimgolikov19@gmail.com")
set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}")
set(CPACK_SOURCE_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Golikov Maksim")
set(CPACK_DEBIAN_PACKAGE_SECTION "utils")
set(CPACK_DEBIAN_PACKAGE_PRIORITY "optional")
set(CPACK_DEBIAN_PACKAGE_DEPENDS "qt${QT_VERSION}-default")
set(CPACK_RPM_PACKAGE_REQUIRES "qt${QT_VERSION}-qtbase")

include(CPack)

