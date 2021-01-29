import yargs from "yargs"
import config from "config"
import path from "path"
import glob from "glob"
import fs from "fs"

import Plugin  from "./Plugin"
import Server from "./plugins/server/Server";
import World from "./plugins/world/World";
import { BrokerOptions, ServiceBroker } from "moleculer";
import Service from "./Service";
import Manager from "./Manager";

interface IPluginList {
  [index: string]: Plugin
}

interface IDefaultConfig {
  [index: string]: Object
}

const DEFAULT_CONFIG: IDefaultConfig = {
  moleculer: {
    transporter: "nats://127.0.0.1:4222"
  }
}
export default class Engine {
  static readonly command: yargs.Argv = yargs(process.argv.slice(2))
  static readonly plugins: IPluginList = {};
  static readonly config: config.IConfig = config;
  static broker: ServiceBroker;

  static createService(service: Service) {
    this.broker.createService(service.__toMoleculerSchema())
  }

  static bootstrap(): typeof Engine {
    this.registerPlugins([
      new Server(),
      new World()
    ])
    this.loadPlugins();
    this.loadConfig();

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
      ...config.get("moleculer"),
      ...options
    })
    this.broker.start()
      .then(() => {
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

  private static loadConfig() {
    Object.keys(DEFAULT_CONFIG)
    .forEach(
      (key) => this.config.util.setModuleDefaults(<string>key, DEFAULT_CONFIG[<string>key])
     )
  }

  private static loadPlugins(): void {
    Object.values(this.plugins).forEach((plugin) => {
      this.loadPlugin(plugin)
    });
  }

  private static loadPlugin(plugin: Plugin) {
    this.config.util.setModuleDefaults(plugin.id, plugin.config)
    this.loadCommands(plugin)
    plugin._load();
  }
}