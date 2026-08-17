# ast-grep anti-slop rules

This repository translates the 15 rules in `dmmulroy/anti-slop` into ast-grep warnings for JavaScript, TypeScript, and Python, and adds some rules like `no_single_use_functions_same_file` on top.

This project is inspired by [`dmmulroy/anti-slop`](https://github.com/dmmulroy/anti-slop), whose Oxlint rules are the source material for the rules translated here.

## Layout

- `rules/` contains one YAML file per logical anti-slop rule.
- Each rule file contains three independent YAML documents, separated by `---` and ordered TypeScript, JavaScript, then Python.
- Every document keeps its own language-prefixed ID, parser, message, utilities, constraints, and structural pattern. The documents are colocated for comparison; they are not one shared cross-language matcher.
- `test_samples/` contains one `.js`, `.ts`, and `.py` violation sample for every rule. Each filename uses the rule's underscore name. `test_samples/valid/` contains non-violations needed to verify reference-sensitive behavior.

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

The Makefile provides `test-typescript`, `test-javascript`, `test-python`, and `test-single-use-functions-same-file`. Each language target runs every multi-document rule file against its same-named sample and fails if the expected structural match is absent. The dedicated single-use target verifies one warning for a one-call function and no warnings for zero-call, repeated, or recursive functions.

Run one language or rule family:

```sh
ast-grep scan --filter '^javascript-' test_samples
ast-grep scan --filter 'no-unsafe-dictionary-type$' test_samples
```

## Intentional language adaptations

Plain JavaScript has no native type annotations or assertions. Its type-oriented rules inspect JSDoc, and `no_chained_type_assertions` detects nested built-in coercions. Python uses `Any` as the practical `unknown` equivalent and `typing.cast` as the assertion equivalent. `no_runtime_typeof` maps to `isinstance` and direct `type(...)` comparisons; Reflect rules map to `getattr` and dynamic `__call__` access.

ast-grep YAML is syntax-aware but has no type checker, scope graph, alias resolution, or data-flow engine. The original Oxlint rules use several of those semantic facilities, so these rules deliberately implement conservative structural coverage rather than claiming semantic parity. In particular:

- shadowed `Reflect`, `vi`, and `jest` names cannot be distinguished from globals;
- transitive type aliases and all known-value flows cannot be resolved;
- same-name shadowing can conservatively suppress a single-use warning.

`no_single_use_functions_same_file` is implemented entirely as an ast-grep rule. It binds a named function declaration, requires one same-name direct call under the file root, and rejects every structural form containing a second call. Two distinct AST nodes are either nested or occur in different sibling subtrees under their lowest common ancestor; `has-two-same-name-calls` covers both cases. The rule excludes lambdas, arrow functions, anonymous functions, recursive functions, zero-call functions, and functions with multiple direct calls. Calls through aliases are not counted, and a member call such as `parser.parse_args()` does not count as a direct call to `parse_args()`.

A separate project-wide single-use rule is intentionally deferred until the same-file behavior is settled and tested. Project-wide identity cannot rely on a function name alone because unrelated modules and scopes can define the same name.
