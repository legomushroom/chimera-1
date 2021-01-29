import "reflect-metadata"

import { ServiceMethods, ServiceSchema, ServiceSettingSchema, EventSchema, ActionHandler, ServiceEvent, ServiceEvents } from "moleculer"
import Promise from "bluebird";

interface IObject extends Object {
  [index: string]: any
}

interface IEventList {
  [index: string]: ServiceEvent
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

const EVENT_METADATA_KEY = Symbol("events");

/**
 * Recursively extracts methods from a given objects tree
**/
function getMethods(obj: IObject, events: IEventList): ServiceMethods {
  let properties = new Set()
  let currentObj = obj
  let eventList = new Set(Object.keys(events))
  do {
    Object.getOwnPropertyNames(currentObj).map(item => properties.add(item))
  } while ((currentObj = Object.getPrototypeOf(currentObj)))

  const methods: ServiceMethods = {};

  [...properties.keys()]
    .filter(item => typeof obj[<string>item] === "function")
    .filter(item => !METHOD_BLACKLIST.has(<string>item))
    .filter(item => !eventList.has(<string>item))
    .filter(item => !(<string>item).match(/^__/))
    .forEach(item => methods[<string>item] = obj[<string>item])

  return methods
}

function getEvents(obj: IObject): IEventList {
  const events: IEventList = {}
  return Reflect.getMetadata(EVENT_METADATA_KEY, obj.__proto__)
}

function getSchema(obj: IObject): ServiceSchema {
  const rawEvents = getEvents(obj)
  const methods = getMethods(obj, rawEvents)

  const events: ServiceEvents = {}

  Object.values(rawEvents).forEach(event => events[<string>event.name] = event)

  return {
    name: obj.name,
    settings: obj.settings || {},
    created: obj.created,
    started: obj.started,
    events,
    methods
  }
}


/**
 * Extend this class to create new services
**/
export abstract class Service {
  name!: string
  settings!: ServiceSettingSchema;

  [name: string]: any;

  created(): void {}
  started(): Promise<void> {
    return Promise.resolve()
  }

  __toMoleculerSchema(): ServiceSchema {
    const schema = getSchema(this);
    return schema
  }
}

export function event(name?: string | ServiceEvent, options?: EventSchema): MethodDecorator {
  return <T>(target: Object, propertyKey: string | Symbol, descriptor: TypedPropertyDescriptor<T>) => {
    let schema: ServiceEvent = {
      name: propertyKey.toString()
    };

    if (name && typeof name === "string") {
      schema.name = name;
    } else if (name && typeof name !== "string") {
      schema = <ServiceEvent>name;
    } else if (options) {
      schema = options
    }

    schema.handler = <ActionHandler<any>><unknown>descriptor.value;

    const events = Reflect.getMetadata(EVENT_METADATA_KEY, target) || {}

    events[propertyKey.toString()] = schema

    Reflect.defineMetadata(EVENT_METADATA_KEY, events, target)
  }
}
