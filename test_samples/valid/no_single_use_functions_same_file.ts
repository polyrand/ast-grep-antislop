function reusedAbstraction(foo: string): number {
  return bar(foo);
}

function firstConsumer(input: string): number {
  return reusedAbstraction(input);
}

function secondConsumer(input: string): number {
  return reusedAbstraction(input);
}

function recursiveFunction(value: number): number {
  if (value <= 0) return 0;
  return recursiveFunction(value - 1);
}

function sameBlockAbstraction(foo: string): number {
  return bar(foo);
}

function sameBlockConsumer(input: string): number {
  const first = sameBlockAbstraction(input);
  return sameBlockAbstraction(first);
}

function nestedAbstraction(foo: string): number {
  return bar(foo);
}

function nestedConsumer(input: string): number {
  return nestedAbstraction(nestedAbstraction(input));
}
