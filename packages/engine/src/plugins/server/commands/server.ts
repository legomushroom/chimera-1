import yargs from "yargs";

module.exports = {
  name: "server <cmd>",
  desc: "controls the Chimera MUD tcp server",
  builder: function(cmd: yargs.Argv) {
    return cmd.commandDir("./server-commands");
  }
}