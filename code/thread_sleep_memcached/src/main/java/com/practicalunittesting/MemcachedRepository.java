package com.practicalunittesting;

public interface MemcachedRepository {
    void setValue(String key, int i, String value);

    Object getValue(String key);
}
