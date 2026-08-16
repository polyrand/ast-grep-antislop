# ast-grep anti-slop rules

This repository translates the 15 rules in `references/anti-slop/src` into ast-grep warnings for JavaScript, TypeScript, and Python, and adds `no_single_use_functions`.

## Layout

- `rules/javascript/` contains JavaScript rules, including JSDoc equivalents for type-only checks.
- `rules/typescript/` contains the closest structural translations of the original TypeScript rules.
- `rules/python/` contains Python equivalents based on `Any`, `object`, `cast`, mapping annotations, `isinstance`, `getattr`, and `unittest.mock` conventions.
- `test_samples/` contains one `.js`, `.ts`, and `.py` violation sample for every rule. Each filename uses the rule's underscore name.

Run every rule against the samples:

```sh
ast-grep scan test_samples
```

Run one language or rule family:

```sh
ast-grep scan --filter '^javascript-' test_samples
ast-grep scan --filter 'no-unsafe-dictionary-type$' test_samples
```

## Intentional language adaptations

Plain JavaScript has no native type annotations or assertions. Its type-oriented rules inspect JSDoc, and `no_chained_type_assertions` detects nested built-in coercions. Python uses `Any` as the practical `unknown` equivalent and `typing.cast` as the assertion equivalent. `no_runtime_typeof` maps to `isinstance` and direct `type(...)` comparisons; Reflect rules map to `getattr` and dynamic `__call__` access.

ast-grep YAML is syntax-aware but has no type checker, scope graph, alias resolution, data-flow engine, or reference counter. The original Oxlint rules use several of those semantic facilities, so these rules deliberately implement conservative structural coverage rather than claiming semantic parity. In particular:

- shadowed `Reflect`, `vi`, and `jest` names cannot be distinguished from globals;
- transitive type aliases and all known-value flows cannot be resolved;
- exact named-function reference counting is not expressible in an ast-grep rule.

`no_single_use_functions` therefore catches the sound, directly observable subset: immediately invoked functions in JavaScript/TypeScript and immediately invoked lambdas in Python. Detecting a named function referenced exactly once requires a symbol-aware second pass or language server.
