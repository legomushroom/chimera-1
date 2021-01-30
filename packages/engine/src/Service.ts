import "reflect-metadata"

import { ServiceMethods, ServiceSchema, ServiceSettingSchema, EventSchema, ActionHandler, ServiceEvent, ServiceEvents, Service as MoleculerService, ServiceBroker } from "moleculer"
import Promise from "bluebird";

interface IObject extends Object {
  [index: string]: any
}

interface IEventList {
  [index: string]: IServiceEvent
}

interface IPropList {
  [index: string]: any
}

interface IServiceEvent extends ServiceEvent {
  name?: any
}

type TEventNamingFunction = (o: IObject) => string

const PROPERTY_BLACKLIST = new Set([
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
  "started",
  "publish",
  "name"
])

const EVENT_METADATA_KEY = Symbol("events");

/**
 * Recursively extracts methods from a given objects tree
**/
function getMethods(obj: IObject, events: IEventList): ServiceMethods {
  let properties = new Set()
  let currentObj = obj
  let eventList = new Set(Object.keys(events || {}))
  do {
    Object.getOwnPropertyNames(currentObj).map(item => properties.add(item))
  } while ((currentObj = Object.getPrototypeOf(currentObj)))

  const methods: ServiceMethods = {};

  [...properties.keys()]
    .filter(item => typeof obj[<string>item] === "function")
    .filter(item => !PROPERTY_BLACKLIST.has(<string>item))
    .filter(item => !eventList.has(<string>item))
    .filter(item => !(<string>item).match(/^__/))
    .forEach(item => methods[<string>item] = obj[<string>item])

  return methods
}

function getEvents(obj: IObject): IEventList {
  const events: IEventList = {}
  return Reflect.getMetadata(EVENT_METADATA_KEY, obj.__proto__)
}

function getProperties(obj: IObject): IPropList {
   let properties = new Set()
  let currentObj = obj
  do {
    Object.getOwnPropertyNames(currentObj).map(item => properties.add(item))
  } while ((currentObj = Object.getPrototypeOf(currentObj)))

  let final: IPropList = {};

  [...properties.keys()]
    .filter(item => typeof obj[<string>item] !== "function")
    .filter(item => !PROPERTY_BLACKLIST.has(<string>item))
    .filter(item => !(<string>item).match(/^__/))
    .forEach(item => final[<string>item] = obj[<string>item])

  return final
}

function getSchema(obj: IObject): ServiceSchema {
  const rawEvents = getEvents(obj) || {}
  const methods = getMethods(obj, rawEvents)

  const events: ServiceEvents = {}

  Object.values(rawEvents).forEach((event) => {
    let name;
    if (typeof event.name == "function") {
      name = event.name(obj)
    } else {
      name = event.name
    }
    event.name = name
    events[<string>name] = event
  })

  const props = getProperties(obj);

  return {
    name: obj.name,
    settings: obj.settings || {},
    created: obj.__created(props),
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
  settings: ServiceSettingSchema = {};
  broker!: ServiceBroker;

  [name: string]: any;

  created(): void {}
  started(): Promise<void> {
    return Promise.resolve()
  }

  emit<D>(eventName: string, data: D, groupsOrOpts?: any): Promise<void> {
    return <Promise<void>>this.broker.emit(eventName, data, groupsOrOpts)
  }

  __toMoleculerSchema(): ServiceSchema {
    const schema = getSchema(this);
    return schema
  }

  __created(props: IPropList) {
    const created = this.created
    return function(this: MoleculerService) {
      Object.keys(props).forEach(prop => this[prop] = props[prop])
      created.bind(this)()
    }
  }
}

export function event(name?: string | ServiceEvent | TEventNamingFunction, options?: ServiceEvent): MethodDecorator {
  return <T>(target: Object, propertyKey: string | Symbol, descriptor: TypedPropertyDescriptor<T>) => {
    let schema: IServiceEvent = {
      name: propertyKey.toString()
    };

    if (name && typeof name === "string") {
      schema.name = name;
    } else if (name && typeof name === "function") {
      schema.name = name
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
