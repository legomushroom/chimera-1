import { ServiceMethods, ServiceSchema, ServiceSettingSchema } from "moleculer"
import Promise from "bluebird";

interface IObject extends Object {
  [index: string]: any
}

const METHOD_BLACKLIST = new Set([
  "constructor",
  "__defineGetter__",
  "__defineSetter__",
  "hasOwnProperty",
  "__lookupGetter__",
  "__lookupSetter__",
  "isPrototypeOf",
  "propertyIsEnumerable",
  "toString",
  "valueOf",
  "toLocaleString",
  "created",
  "started"
])

/**
 * Recursively extracts methods from a given objects tree
**/
function getMethods(obj: IObject): Function[] {
  let properties = new Set()
  let currentObj = obj
  do {
    Object.getOwnPropertyNames(currentObj).map(item => properties.add(item))
  } while ((currentObj = Object.getPrototypeOf(currentObj)))

  return <Function[]> [...properties.keys()]
  .filter(item => typeof obj[<string>item] === "function")
  .filter(item => !METHOD_BLACKLIST.has(<string>item))
  .filter(item => !(<string>item).match(/^__/))
  .map(item => obj[<string>item]);
}


/**
 * Extend this class to create new services
**/
export default abstract class Service {
  name!: string
  settings!: ServiceSettingSchema;

  [name: string]: any;

  created(): void {}
  started(): Promise<void> {
    return Promise.resolve()
  }

  __toMoleculerSchema(): ServiceSchema {
    return {
      name: this.name,
      methods: this.__getMethods(),
      created: this.created,
      started: this.started,
      settings: this.settings
    }
  }

  private __getMethods(): ServiceMethods {
    const methods: ServiceMethods = {}
    getMethods(this).forEach(m => methods[m.name] = <(...args: any[]) => any>m);

    return methods
  }
}