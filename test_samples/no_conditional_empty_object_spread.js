const result = { ...(condition ? { value } : {}) };
const otherResult = { ...(condition ? {} : { value }) };
