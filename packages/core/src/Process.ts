import { ServiceBroker} from "moleculer";

import { Config } from "./Config";

export class Process {
  static readonly config: Config = new Config();
  readonly config: Config;
  broker!: ServiceBroker;

  constructor() {
    this.config = (this.constructor as any).config
  }

  configure(fun: Function) {
    fun(this.config);
  }

  start() {
    this.broker = new ServiceBroker(this.config.moleculer)
  }
}