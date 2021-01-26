"use strict";
const { ServiceBroker } = require("moleculer");

class Process {
  constructor() {
    const settings = this.constructor.settings;

    this.broker = new ServiceBroker({
      nodeID: this.constructor.name,
      transporter: settings.transporter,
    });
  }

  configure(fun) {
    fun(this);
  }

  start() {}
}

module.exports = { Process };
