function(add_strawberry_definitions TARGET)
    target_compile_definitions(${TARGET} PRIVATE "$<$<CONFIG:Debug>:STRAWBERRY_DEBUG=1>")
    target_compile_definitions(${TARGET} PRIVATE "$<$<CONFIG:RelWithDebInfo>:STRAWBERRY_RELEASE=1>")
    target_compile_definitions(${TARGET} PRIVATE "$<$<CONFIG:Release>:STRAWBERRY_RELEASE=1 STRAWBERRY_FINAL=1>")


    target_compile_definitions(${TARGET} PRIVATE "$<$<PLATFORM_ID:Windows>:STRAWBERRY_TARGET_WINDOWS>")
    target_compile_definitions(${TARGET} PRIVATE "$<$<PLATFORM_ID:Darwin>:STRAWBERRY_TARGET_MAC>")
    target_compile_definitions(${TARGET} PRIVATE "$<$<PLATFORM_ID:Linux>:STRAWBERRY_TARGET_LINUX>")
endfunction()


function(new_strawberry_executable)
    cmake_parse_arguments("EXECUTABLE" "" "NAME" "SOURCE" ${ARGN})
    add_executable(${EXECUTABLE_NAME} ${EXECUTABLE_SOURCE})
    add_strawberry_definitions(${EXECUTABLE_NAME})
    set_target_properties(${EXECUTABLE_NAME} PROPERTIES CXX_STANDARD 23)
endfunction()


function(new_strawberry_library)
    cmake_parse_arguments("LIBRARY" "" "NAME" "SOURCE" ${ARGN})
    add_library(${LIBRARY_NAME} STATIC ${LIBRARY_SOURCE})
    add_strawberry_definitions(${LIBRARY_NAME})
    set_target_properties(${NAME} PROPERTIES CXX_STANDARD 23)
endfunction()