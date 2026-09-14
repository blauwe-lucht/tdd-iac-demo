import re

ALLOWED_CHARACTERS = re.compile(r"[a-z0-9.-]+")

def is_valid_bucket_name(name: str) -> bool:
    return has_valid_length(name) and has_valid_characters(name)

def has_valid_length(name: str) -> bool:
    return 3 <= len(name) <= 63

def has_valid_characters(name: str) -> bool:
    return ALLOWED_CHARACTERS.match(name) is not None
