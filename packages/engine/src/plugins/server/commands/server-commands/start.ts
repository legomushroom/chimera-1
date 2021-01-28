import TcpServer from "../../TcpServer";

module.exports = {
  command: "start",
  desc: "starts the Chimera MUD server",
  handler: function() {
    const server = new TcpServer();
    server.start();
  }
}