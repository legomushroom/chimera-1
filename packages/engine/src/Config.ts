import dotenv from "dotenv"
import { BrokerOptions, LogLevelConfig } from "moleculer"

dotenv.config()

export default class Config {
  [index: string]: Function

  get(path: string): any {
    if (this[path]) {
      return this[path]()
    }
    return process.env[`CHIMERA_${path.toUpperCase().replace(".", "_")}`]
  }

  private moleculer(): BrokerOptions {
    return {
      nodeID: `chimera-process-${Math.random().toString(36).substring(7)}`,
      transporter: this.get("moleculer.transporter") || "https://localhost:4222",
      logLevel: <LogLevelConfig><unknown>this.get("moleculer.log.level") || "debug"
    }
  }
}