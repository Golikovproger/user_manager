cmake_minimum_required(VERSION 3.14)

project(user_manager LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt5 COMPONENTS Core Gui Qml Quick REQUIRED)

add_executable(user_manager
    qml.qrc
    src/main.cpp
)

target_link_libraries(user_manager PRIVATE Qt5::Core Qt5::Gui Qt5::Qml Qt5::Quick)

set_source_files_properties(qml.qrc PROPERTIES
    OBJECT_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/qml/main.qml"
)
