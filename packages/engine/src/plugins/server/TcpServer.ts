import net from "net"
import { ServiceBroker } from "moleculer";
import { URL } from "url";

import Engine from "../../Engine";

export default class TcpServer {
  readonly broker: ServiceBroker

  constructor() {
    this.broker = new ServiceBroker({
      nodeID: "chimera-server",
      ...Engine.config.get("moleculer"),
      started(broker) {
        const url = new URL(<string>Engine.config.get("server.telnet.url"));
        const netServer = net.createServer();
        netServer.on("listening", ()=> broker.logger.info("waiting for new connections"))
        netServer.on("connection", (socket) => {
          broker.logger.info("received connection")
        })

        broker.logger.info(`starting tcp listener on '${url.hostname}:${url.port}'`);
        netServer.listen(parseInt(url.port), url.hostname);
      }
    })
  }

  start() {
    this.broker.start()
  }
}