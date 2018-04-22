const express = require("express");
const app = express();
const http = require("http").Server(app);
const io = require("socket.io")(http);

app.set("port", process.env.PORT);
app.use(express.static("."));

let players = {
    // "id-here": {
    //     name: "Victor",
    //     open: true
    // }
};
let invites = {
    // "from+to": {
    //     from: "id",
    //     to: "id"
    // }
};
let games = [
    // [player id, player id]
    // "from+to": ['id', 'id']
];

io.on("connection", socket => {
    const id = socket.id;
    players[id] = { name: "test", open: true };
    console.log(`player ${id} joined`);
    socket.on("get players", () => {
        socket.emit("got players", players);
    });
    // socket.on("join game", () => {
        
    // });
    socket.on("request game", targetId => {
        // If target player is open, send invite
        if(players[targetId].open) {
            invites[`${id}+${targetId}`] = { from: id, to: targetId };
            socket.broadcast.to(targetId).emit("game invite", { from: id });
        }
        else {
            // If player isn't open, notify
        }
    });
    socket.on("game invite response", ({ fromId, accepted }) => {
        if(accepted) {
            const channelId = `${fromId}+${id}`;
            // Remove from invites
            delete invites[channelId];
            // Create new channel
            socket.join(channelId);
            io.sockets.sockets[fromId].join(channelId);
            console.log(io.sockets.adapter.rooms[channelId]);
        }
        console.log(accepted);
    });
    socket.on("disconnect", () => {
        delete players[id];
        console.log(`player ${id} left`);
    });
});

http.listen(app.get("port"), () => console.log("Server is listening"));