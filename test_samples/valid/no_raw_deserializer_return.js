function readUser(input) {
  const raw = JSON.parse(input);
  return parseUser(raw);
}
