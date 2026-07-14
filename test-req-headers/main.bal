import ballerina/http;
import ballerina/io;


service / on new http:Listener(9092) {

    resource function get testHeaders(http:Caller caller, http:Request req) returns error? {
        io:println("Received a request for /testHeaders");
        string[] headerNames = req.getHeaderNames();
        foreach string headerName in headerNames {
            string|http:HeaderNotFoundError headerValue = req.getHeader(headerName);
            if headerValue is string {
                io:println(headerName, ": ", headerValue);
            }
        }
        check caller->respond("Header processed successfully");
    }
}