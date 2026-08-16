function load(): Promise<unknown> {
  return fetchValue();
}
function loadSync(): unknown {
  return readValue();
}
