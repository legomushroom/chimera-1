import mongoose, { FilterQuery } from "mongoose"
import Promise from "bluebird"

import Engine from "../../../Engine";
import { action, Service } from "../../../Service";
import { Context } from "moleculer";


export default class Mongoose extends Service {
  model?: mongoose.Model<any>
  modelSchema?: mongoose.Schema
  modelName?: string

  created() {
    this.connect()
  }

  started(): Promise<void> {
    this.model = mongoose.model(<string>this.modelName, this.modelSchema)
    return Promise.resolve();
  }

  connect() {
    if (mongoose.connection.readyState === 0) {
      this.logger.debug("connecting to mongo")
      mongoose.connect(Engine.config.get("world.mongo.url") || "mongodb://127.0.0.1/chimera")
    }
  }

  @action("find")
  find(ctx: Context): Promise<mongoose.Model<any>[]> {
    return new Promise((resolve) => {
      this.model?.find(<any>ctx.params, (records) => {
        resolve(records)
      })
    })
  }

  @action("create")
  create(ctx: Context): Promise<any> {
    return <Promise<any>> this.model?.create(<any>ctx.params)
  }
}