message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
message(STATUS "Build method: ${CMAKE_BUILD_METHOD}")

if(CMAKE_BUILD_METHOD STREQUAL "Local")
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        target_compile_options(
            ${PROJECT_NAME} 
            PRIVATE 
                -g
                -O0
                #-fno-omit-frame-pointer
                #-fsanitize=address
                #-fsanitize=undefined
                #-fno-optimize-sibling-calls
                #-fsanitize=thread
            )
        target_link_options(${PROJECT_NAME} PRIVATE 
            -DEBUG
            -Wall
            #-fsanitize=address
            #-fsanitize=undefined
            #-fsanitize=thread

        )
    elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
        include(CheckIPOSupported)
        check_ipo_supported(RESULT result OUTPUT output)
        if(result)
            set_target_properties(${PROJECT_NAME} PROPERTIES INTERPROCEDURAL_OPTIMIZATION TRUE)
        else()
            message(WARNING "IPO is not supported: ${output}")
        endif()

        target_compile_options(${PROJECT_NAME} 
            PRIVATE 
            -O3  
            -DNDEBUG
            -march=native
        )
        
        #TODO: Add msvc
    endif()
elseif(CMAKE_BUILD_METHOD STREQUAL "Docker")
    find_program(DOCKER_EXEC docker)
    if(NOT DOCKER_EXEC)
        MESSAGE(FATAL "DONT FIND DOCKER")
    endif()
    message(STATUS "Executable path: ${DOCKER_EXEC}")
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        add_custom_target(docker-build-debug
            COMMAND ${DOCKER_EXEC} build 
                --build-arg BUILD_TYPE=Debug 
                -t ${PROJECT_NAME}:debug 
                -f docker/Dockerfile 
                .
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            COMMENT "Building Docker Debug image"
            VERBATIM
        )
    endif()

endif()
#TODO: add docker build