function reusedAbstraction(foo) {
  return bar(foo);
}

function firstConsumer(input) {
  return reusedAbstraction(input);
}

function secondConsumer(input) {
  return reusedAbstraction(input);
}

function recursiveFunction(value) {
  if (value <= 0) return 0;
  return recursiveFunction(value - 1);
}

function sameBlockAbstraction(foo) {
  return bar(foo);
}

function sameBlockConsumer(input) {
  const first = sameBlockAbstraction(input);
  return sameBlockAbstraction(first);
}

function nestedAbstraction(foo) {
  return bar(foo);
}

function nestedConsumer(input) {
  return nestedAbstraction(nestedAbstraction(input));
}
