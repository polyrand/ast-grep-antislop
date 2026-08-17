function handle(value: unknown): unknown {
  validateUser(value);
  return saveUser(value);
}
