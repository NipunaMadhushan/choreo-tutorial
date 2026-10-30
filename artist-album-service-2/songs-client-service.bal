import ballerina/http;
import ballerina/log;

const int CLIENT_PORT = 8085;

@display {
    id: "songs-client-service",
    label: "songs_client_service"
}
service /songs on new http:Listener(CLIENT_PORT) {
    private http:Client albumClient;

    function init() returns error? {
        self.albumClient = check new (string `http://localhost:${PORT}/backend`);
    } 

    resource function post albums(@http:Payload Album album) returns string|error? {
        log:printInfo("Adding album: " + album.toJsonString());
        http:Response res = check self.albumClient->/albums.post(album.toJsonString(), { "Content-Type": "application/json" });
        // http:Response res = check self.albumClient->post("/albums", album.toJsonString(), { "Content-Type": "application/json" });
        log:printInfo("Response HTTP status code: " + res.statusCode.toString());
        return res.statusCode == 202 ? "Response HTTP status code: " + res.statusCode.toString() : error("Error occurred while adding album");
    }

    resource function get albums/[string artistName]() returns string|error? {
        log:printInfo("Artist name: " + artistName);
        Album[] artistAlbums = check self.albumClient->/albums/[artistName].get();
        log:printInfo("Artist albums: " + artistAlbums.toJsonString());
        return artistAlbums.toJsonString();
    }

    resource function delete album(@http:Payload Album album) returns string|error? {
        log:printInfo("Deleting album: " + album.toJsonString());
        http:Response res = check self.albumClient->/albums.delete(album.toJsonString(), { "Content-Type": "application/json" });
        log:printInfo("Response HTTP status code: " + res.statusCode.toString());
        return res.statusCode == 202 ? "Response HTTP status code: " + res.statusCode.toString() : error("Error occurred while deleting album");
    }
}
