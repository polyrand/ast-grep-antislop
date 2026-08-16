declare const value: unknown;
const userId = value as UserId;
// SAFETY: validateUserId established the branded identifier invariant.
const safeUserId = validatedValue as UserId;
