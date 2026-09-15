from bucket_name import is_valid_bucket_name

def test_empty_string_is_invalid():
    result = is_valid_bucket_name("")
    assert result is False
