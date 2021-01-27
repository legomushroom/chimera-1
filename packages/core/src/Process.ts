import { Service, ServiceBroker} from "moleculer";

import { Config } from "./Config";

export abstract class Process {
  protected static readonly config: Config;

  get config(): Config {
    return (this.constructor as any).config
  }
  broker!: ServiceBroker;

  constructor() {
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