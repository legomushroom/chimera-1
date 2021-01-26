import { ServiceBroker } from "moleculer";

import { Process } from "@chimera-mud/core"
import { Config } from "./Config"

export class Server extends Process{
  config: Config
  broker: ServiceBroker

  constructor() {
    super()
    this.config = new Config();

    this.broker = new ServiceBroker({
      nodeID: "chimera-server"
    })
  }

}