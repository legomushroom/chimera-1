import Service from "../../Service";
import net from "net";
import { v4 as uuidV4 } from "uuid";

import Promise from "bluebird";

import Engine from "../../Engine";

export default class Connection extends Service {
  constructor(socket: net.Socket) {
    super()
    const uuid = uuidV4();

    this.name = `server.connections.${uuid}`;

    this.settings = {
      socket: socket,
      $secureSettings: ["socket"],
      remoteAddress: socket.remoteAddress,
      uuid
    }
  }

  created() {
    this.socket = this.settings.socket
    this.logger.info(`received connection from ${this.socket.remoteAddress}`)
    this.socket.on("data", this.handle)
  }

  handle(buffer: Buffer) {
    console.log(buffer)
  }

}