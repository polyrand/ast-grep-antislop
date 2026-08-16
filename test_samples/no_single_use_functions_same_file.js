function singleUseAbstraction(foo) {
  const result = bar(foo);
  return result;
}

function processing(input) {
  const result = singleUseAbstraction(input);
  return finish(result);
}

parser.singleUseAbstraction();
