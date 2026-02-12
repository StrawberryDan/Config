include(CTest)


function (strawberry_log LEVEL MESSAGE)
	message(${LEVEL} "[STRAWBERRY][${LEVEL}]\t${MESSAGE}")
endfunction()


strawberry_log(STATUS "Running StrawberryConfig!")


function(add_strawberry_definitions TARGET)
	target_compile_definitions(${TARGET} PUBLIC "$<$<CONFIG:Debug>:STRAWBERRY_DEBUG=1>")
	target_compile_definitions(${TARGET} PUBLIC "$<$<CONFIG:Release>:STRAWBERRY_RELEASE=1>")


	target_compile_definitions(${TARGET} PUBLIC "$<$<PLATFORM_ID:Windows>:STRAWBERRY_TARGET_WINDOWS>")
	target_compile_definitions(${TARGET} PUBLIC "$<$<PLATFORM_ID:Darwin>:STRAWBERRY_TARGET_MAC>")
	target_compile_definitions(${TARGET} PUBLIC "$<$<PLATFORM_ID:Linux>:STRAWBERRY_TARGET_LINUX>")

	# Set macros for compiler detection
	if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
		target_compile_definitions(${TARGET} PUBLIC "STRAWBERRY_COMPILER_GCC")
	elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang")
		target_compile_definitions(${TARGET} PUBLIC "STRAWBERRY_COMPILER_CLANG")
	elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
		target_compile_definitions(${TARGET} PUBLIC "STRAWBERRY_COMPILER_MSVC")
	else()
		strawberry_log(FATAL "Could not identify compiler! Could not set macros for compilation")
	endif()

	# Set the execution charset to UTF-8 explicitly
	if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
		target_compile_options(${TARGET} PRIVATE "-fexec-charset=UTF-8")
	elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang")
		target_compile_options(${TARGET} PRIVATE "-fexec-charset=UTF-8")
	elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
		target_compile_options(${TARGET} PRIVATE "/execution-charset:UTF-8")
	else ()
		strawberry_log(WARNING "Not known how to set the execution charset for this compiler. Library functions expect string literals to be UTF-8.")
	endif()
endfunction()


function(new_strawberry_executable)
	cmake_parse_arguments("EXECUTABLE" "" "NAME" "SOURCE" ${ARGN})
	add_executable(${EXECUTABLE_NAME} ${EXECUTABLE_SOURCE})
	add_strawberry_definitions(${EXECUTABLE_NAME})
	target_compile_features(${EXECUTABLE_NAME} PUBLIC cxx_std_23)
	set_target_properties(${EXECUTABLE_NAME} PROPERTIES COMPILE_WARNING_AS_ERROR ON)
endfunction()


function(new_strawberry_library)
	cmake_parse_arguments("LIBRARY" "" "NAME" "SOURCE" ${ARGN})
	add_library(${LIBRARY_NAME} STATIC ${LIBRARY_SOURCE})
	add_strawberry_definitions(${LIBRARY_NAME})
	target_compile_features(${LIBRARY_NAME} PUBLIC cxx_std_23)
	set_target_properties(${LIBRARY_NAME} PROPERTIES COMPILE_WARNING_AS_ERROR ON)
endfunction()


function(find_strawberry_library)
	cmake_parse_arguments("LIBRARY" "" "NAME" "NAMES" ${ARGN})
	set(ALL_NAMES "")
	list(APPEND ALL_NAMES ${LIBRARY_NAME})
	list(APPEND ALL_NAMES ${LIBRARY_NAMES})

	foreach (NAME ${ALL_NAMES})
		if (EXISTS ${CMAKE_SOURCE_DIR}/../${NAME})
			strawberry_log(STATUS "Found library ${NAME} at ${CMAKE_CURRENT_SOURCE_DIR}/../${NAME}")
			add_subdirectory(${CMAKE_SOURCE_DIR}/../${NAME} ${CMAKE_CURRENT_BINARY_DIR}/Strawberry/${NAME})
		else ()
			strawberry_log(STATUS "Failed to find library ${NAME} at ${CMAKE_CURRENT_SOURCE_DIR}/../${NAME}. Downloading from github at \"https://github.com/StrawberryDan/${NAME}.git\"")
			FetchContent_Declare(Strawberry${NAME}
				GIT_REPOSITORY "https://github.com/StrawberryDan/${NAME}.git"
				GIT_TAG "main")
			FetchContent_MakeAvailable(Strawberry${NAME})
		endif ()
	endforeach ()
endfunction()


function(new_strawberry_tests)
	enable_testing()
	cmake_parse_arguments("LIBRARY" "" "NAME" "TESTS" ${ARGN})

	foreach(FILE ${LIBRARY_TESTS})
		get_filename_component(TEST_NAME ${FILE} NAME_WE)
		new_strawberry_executable(NAME ${LIBRARY_NAME}_TEST_EXECUTABLE_${TEST_NAME} SOURCE ${FILE})
		target_link_libraries(${LIBRARY_NAME}_TEST_EXECUTABLE_${TEST_NAME} PUBLIC ${LIBRARY_NAME})
		add_test(NAME ${LIBRARY_NAME}_TEST_${TEST_NAME} COMMAND ${LIBRARY_NAME}_TEST_EXECUTABLE_${TEST_NAME})
		strawberry_log(STATUS "Created Test ${TEST_NAME} for target ${LIBRARY_NAME} from file ${FILE}")
	endforeach()
endfunction()


