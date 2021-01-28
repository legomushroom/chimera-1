import Instance from "../../Instance";

module.exports = {
  command: "start",
  desc: "starts the Chimera MUD world instance",
  handler: function() {
    const instance = new Instance();
    instance.start();
  }
}