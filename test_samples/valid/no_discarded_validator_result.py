def handle(value: object) -> object:
    valid_value = validate_user(value)
    return save_user(valid_value)
