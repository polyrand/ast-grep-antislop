def reused_abstraction(foo: str) -> int:
    return bar(foo)


def first_consumer(input_value: str) -> int:
    return reused_abstraction(input_value)


def second_consumer(input_value: str) -> int:
    return reused_abstraction(input_value)


def recursive_function(value: int) -> int:
    if value <= 0:
        return 0
    return recursive_function(value - 1)


def same_block_abstraction(foo: str) -> int:
    return bar(foo)


def same_block_consumer(input_value: str) -> int:
    first = same_block_abstraction(input_value)
    return same_block_abstraction(first)


def nested_abstraction(foo: str) -> int:
    return bar(foo)


def nested_consumer(input_value: str) -> int:
    return nested_abstraction(nested_abstraction(input_value))
