type User = { id: string };

function readUser(input: string): User {
  return JSON.parse(input);
}
