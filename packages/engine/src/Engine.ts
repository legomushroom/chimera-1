import yargs from "yargs"
import config from "config"

import Plugin  from "./Plugin"
import Server from "./plugins/server/Server";
import { ServiceBroker } from "moleculer";
import Service from "./Service";

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

  static registerPlugins(plugins: Plugin[]): void {
    plugins.forEach(plugin => this.registerPlugin(plugin))
  }

  static registerPlugin(plugin: Plugin): void {
    this.plugins[plugin.id] = plugin
  }

  config: object;

  constructor() {
    this.config = DEFAULT_CONFIG;
    Engine.registerPlugins([
      new Server(),
    ])
  }

  start() {
    this.loadConfig();
    this.loadPlugins();
    Engine.command.demandCommand().argv;
  }

  private loadPlugins(): void {
    Object.values(Engine.plugins).forEach((plugin) => {
      Engine.config.util.setModuleDefaults(plugin.id, plugin.config)
      plugin._load()
    });
  }

  private loadConfig() {
    Object.keys(DEFAULT_CONFIG).forEach((key) => {
      Engine.config.util.setModuleDefaults(key, DEFAULT_CONFIG[key])
    })
  }
}