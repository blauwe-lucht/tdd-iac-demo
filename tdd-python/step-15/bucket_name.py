def is_valid_bucket_name(name: str) -> bool:
    return (
        3 <= len(name) <= 63
        and name == name.lower()
        and all(c.isalpha() or c == "-" for c in name)
    )
