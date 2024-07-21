function(add_strawberry_definitions TARGET)
    target_compile_definitions(${TARGET} "$<$<CONFIG:Debug>:STRAWBERRY_DEBUG=1>")
    target_compile_definitions(${TARGET} "$<$<CONFIG:RelWithDebInfo>:STRAWBERRY_RELEASE=1>")
    target_compile_definitions(${TARGET} "$<$<CONFIG:Release>:STRAWBERRY_RELEASE=1 STRAWBERRY_FINAL=1>")


    target_compile_definitions(${TARGET} "$<$<PLATFORM_ID:Windows>:STRAWBERRY_TARGET_WINDOWS>")
    target_compile_definitions(${TARGET} "$<$<PLATFORM_ID:Darwin>:STRAWBERRY_TARGET_MAC>")
    target_compile_definitions(${TARGET} "$<$<PLATFORM_ID:Linux>:STRAWBERRY_TARGET_LINUX>")
endfunction()


function(new_strawberry_executable NAME SOURCE_FILES)
    add_executable(${NAME} ${SOURCE_FILES})
    add_strawberry_definitions(${NAME})
    set_target_properties(${NAME} PROPERTIES CXX_STANDARD 23)
endfunction()


function(new_strawberry_library NAME SOURCE_FILES)
    add_library(${NAME} STATIC ${SOURCE_FILES})
    add_strawberry_definitions(${NAME})
    set_target_properties(${NAME} PROPERTIES CXX_STANDARD 23)
endfunction()