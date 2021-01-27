export class Telnet {
  url: string;

  constructor() {
    this.url = process.env.CHIMERA_TELNET_URL || "tcp://localhost:2323"
  }
}
