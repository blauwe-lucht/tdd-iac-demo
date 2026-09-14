def is_valid_bucket_name(name: str) -> bool:
    return 3 <= len(name) <= 63 and name == name.lower() and name.isalpha()
