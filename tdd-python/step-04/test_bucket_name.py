from bucket_name import is_valid_bucket_name

def test_empty_string_is_invalid():
    result = is_valid_bucket_name("")

    assert result is False

def test_simple_lowercase_name_is_valid():
    result = is_valid_bucket_name("mybucket")

    assert result is True
