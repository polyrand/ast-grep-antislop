# ast-grep anti-slop rules

This repository translates the 15 rules in `references/anti-slop/src` into ast-grep warnings for JavaScript, TypeScript, and Python, and adds `no_single_use_functions`.

## Layout

- `rules/` contains one YAML file per logical anti-slop rule.
- Each rule file contains three independent YAML documents, separated by `---` and ordered TypeScript, JavaScript, then Python.
- Every document keeps its own language-prefixed ID, parser, message, utilities, constraints, and structural pattern. The documents are colocated for comparison; they are not one shared cross-language matcher.
- `test_samples/` contains one `.js`, `.ts`, and `.py` violation sample for every rule. Each filename uses the rule's underscore name.

For example, `rules/no_reflect_get.yml` contains:

```yaml
# TypeScript
id: typescript-no-reflect-get
language: TypeScript
# ...
---
# JavaScript
id: javascript-no-reflect-get
language: JavaScript
# ...
---
# Python
id: python-no-reflect-get
language: Python
# ...
```

`sgconfig.yml` points at the recursive `rules/` directory, so ast-grep loads all 16 files and all 48 rule documents.

Run every rule against the samples:

```sh
ast-grep scan test_samples
make test
```

The Makefile also provides `test-typescript`, `test-javascript`, and `test-python`. Each target runs every multi-document rule file against its same-named sample for that language and fails if the expected warning is absent.

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

`no_single_use_functions` does not flag lambdas, arrow functions, or anonymous functions. It flags named functions whose entire body only forwards another call, either directly or through a temporary result variable. Because ast-grep cannot count references, the warning is conditional: confirm that the named wrapper has one caller, then inline its delegated call at that use site. Exact named-function reference counting requires a symbol-aware second pass or language server.
