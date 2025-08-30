#include <iostream>
#include <fmt/base.h>
#include <algorithm>
#include <filesystem>

// libs
#include "../include/dotenv-cpp.hpp"

// local libs
#include "lib.cpp"


int main() {
    fmt::print("Filepath {}\n", std::filesystem::current_path().c_str());
    dotenv::init(".env");
    auto name = std::getenv("NAME");
    firewolf::hello::say_hello(name);
    return 0;
}