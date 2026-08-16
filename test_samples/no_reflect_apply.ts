const result = Reflect.apply(operation, owner, args);
const otherResult = Reflect['apply'](operation, owner, args);
