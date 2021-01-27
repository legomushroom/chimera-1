import { ServiceBroker } from "moleculer";

export class Moleculer {
  nodeID: string;
  transporter: String;
  started!: (broker: ServiceBroker) => void;
  stopped!: (broker: ServiceBroker) => void;

  constructor() {
    this.nodeID = <string>process.env.CHIMERA_NODE_ID;
    this.transporter = process.env.CHIMERA_TRANSPORTER || "nats://localhost:4222";
  }
}