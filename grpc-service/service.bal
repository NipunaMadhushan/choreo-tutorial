import ballerina/grpc;
import ballerinax/metrics.logs as _;
import ballerina/otel as _;
// import ballerinax/jaeger as _;

listener grpc:Listener helloEp = new (8091);

@grpc:Descriptor {value: HELLO_DESC}
service "HelloWorld" on helloEp {

    remote function hello(HelloRequest request) returns HelloResponse|error {
        return {message: "Hello, " + request.name + "!"};
    }
}
