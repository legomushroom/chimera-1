import net from "net"
import { ServiceBroker } from "moleculer";
import { URL } from "url";

import Engine from "../../Engine";
import Connection from "./Connection";

export default class TcpServer {
  constructor() {
    Engine.broker = new ServiceBroker({
      nodeID: "chimera-server",
      ...Engine.config.get("moleculer"),
      started(broker) {
        const url = new URL(<string>Engine.config.get("server.telnet.url"));
        const netServer = net.createServer();

        netServer.on("listening", ()=> broker.logger.info("waiting for new connections"))

        netServer.on("connection", (socket) => {
          broker.logger.info("received connection")
          const connection = new Connection(socket);
          console.log(connection.__toMoleculerSchema());
          Engine.createService(connection)
        })

        broker.logger.info(`starting tcp listener on '${url.hostname}:${url.port}'`);
        netServer.listen(parseInt(url.port), url.hostname);
      }
    })
  }

  start() {
    Engine.broker.start()
  }
}