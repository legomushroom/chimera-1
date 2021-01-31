import yargs from "yargs"
import path from "path"
import fs from "fs"
import dotenv from "dotenv"

import Config from "./Config"
import Plugin  from "./Plugin"
import Server from "./plugins/server/Server";
import World from "./plugins/world/World";
import { BrokerOptions, ServiceBroker, Service as MoleculerService } from "moleculer";
import { Service } from "./Service";

const result = dotenv.config();

console.log(result)

interface IPluginList {
  [index: string]: Plugin
}

interface IDefaultConfig {
  [index: string]: Object
}

export default class Engine {
  static readonly command: yargs.Argv = yargs(process.argv.slice(2))
  static readonly plugins: IPluginList = {};
  static readonly config: Config = new Config();
  static broker: ServiceBroker;

  static createService(service: Service): MoleculerService {
    return this.broker.createService(service.__toMoleculerSchema())
  }

  static bootstrap(): typeof Engine {
    this.registerPlugins([
      new Server(),
      new World()
    ])
    this.loadPlugins();

    return this
  }

  static argv() {
    this.command.demandCommand().argv;
  }

  static registerPlugins(plugins: Plugin[]): void {
    plugins.forEach(plugin => this.registerPlugin(plugin))
  }

  static registerPlugin(plugin: Plugin): void {
    this.plugins[plugin.id] = plugin
  }

  static startBroker(name: string, options: BrokerOptions = {}) {
    this.bootstrap()
    this.broker = new ServiceBroker({
      nodeID: `chimera-${name}`,
      ...<BrokerOptions>this.config.get("moleculer"),
      ...options
    })
    this.broker.start()
      .then(() => {
        Object.values(this.plugins[name].managers).forEach((manager) => {
          this.broker.createService(manager.__toMoleculerSchema())
        })
      })
  }

  static loadManagersInDir(dir: string) {

  }

  private static loadCommands(plugin: Plugin) {
    const dir = path.join(plugin.pluginDir, "commands")
    if (fs.existsSync(dir)) {
      this.command.commandDir(dir)
    }
  }

  private static loadPlugins(): void {
    Object.values(this.plugins).forEach((plugin) => {
      this.loadPlugin(plugin)
    });
  }

  private static loadPlugin(plugin: Plugin) {
    this.loadCommands(plugin)
    plugin._load();
  }
}