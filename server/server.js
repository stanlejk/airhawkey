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
let games = {
    // "from+to": ['id', 'id']
};

io.on("connection", socket => {
    // const id = socket.id;
    let id; // ID received from client
    socket.on("UUID", receivedId => {
        id = receivedId;
        // Add new player to list
        players[id] = { name: "test", open: true };
        console.log(`player ${id} joined`);
        socket.emit("new player", id);
    });
    setInterval(() => {
        socket.emit("test", Date.now());
    }, 1000);
    // Informational request
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
            players[fromId].open = false;
            players[id].open = false;
            const gameId = `${fromId}+${id}`;
            // Remove from invites
            delete invites[gameId];
            // Add to current games
            games[gameId] = [fromId, id];
            // Create new channel
            socket.join(gameId);
            io.sockets.sockets[fromId].join(gameId);
            io.in(gameId).emit("game started", {
                gameId,
                gameInfo: games[gameId],
                starting: Math.random() > 0.5 ? 0 : 1 // Gives random player
            }); // broadcast game info to competing players
            console.log(io.sockets.adapter.rooms[gameId]);
        }
        console.log(accepted);
    });
    // When player moves paddle
    socket.on("move", data => {
        console.log(data);
        let newData = [...data];
        // newData.turn = newData.turn === 1 ? 0 : 1; // Alternate turn and return
        newData[5] = newData[5] === 1 ? 0 : 1;
        // data: {
        //     gameId
        //     gameInfo
        //     pos: { x, y }
        //     acceleration: { x, y }
        //     turn // socket.id of the next hitter
        // }

        io.in(data.gameId).emit("moved", newData);
    });
    // Remove player from list
    socket.on("disconnect", () => {
        // Iterates through invites and removes invites sent to the current player (now non-existent)
        Object.keys(invites).forEach(inviteId => {
            if(inviteId.includes(id)) {
                delete invites[inviteId];
            }
        });
        // Same thing for games
        Object.keys(games).forEach(gameId => {
            if(gameId.includes(id)) {
                delete games[gameId];
            }
        });
        delete players[id];
        console.log(`player ${id} left`);
    });
});

http.listen(app.get("port"), () => console.log("Server is listening"));