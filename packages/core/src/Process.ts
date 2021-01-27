import { Config } from "./Config";

export class Process {
  static readonly config: Config = new Config();
  readonly config: Config;

  constructor() {
    this.config = (this.constructor as any).config
  }

  configure(fun: Function) {
  }
}