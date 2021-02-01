import Promise from "bluebird"

import App from "../App"

export default class MotdApp extends App {
  static readonly id = "motd"
  readonly appDir = __dirname;

  start(): Promise<void> {
    return Promise.resolve()
  }
}