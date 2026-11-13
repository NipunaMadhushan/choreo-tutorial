import ballerina/http;
import ballerina/io;
import ballerina/log;
import ballerina/lang.runtime;

configurable string greeting = "Hello";
configurable string apiBaseUrl = "https://httpbin.org";

// Create the client once and reuse it.
final http:Client apiClient = check new (apiBaseUrl, timeout = 30);

type GreetingPayload record {|
    string greeting;
    string name;
|};

public function main(string name = "World") returns error? {
    io:println(string `${greeting}, ${name}!`);
    log:printInfo("Greeting sent", greeting = greeting, name = name);

    // GET: the response is bound straight to json.
    json getResponse = check apiClient->get("/get", {"Accept": "application/json"});
    log:printInfo("GET call succeeded", response = getResponse);

    // POST: send a typed payload.
    GreetingPayload payload = {greeting, name};
    json postResponse = check apiClient->post("/post", payload);
    log:printInfo("POST call succeeded", response = postResponse);

    // Wait for the OTel batch exporter (~5s interval) to flush spans before exit.
    runtime:sleep(15);
}
