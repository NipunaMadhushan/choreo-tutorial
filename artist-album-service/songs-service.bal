import ballerina/http;
import ballerina/io;

const int PORT = 8091;

type Album readonly & record {
    string title;
    string artist;
};

@display {
    id: "songs-backend",
    label: "songs_backend"
}
service /backend on new http:Listener(PORT) {
    private Album[] albums = [];

    resource function post albums(@http:Payload Album album) returns error? {
        // check caller->respond(http:ACCEPTED);
        self.albums.push(album);
    }

    resource function get albums/[string artistName]() returns Album[]|error? {
        io:println("artistName: " + artistName);
        Album[] artistAlbums = self.albums.filter(function (Album album) returns boolean {
            return album.artist == artistName;
        });

        // json payload = artistAlbums.toJson();

        // http:Response response = new;
        // response.setJsonPayload(payload);

        return artistAlbums;
    }
}
