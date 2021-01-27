import { ServiceBroker } from "moleculer";

import { Process } from "@chimera-mud/core"
import { Config } from "./Config"

export class Server extends Process {
  static readonly config: Config = new Config();

  broker: ServiceBroker

  constructor() {
    super()

    this.broker = new ServiceBroker({
      nodeID: "chimera-server"
    })
  }

}