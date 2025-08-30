#include "../include/lib.hpp"

void firewolf::hello::say_hello(const std::string& name) {
    fmt::print("Hello, {}!\n", name);
}