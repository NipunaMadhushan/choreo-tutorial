import ballerina/http;
import ballerinax/newrelic as _;
import ballerina/log;
import ballerina/io;
import ballerina/lang.runtime;

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
        log:printInfo("Response HTTP status code: " + res.statusCode.toString());
        return res.statusCode == 202 ? "Response HTTP status code: " + res.statusCode.toString() : error("Error occurred while adding album");
    }

    resource function get albums/[string artistName]() returns string|error? {
        io:println("Artist name: " + artistName);
        Album[] artistAlbums = check self.albumClient->/albums/[artistName].get();
        foreach int i in 0...9 {
            runtime:sleep(1000);
        }
        io:println("Artist albums: " + artistAlbums.toJsonString());
        return artistAlbums.toJsonString();
    }
}

// curl -X POST http://localhost:8090/songs/albums -H "Content-Type: application/json" -d '{"title": "Sarah Vaughan and Clifford Brown", "artist": "Sarah Vaughan"}'
// curl -X GET http://localhost:8090/songs/albums/Sarah%20Vaughan

// curl -X POST http://localhost:8090/songs/albums -H "Content-Type: application/json" -d '{"title": "Title", "artist": "Artist"}'
// curl -X GET http://localhost:8090/songs/albums/Artist


