import Core from "@chimera-mud/core"
import { Telnet } from "./config/Telnet"

export class Config extends Core.Config {
  telnet: Telnet;

  constructor() {
    super()
    this.telnet = new Telnet();
  }
}
