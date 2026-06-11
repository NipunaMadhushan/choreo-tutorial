import ballerina/http;
import ballerina/log;
import ballerinax/metrics.logs as _;
import ballerinax/jaeger as _;
import ballerina/observe as _;

service / on new http:Listener(9092) {

    // This function responds with `string` value `Hello, World!` to HTTP GET requests.
    resource function get greeting() returns string {
        log:printInfo("Received a request for /greeting");
        return "Hello, World!";
    }
}
