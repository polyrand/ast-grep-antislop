def handle(value: object) -> object:
    validate_user(value)
    return save_user(value)
