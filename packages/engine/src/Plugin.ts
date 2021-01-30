import fs from "fs";
import path from "path";
import glob from "glob"

import Manager from "./Manager"

interface IManagerList {
  [index: string]: Manager
}

export default abstract class Plugin {
  readonly managers: IManagerList = {}

  abstract readonly id: string;
  abstract readonly pluginDir: string;

  _load() {
    this.loadManagers();
  }

  private loadManagers() {
    const dir = path.join(this.pluginDir, "managers")
    if (fs.existsSync(dir)) {
      this.loadManagersInDir(dir)
      this.loadManagersInDir(path.join(dir, this.id))
    }
  }

  private loadManagersInDir(dir: string) {
    glob.sync(path.join(dir, "*.js")).forEach((file) => {
      const managerConstructor = <typeof Manager>require(file).default;
      const manager: Manager = new managerConstructor()
      this.managers[manager.name] = manager;
    })
  }
}
