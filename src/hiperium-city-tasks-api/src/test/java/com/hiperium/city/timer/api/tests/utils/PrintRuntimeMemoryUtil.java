package com.hiperium.city.timer.api.tests.utils;

public class PrintRuntimeMemoryUtil {

    public static void main(String[] args) {
        Runtime runtime = Runtime.getRuntime();
        long allocatedMemory = runtime.totalMemory();
        long maxMemory = runtime.maxMemory();
        long freeMemory = runtime.freeMemory();
        long usedMemory = allocatedMemory - freeMemory;
        System.out.println(" ");
        System.out.println("***********************************************");
        System.out.println("*********** Container Memory Info *************");
        System.out.println("***********************************************");
        System.out.println("Allocated memory : " + (allocatedMemory / 1024) + " MB");
        System.out.println("Max memory       : " + (maxMemory / 1024) + " MB");
        System.out.println("Free memory      : " + (freeMemory / 1024) + " MB");
        System.out.println("Used memory      : " + (usedMemory / 1024) + " MB");
        System.out.println("Total free memory: " + ((freeMemory + (maxMemory - allocatedMemory)) / 1024) + " MB");
        System.out.println(" ");
    }
}
