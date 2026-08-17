def read_user(text: str) -> User:
    raw = json.loads(text)
    return parse_user(raw)
