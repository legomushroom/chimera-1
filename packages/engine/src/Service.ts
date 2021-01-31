import "reflect-metadata"

import {
  ServiceMethods,
  ServiceSchema,
  ServiceSettingSchema,
  ActionHandler,
  ServiceEvent,
  ServiceEvents,
  Service as MoleculerService,
  ServiceBroker,
  ServiceActionsSchema,
  ActionSchema
} from "moleculer"
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

interface IActionSchema extends ActionSchema {
  name?: any
}

type TNamingFunction = (o: IObject) => string

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
  "name",
  "mixins",
  "settings"
])

const EVENT_METADATA_KEY = Symbol("events");
const ACTION_METADATA_KEY = Symbol("actions");

/**
 * Recursively extracts methods from a given objects tree
**/
function getMethods(obj: IObject, events: IEventList, actions: IActionSchema): ServiceMethods {
  let properties = new Set()
  let currentObj = obj
  let eventList = new Set(Object.keys(events || {}))
  let actionList = new Set(Object.keys(actions || {}))

  do {
    Object.getOwnPropertyNames(currentObj).map(item => properties.add(item))
  } while ((currentObj = Object.getPrototypeOf(currentObj)))

  const methods: ServiceMethods = {};

  [...properties.keys()]
    .filter(item => typeof obj[<string>item] === "function")
    .filter(item => !PROPERTY_BLACKLIST.has(<string>item))
    .filter(item => !eventList.has(<string>item))
    .filter(item => !actionList.has(<string>item))
    .filter(item => !(<string>item).match(/^__/))
    .forEach(item => methods[<string>item] = obj[<string>item])

  return methods
}

function getEvents(obj: IObject): IEventList {
  return Reflect.getMetadata(EVENT_METADATA_KEY, obj.__proto__)
}

function getActions(obj: IObject): IActionSchema[] {
  return Reflect.getMetadata(ACTION_METADATA_KEY, obj.__proto__)
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

function getSchema(obj: Service): ServiceSchema {
  const rawEvents = getEvents(obj) || {}
  const rawActions = getActions(obj) || {}

  const methods = getMethods(obj, rawEvents, rawActions)

  const events: ServiceEvents = {}
  const actions: ServiceActionsSchema = {}

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

  Object.values(rawActions).forEach((action) => {
    let name;
    if (typeof action.name == "function") {
      name = action.name(obj)
    } else {
      name = action.name
    }
    action.name = name
    actions[<string>name] = action

  })

  const props = getProperties(obj);

  const mixins: ServiceSchema[] = [];

  obj.mixins.forEach((mixin) => {
    if (mixin instanceof Service) {
      mixins.push(mixin.__toMoleculerSchema())
    } else {
      mixins.push(mixin)
    }
  })

  return {
    name: obj.name,
    settings: obj.settings || {},
    created: obj.__created(props),
    started: obj.started,
    events,
    methods,
    mixins,
    actions
  }
}


/**
 * Extend this class to create new services
**/
export abstract class Service {
  name!: string
  settings: ServiceSettingSchema = {};
  broker!: ServiceBroker;
  mixins: (ServiceSchema | Service)[] = [];

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

export function event(name?: string | ServiceEvent | TNamingFunction, options?: ServiceEvent): MethodDecorator {
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

export function action(name?: string | TNamingFunction, options?: ActionSchema): MethodDecorator {
  return <T>(target: Object, propertyKey: string | Symbol, descriptor: TypedPropertyDescriptor<T>) => {
    let schema: ActionSchema = {};
    if (options) {
      schema = options
    }

    if (!name) {
      name = propertyKey.toString()
    } else if (typeof name == "string") {
      schema.name = name
    }

    schema.handler = <ActionHandler<any>><unknown>descriptor.value;

    const actions = Reflect.getMetadata(ACTION_METADATA_KEY, target) || {}

    actions[propertyKey.toString()] = schema

    Reflect.defineMetadata(ACTION_METADATA_KEY, actions, target)
  }
}