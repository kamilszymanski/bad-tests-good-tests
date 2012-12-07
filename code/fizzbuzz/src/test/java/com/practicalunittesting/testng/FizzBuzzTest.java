package com.practicalunittesting.testng;

import com.practicalunittesting.FizzBuzz;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;

import static org.testng.Assert.*;
/**
 * Created with IntelliJ IDEA.
 * User: tomek
 * Date: 11/22/12
 * Time: 9:57 PM
 * To change this template use File | Settings | File Templates.
 */
@Test
public class FizzBuzzTest {
    @DataProvider
    public static Integer[][] multipleOf3And5() {
        return new Integer[][]{{15}, {30}, {42}};
    }

    @Test(dataProvider = "multipleOf3And5")
    public void testMultipleOfThreeAndFivePrintsFizzBuzz(int multipleOf3And5) {
        assertEquals("FizzBuzz", FizzBuzz.getResult(multipleOf3And5));
    }

    @Test
    public void testMultipleOfThreeOnlyPrintsFizz(int multipleOf3) {
        assertEquals("Fizz", FizzBuzz.getResult(multipleOf3));
    }

    @Test
    public void testMultipleOfFiveOnlyPrintsBuzz(int multipleOf5) {
        assertEquals("Buzz", FizzBuzz.getResult(multipleOf5));
    }

    @Test
    public void testInputOfEightPrintsTheNumber(int expectedNumber) {
        assertEquals("8", FizzBuzz.getResult(expectedNumber));
    }
}

