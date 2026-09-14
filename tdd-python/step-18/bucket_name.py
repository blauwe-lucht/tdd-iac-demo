import re

def is_valid_bucket_name(name: str) -> bool:
    return (
        3 <= len(name) <= 63
        and name == name.lower()
        and re.fullmatch(r"[a-z0-9.-]+", name) is not None
    )
