import re

ALLOWED_CHARACTERS = re.compile(r"[a-z0-9.-]+")
IP_ADDRESS_SHAPE = re.compile(r"\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}")

def is_valid_bucket_name(name: str) -> bool:
    return (
        has_valid_length(name)
        and has_valid_characters(name)
        and not looks_like_ip_address(name)
    )

def has_valid_length(name: str) -> bool:
    return 3 <= len(name) <= 63

def has_valid_characters(name: str) -> bool:
    return ALLOWED_CHARACTERS.fullmatch(name) is not None

def looks_like_ip_address(name: str) -> bool:
    return IP_ADDRESS_SHAPE.fullmatch(name) is not None
