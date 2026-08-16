declare const input: unknown;
const user = input as object as User;
const otherUser = <User>(<object>input);
