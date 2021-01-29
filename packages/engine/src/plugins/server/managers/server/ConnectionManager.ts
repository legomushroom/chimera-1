import { URL } from "url"
import net from "net"

import Engine from "../../../../Engine";
import Manager from "../../../../Manager";
import Connection from "../../Connection";

export default class ConnectionManager extends Manager {
  name = "connection-manager";

  created() {
    const url = new URL(<string>Engine.config.get("server.telnet.url"));
    this.settings.hostname = url.hostname;
    this.settings.port = url.port
    this.netServer = net.createServer();

    this.netServer.on("listening", ()=> this.broker.logger.info("waiting for new connections"))
    this.netServer.on("connection", (socket: net.Socket) => {
      this.broker.logger.info("received connection")
      const connection = new Connection(socket);
      Engine.createService(connection)
    })
  }
}