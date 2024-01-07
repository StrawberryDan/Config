add_compile_definitions("$<$<CONFIG:Debug>:STRAWBERRY_DEBUG=1>")
add_compile_definitions("$<$<CONFIG:RelWithDebInfo>:STRAWBERRY_RELEASE=1>")
add_compile_definitions("$<$<CONFIG:Release>:STRAWBERRY_RELEASE=1 STRAWBERRY_FINAL=1>")