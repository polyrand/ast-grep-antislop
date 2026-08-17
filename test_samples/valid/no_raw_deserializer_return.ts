type User = { id: string };

function readUser(input: string): User {
  const raw = JSON.parse(input);
  return parseUser(raw);
}
