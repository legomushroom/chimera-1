import { Service as MoleculerService } from "moleculer";

import Engine from "../../../../Engine";
import Manager from "../../../../Manager"
import { event } from "../../../../Service"
import Mongoose from "../../service_mixins/Mongoose";
import { Session } from "../../Session";

interface ISessionList {
  [index:string]: MoleculerService
}

export default class SessionManager extends Manager {
  name = "world.session-manager"
  mixins = [ new Mongoose() ]
  readonly sessions: ISessionList = {}

  @event("connections.started")
  createSession(id: string) {
    this.logger.degbug("received conenction event, checking to see if session was already registered")
    this.actions.find*

    this.logger.debug(`new connection received with id '${id}', waiting for ready`)
    const connecitonName = `server.connections.${id}`
    this.broker.waitForServices(connecitonName)
      .then(() => {
        this.sessions[id] = Engine.createService(new Session(id))
      })
  }

  created() {
  }
}