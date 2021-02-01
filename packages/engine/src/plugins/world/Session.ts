import { event, Service } from "../../Service";

export class Session extends Service {
  constructor(model: any) {
    super()
    this.settings.id = model.uuid
    this.name = `world.sessions.${model.uuid}`
    this.model = model
  }

  @event((svc) => `connections.input.${svc.settings.id}`)
  handleInput(input: string) {
    console.log(input)
  }

}