import Promise from "bluebird"
import path from "path"

import {IAppList} from "./AppManager"
import Manager from "../../../../Manager";
import { glob } from "glob";
import Engine from "../../../../Engine";

interface ITemplateFileList {
  [index: string]: string;
}

export default class TemplateManager extends Manager {
  name = "world.template-manager"
  readonly templateFiles: ITemplateFileList = {}

  started(): Promise<void> {
    return <Promise<void>>this.broker.waitForServices("world.app-manager")
      .then(() => {
        return <Promise<IAppList>>this.broker.call("world.app-manager.getApps")
      })
      .then((apps: IAppList) => {
        Object.values(apps).forEach((app) => {
          this.logger.info(`loading templates for '${app.id}'`)
          const templatePrefix = `apps/${app.id}/templates`
          Object.values(Engine.plugins).forEach((plugin) => {
            const globPattern = path.join(plugin.pluginDir, templatePrefix, "*.hbs")
            glob.sync(globPattern).forEach((file) => {
              const templateName = `${app.id}/${path.basename(file).replace(".hbs", "")}`
              this.logger.debug(`found '${templateName}' in plugin ${plugin.id}'`)
              this.templateFiles[templateName] = file
            })
          })
        })
      })
  }
}