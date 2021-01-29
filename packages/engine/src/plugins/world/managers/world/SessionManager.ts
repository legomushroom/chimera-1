import { Service as MoleculerService } from "moleculer";

import Manager from "../../../../Manager"
import { event } from "../../../../Service"

interface ISessionList {
  [index:string]: MoleculerService
}

export default class SessionManager extends Manager {
  name = "world.session-manager"
  readonly sessions: ISessionList = {}

  @event("connections.started")
  createSession(id: string) {
    this.logger.debug(`new connection received with id '${id}'`)
  }

  created() {
  }
}