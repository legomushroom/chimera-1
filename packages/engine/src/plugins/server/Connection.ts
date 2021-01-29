import { Service } from "../../Service";
import net from "net";
import { v4 as uuidV4 } from "uuid";
import Promise from "bluebird";

export default class Connection extends Service {
  readonly id: string;

  constructor(socket: net.Socket) {
    super()
    this.id = uuidV4();

    this.name = `server.connections.${this.id}`;

    this.settings = {
      socket: socket,
      $secureSettings: ["socket"],
      remoteAddress: socket.remoteAddress,
      uuid: this.id
    }
  }

  created() {
    this.socket = this.settings.socket
    this.logger.info(`received connection from ${this.socket.remoteAddress}`)
    this.socket.on("data", this.handle)
  }

  started(): Promise<void> {
    return this.emit("connections.created", this.settings.uuid)
  }

  handle(buffer: Buffer) {
    this.logger.info(`received ${buffer.length} bytes`)
  }

}