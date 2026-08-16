/** @returns {Promise<unknown>} */
function load() {
  return fetchValue();
}
/** @return {unknown} */
function loadSync() {
  return readValue();
}
