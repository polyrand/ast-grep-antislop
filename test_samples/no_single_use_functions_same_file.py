def single_use_abstraction(foo: str) -> int:
    result = bar(foo)
    return result


def processing(input_value: str) -> int:
    result = single_use_abstraction(input_value)
    return finish(result)


parser.single_use_abstraction()
