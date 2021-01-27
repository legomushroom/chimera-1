export class Moleculer {
  nodeID: string;
  transporter: String;

  constructor() {
    this.nodeID = <string>process.env.CHIMERA_NODE_ID;
    this.transporter = process.env.CHIMERA_TRANSPORTER || "nats://localhost:4222";
  }

}