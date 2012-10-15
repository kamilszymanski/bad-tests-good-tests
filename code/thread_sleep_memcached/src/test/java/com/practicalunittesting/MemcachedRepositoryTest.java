package com.practicalunittesting;

import org.junit.Test;

import static org.fest.assertions.Assertions.assertThat;

public class MemcachedRepositoryTest {
    private MemcachedRepository memcachedRepository;

    @Test
    public void shouldAddEntryAndRemoveAfterExpire() throws InterruptedException {
        //given
        memcachedRepository.setValue("key", 1, "value");
        memcachedRepository.setValue("key2", 10, "value2");
        Thread.sleep(1000);

        //when
        Object value = null;
        for (int i = 0; i < 10; i++) {
            value = memcachedRepository.getValue("key");
            if (value != null) {
                Thread.sleep(100);
            } else {
                break;
            }
        }

        //then
        assertThat(value).isNull();
        assertThat(memcachedRepository.getValue("key2")).isEqualTo("value2");
    }

}
