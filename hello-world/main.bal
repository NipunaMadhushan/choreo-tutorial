import ballerina/io;
import ballerina/log;

configurable string greeting = "Hello";

public function main(string name = "World") {
    io:println(string `${greeting}, ${name}!`);
    log:printInfo("Greeting sent", greeting = greeting, name = name);

    error err = error("Simulated automation failure", name = name);
    log:printError("Automation failed", 'error = err);
    return err;
}
