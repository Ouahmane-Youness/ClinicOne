package com.example.clinic.util;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

public class DateUtils {

    private static final DateTimeFormatter DATE_FORMATTER =
            DateTimeFormatter.ofPattern("EEEE, MMMM dd, yyyy", Locale.ENGLISH);

    private static final DateTimeFormatter SHORT_DATE_FORMATTER =
            DateTimeFormatter.ofPattern("MMM dd, yyyy", Locale.ENGLISH);

    private static final DateTimeFormatter TIME_FORMATTER =
            DateTimeFormatter.ofPattern("HH:mm");

    private static final DateTimeFormatter DAY_NAME_FORMATTER =
            DateTimeFormatter.ofPattern("EEE", Locale.ENGLISH);

    private static final DateTimeFormatter DAY_NUMBER_FORMATTER =
            DateTimeFormatter.ofPattern("dd");

    private static final DateTimeFormatter MONTH_NAME_FORMATTER =
            DateTimeFormatter.ofPattern("MMM", Locale.ENGLISH);

    public static String formatDate(LocalDate date) {
        return date != null ? date.format(DATE_FORMATTER) : "";
    }

    public static String formatShortDate(LocalDate date) {
        return date != null ? date.format(SHORT_DATE_FORMATTER) : "";
    }

    public static String formatTime(LocalTime time) {
        return time != null ? time.format(TIME_FORMATTER) : "";
    }

    public static String formatDayName(LocalDate date) {
        return date != null ? date.format(DAY_NAME_FORMATTER) : "";
    }

    public static String formatDayNumber(LocalDate date) {
        return date != null ? date.format(DAY_NUMBER_FORMATTER) : "";
    }

    public static String formatMonthName(LocalDate date) {
        return date != null ? date.format(MONTH_NAME_FORMATTER) : "";
    }
}