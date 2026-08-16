def load() -> Awaitable[Any]:
    return fetch_value()

def load_sync() -> Any:
    return read_value()
