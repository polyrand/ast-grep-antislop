from concurrent.futures import ThreadPoolExecutor


def process(items: list[str]) -> list[str]:
    def enrich(item: str) -> str:
        return item.strip()

    def local_helper(item: str) -> str:
        return item.strip()

    with ThreadPoolExecutor() as pool:
        mapped = list(pool.map(enrich, items))
        filtered = list(filter(lambda item: item, mapped))
    return [local_helper(item) for item in filtered]
