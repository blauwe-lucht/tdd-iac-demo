import re

from is_ip_address import is_ip_address

ALLOWED_CHARACTERS = re.compile(r"[a-z0-9.-]+")

def is_valid_bucket_name(name: str) -> bool:
    return (
        has_valid_length(name)
        and has_valid_characters(name)
        and not is_ip_address(name)
    )

def has_valid_length(name: str) -> bool:
    return 3 <= len(name) <= 63

def has_valid_characters(name: str) -> bool:
    return ALLOWED_CHARACTERS.fullmatch(name) is not None
