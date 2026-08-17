function handle(value: unknown): unknown {
  const validValue = validateUser(value);
  return saveUser(validValue);
}
