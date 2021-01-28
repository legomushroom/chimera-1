import { ServiceBroker } from "moleculer";
import Engine from "../../Engine";

export default class Instance {
  constructor() {
    Engine.broker = new ServiceBroker({
      nodeID: "chimera-world",
      ...Engine.config.get("moleculer")
    })
  }

  start() {
    Engine.broker.start()
  }
}