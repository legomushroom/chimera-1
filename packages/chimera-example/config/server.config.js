const { Server } = require("@chimera/server");

const server = new Server();

server.configure((config) => {
  config.telnet.host = process.env.CHIMERA_TELNET_HOST || "localhost";
  config.telnet.port = process.env.CHIMERA_TELNET_PORT || 2323;
});

server.start();
