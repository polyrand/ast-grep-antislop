from pathlib import Path


def find_git_files(root: Path) -> list[Path]:
    """Find nested ``.git`` files and directories without entering them."""
    return []
