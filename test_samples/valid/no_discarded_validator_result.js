function handle(value) {
  const validValue = validateUser(value);
  return saveUser(validValue);
}
