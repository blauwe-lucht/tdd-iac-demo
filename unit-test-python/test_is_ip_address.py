from is_ip_address import is_ip_address

def test_valid_ip_address_is_valid():
    result = is_ip_address("192.168.1.1")

    assert result is True

def test_ip_address_with_too_few_parts_is_invalid():
    result = is_ip_address("192.168.1")

    assert result is False

def test_ip_address_with_octet_out_of_range_is_invalid():
    result = is_ip_address("999.168.1.1")

    assert result is False
