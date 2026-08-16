result = operation.__call__(*args)
other_result = getattr(operation, "__call__")(*args)
