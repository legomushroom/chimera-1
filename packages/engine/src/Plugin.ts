import fs from "fs";
import path from "path";

import Engine from "./Engine"

export default abstract class Plugin {

  abstract readonly id: string;
  abstract readonly config: object;
  abstract readonly pluginDir: string;

  abstract load(): void;

  start(): void {}
  stop(): void {}

  _load(): void {
    this.loadCommands();
    this.load()
  }

  private loadCommands() {
    const dir = path.join(this.pluginDir, "commands")
    if (fs.existsSync(dir)) {
      Engine.command.commandDir(dir)
    }
  }
}
