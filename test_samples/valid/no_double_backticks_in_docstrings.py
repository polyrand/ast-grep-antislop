"""Use `root` to find nested paths."""

from pathlib import Path


def find_git_files(root: Path) -> list[Path]:
    """Find nested `.git` files and directories without entering them."""
    return []


text = "A normal string may contain ``literal`` text."
