import { Server, ServerConfig } from "@chimera-mud/engine";

import baseConfig from "./base.config"

const server = new Server();

server.configure((config: ServerConfig) => {
  baseConfig(config)
  config.moleculer.nodeID = "chimera-server"
})

server.start();


