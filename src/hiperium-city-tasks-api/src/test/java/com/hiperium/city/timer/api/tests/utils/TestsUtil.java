package com.hiperium.city.timer.api.tests.utils;

import com.hiperium.city.timer.api.model.Task;
import com.hiperium.city.timer.api.utils.enums.DaysEnum;
import org.jetbrains.annotations.NotNull;

import java.time.ZonedDateTime;
import java.time.temporal.ChronoUnit;

public final class TestsUtil {

    private TestsUtil() {
        // Private constructor.
    }

    @NotNull
    public static Task generateTestTask() {
        return new Task("Test task 1",
                23,
                45,
                String.join(",", DaysEnum.WED.name(), DaysEnum.FRI.name(), DaysEnum.SUN.name()),
                "java -jar execute-robot.jar",
                ZonedDateTime.now().plus(3, ChronoUnit.MONTHS),
                "Task description");
    }
}
