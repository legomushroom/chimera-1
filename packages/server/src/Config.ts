import { Config as CoreConfig } from "@chimera-mud/core"
import { Telnet } from "./config/Telnet"

export class Config extends CoreConfig {
  telnet: Telnet;

  constructor() {
    super()
    this.telnet = new Telnet();
  }
}
