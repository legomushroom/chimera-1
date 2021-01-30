import { event, Service } from "../../Service";

export class Session extends Service {
  constructor(id: string) {
    super()
    this.settings.id = id
    this.name = `world.sessions.${id}`
  }

  @event((svc) => `connections.input.${svc.settings.id}`)
  handleInput(input: string) {
    console.log(input)
  }

}