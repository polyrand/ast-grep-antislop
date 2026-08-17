def render(value: str, is_compact: bool) -> str:
    if is_compact:
        return render_compact(value)
    return render_full(value)
