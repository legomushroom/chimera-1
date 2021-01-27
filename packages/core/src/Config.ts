import { Moleculer } from "./config/Moleculer";

export class Config {
  moleculer: Moleculer;

  constructor() {
    this.moleculer = new Moleculer();
  }
}
