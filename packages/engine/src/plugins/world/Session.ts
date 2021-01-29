import { Service } from "../../Service";

export class Session extends Service {
  constructor(id: string) {
    super()
    this.id = id
    this.name = `world.sessions.${id}`
  }
}