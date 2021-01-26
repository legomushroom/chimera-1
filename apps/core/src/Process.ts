import { Config } from "./Config";

export class Process {
  readonly config: Config;

  constructor() {
    this.config = new Config();
  }

  configure(fun: Function) {
    fun(this.config)
  }
}