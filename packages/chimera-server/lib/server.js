"use strict";

const { Process } = require("@chimera/core");

class Server extends Process {
  static settings = {
    telnet: {
      url: process.env.CHIMERA_TELNET_URL || "tcp://localhost:2323",
    },
    transporter: process.env.CHIMERA_NATS_URL || "nats://localhost:4222",
  };

  static name = "chimera-server";
}

module.exports = { Server };
