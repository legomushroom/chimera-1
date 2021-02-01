import path from "path"

import { Session } from "./Session";

export default abstract class App {
  static readonly id: string;
  static appDir: string;

  readonly session: Session;

  constructor(session: Session) {
    this.session = session;
  }

  abstract start(): Promise<void>
}