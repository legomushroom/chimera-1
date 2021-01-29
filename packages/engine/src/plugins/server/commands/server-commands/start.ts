import Engine from "../../../../Engine";

module.exports = {
  command: "start",
  desc: "starts the Chimera MUD server",
  handler: function() {
    Engine.startBroker("server")
  }
}