import Plugin from "../../Plugin";

export default class Server extends Plugin {
  readonly pluginDir = __dirname
  readonly id =  "server";
  readonly config = {
    telnet: {
      url: "tcp://127.0.0.1:2324"
    }
  }

  load(): void {}
}