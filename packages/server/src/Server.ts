import { ServiceBroker } from "moleculer";

import { URL } from "url";
import net from "net";

import { Process } from "@chimera-mud/core"
import { Config } from "./Config"

export class Server extends Process {
  protected static readonly config: Config = new Config();

  started(broker: ServiceBroker): void {
    const telnetUrl= new URL(Server.config.telnet.url);

    const listener = net.createServer()

    listener.on("ready", () => {
      broker.logger.info("waiting for connections")
    });

    listener.on("connect", (socket) => {
      broker.logger.info("received new connection")
    })


    broker.logger.info(`starting tcp server on ${telnetUrl.hostname}:${telnetUrl.port}`);
    listener.listen(parseInt(telnetUrl.port), telnetUrl.hostname);
  }

  stopped(_: ServiceBroker): void {
  }
}