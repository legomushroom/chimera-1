import mongoose from "mongoose"
import Engine from "../../../Engine";

import { Service } from "../../../Service";


export default class Mongoose extends Service {
  created() {
    this.connect()
  }

  connect() {
    this.logger.debug("connecting to mongo")
    mongoose.connect(Engine.config.get("world.mongo.url") || "mongodb://127.0.0.1/chimera")
  }
}