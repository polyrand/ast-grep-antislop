function singleUseAbstraction(foo: string): number {
  const result = bar(foo);
  return result;
}

function processing(input: string): number {
  const result = singleUseAbstraction(input);
  return finish(result);
}

parser.singleUseAbstraction();
