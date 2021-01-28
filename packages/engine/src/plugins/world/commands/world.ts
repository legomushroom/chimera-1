import yargs from "yargs"

module.exports = {
  name: "world <cmd>",
  desc: "controls the Chimera MUD world instance",
  builder: function(cmd: yargs.Argv) {
    return cmd.commandDir("./world-commands");
  }
}