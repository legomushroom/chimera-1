import Engine from "../../../../Engine"

module.exports = {
  command: "start",
  desc: "starts the Chimera MUD world instance",
  handler: function() {
    Engine.startBroker("world")
  }
}