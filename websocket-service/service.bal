import ballerina/log;
import ballerina/websocket;
import ballerina/observe as _;
import ballerina/metrics.logs as _;
import ballerina/otel as _;
// import ballerinax/jaeger as _;

listener websocket:Listener chatEp = new (8092);

service /chat on chatEp {

    // The upgrade resource: accepts the HTTP -> WebSocket handshake and
    // hands off the connection to a fresh EchoService instance per client.
    resource function get .() returns websocket:Service|websocket:UpgradeError {
        return new EchoService();
    }
}

service class EchoService {
    *websocket:Service;

    // Fired once, right after the WebSocket handshake completes.
    remote function onOpen(websocket:Caller caller) returns error? {
        log:printInfo("Client connected: " + caller.getConnectionId());
        check caller->writeMessage("Welcome! Send me a message and I'll echo it back.");
    }

    // Fired every time this client sends a text message.
    remote function onMessage(websocket:Caller caller, string chatMessage) returns error? {
        log:printInfo("Received: " + chatMessage);
        check caller->writeMessage("Echo: " + chatMessage);
    }

    // Fired when the client disconnects (close frame received).
    remote function onClose(websocket:Caller caller, int statusCode, string reason) returns error? {
        log:printInfo(string `Client disconnected. Status: ${statusCode}, reason: ${reason}`);
    }

    // Fired if something goes wrong on the connection.
    remote function onError(websocket:Caller caller, error err) returns error? {
        log:printError("WebSocket error occurred", err);
    }
}
