def is_ip_address(value: str) -> bool:
    parts = value.split(".")
    if len(parts) != 4:
        return False

    for part in parts:
        if not part.isdigit():
            return False
        if not 0 <= int(part) <= 255:
            return False

    return True
