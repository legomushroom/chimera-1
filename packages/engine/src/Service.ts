import { ServiceMethods, ServiceSchema, ServiceSettingSchema } from "moleculer"

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
}

export default abstract class Service {
  name!: string
  settings!: ServiceSettingSchema;

  [name: string]: any;

  __toMoleculerSchema(): ServiceSchema {
    return {
      name: this.name,
      methods: this.__getMethods()
    }
  }

  private __getMethods(): ServiceMethods {
    const methods: ServiceMethods = {}
    getMethods(this).forEach(m => {
      methods[m.name] = <(...args: any[]) => any>m
      );

    return methods
  }
}