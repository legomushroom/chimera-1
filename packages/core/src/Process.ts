import { Service, ServiceBroker} from "moleculer";

import { Config } from "./Config";

export abstract class Process {
  static readonly config: Config = new Config();
  readonly config: Config;
  broker!: ServiceBroker;

  constructor() {
    this.config = (this.constructor as any).config
    this.config.moleculer.started = this.started;
    this.config.moleculer.stopped = this.stopped;
  }

  configure(fun: Function) {
    fun(this.config);
  }

  start(): Promise<void> {
    this.broker = new ServiceBroker(this.config.moleculer)
    return this.broker.start()
  }

  abstract started(broker: ServiceBroker): void
  abstract stopped(broker: ServiceBroker): void
}