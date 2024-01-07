add_compile_definitions("$<$<CONFIG:Debug>:STRAWBERRY_DEBUG=1>")
add_compile_definitions("$<$<CONFIG:RelWithDebInfo>:STRAWBERRY_RELEASE=1>")
add_compile_definitions("$<$<CONFIG:Release>:STRAWBERRY_RELEASE=1 STRAWBERRY_FINAL=1>")


add_compile_definitions("$<$<PLATFORM_ID:Windows>:STRAWBERRY_TARGET_WINDOWS>")
add_compile_definitions("$<$<PLATFORM_ID:Darwin>:STRAWBERRY_TARGET_MAC>")
add_compile_definitions("$<$<PLATFORM_ID:Linux>:STRAWBERRY_TARGET_LINUX>")
