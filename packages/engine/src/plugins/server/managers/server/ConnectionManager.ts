import { URL } from "url"
import net from "net"
import Promise from "bluebird";

import Engine from "../../../../Engine";
import Manager from "../../../../Manager";
import { event } from "../../../../Service";
import Connection from "../../Connection";
import { Service  } from "moleculer";

interface IConnectionList {
  [index: string]: Service
}

export default class ConnectionManager extends Manager {
  readonly name = "connection-manager";
  readonly connections: IConnectionList = {}

  created() {
    const url = new URL(<string>Engine.config.get("server.telnet.url"));
    this.settings.hostname = url.hostname;
    this.settings.port = url.port
    this.netServer = net.createServer();

    this.netServer.on("listening", ()=> {
      this.broker.logger.info("waiting for new connections")
    })

    this.netServer.on("connection", (socket: net.Socket) => {
      this.broker.logger.info("received connection")
      const connection = new Connection(socket);
      this.connections[connection.id] = Engine.createService(connection)
    })
  }

  started(): Promise<void> {
    this.netServer.listen(this.settings.port, this.settings.hostname)

    return Promise.resolve();
  }
}