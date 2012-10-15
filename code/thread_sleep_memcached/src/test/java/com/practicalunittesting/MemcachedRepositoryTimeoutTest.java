package com.practicalunittesting;

import org.junit.Test;

import static org.fest.assertions.Assertions.assertThat;

public class MemcachedRepositoryTimeoutTest {
    public static final int ONE_SECOND_TTL = 1;
    public static final int TEN_SECONDS_TTL = 10;
    public static final int ONE_SECOND = 1000;

    private MemcachedRepository memcachedRepository;

    @Test(timeout = 1500)
    public void shouldAddEntryAndRemoveAfterExpire() throws InterruptedException {
        //given
        memcachedRepository.setValue("key", ONE_SECOND_TTL, "value");
        memcachedRepository.setValue("key2", TEN_SECONDS_TTL, "value2");
        Thread.sleep(ONE_SECOND);

        //when
        Object value = null;
        while (value == null) {
            value = memcachedRepository.getValue("key");
        }

        //then
        assertThat(value).isNull();
        assertThat(memcachedRepository.getValue("key2")).isEqualTo("value2");
    }
}
