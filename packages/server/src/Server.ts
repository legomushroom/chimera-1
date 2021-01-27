import { ServiceBroker } from "moleculer";

import { Process } from "@chimera-mud/core"
import { Config } from "./Config"

export class Server extends Process {
  static readonly config: Config = new Config();
}