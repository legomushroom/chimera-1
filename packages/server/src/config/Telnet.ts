export class Telnet {
  url: string;

  constructor() {
    this.url = process.env.CHIMERA_TELNET_URL || "tcp://127.0.0.1:2323"
  }
}
