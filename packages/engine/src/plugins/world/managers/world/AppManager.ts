import { glob } from "glob";
import { Context } from "moleculer";
import path from "path"

import Engine from "../../../../Engine";
import Manager from "../../../../Manager";
import { action } from "../../../../Service";
import { App } from "../../World";

export interface IAppList {
  [index: string]: typeof App
}

export default class AppManager extends Manager {
  name = "world.app-manager"
  readonly apps: IAppList = {}

  created() {
    this.logger.info("loading apps")
    Object.values(Engine.plugins).forEach((plugin) => {
      glob.sync(path.join(plugin.pluginDir, "apps", "*.js")).forEach((file) => {
        const app = require(file).default
        this.logger.debug(`loading app '${app.id}'`)
        app.appDir = path.dirname(file)
        this.apps[app.id] = app
      })
    })
  }

  @action("getApps")
  getApps(ctx: Context): Promise<IAppList> {
    return Promise.resolve(this.apps)
  }
}