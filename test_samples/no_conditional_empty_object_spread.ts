declare const condition: boolean;
declare const value: string;
const result = { ...(condition ? { value } : {}) };
const otherResult = { ...(condition ? {} : { value }) };
