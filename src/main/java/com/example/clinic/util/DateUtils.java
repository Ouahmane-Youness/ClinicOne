package com.example.clinic.util;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

public class DateUtils {

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("MMM dd, yyyy");
    private static final DateTimeFormatter SHORT_DATE_FORMATTER = DateTimeFormatter.ofPattern("MMM dd");
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("hh:mm a");
    private static final DateTimeFormatter DAY_NAME_FORMATTER = DateTimeFormatter.ofPattern("EEE");
    private static final DateTimeFormatter DAY_NUMBER_FORMATTER = DateTimeFormatter.ofPattern("dd");
    private static final DateTimeFormatter MONTH_NAME_FORMATTER = DateTimeFormatter.ofPattern("MMM");

    public static String formatDate(LocalDate date) {
        if (date == null) {
            return "";
        }
        return date.format(DATE_FORMATTER);
    }

    public static String formatShortDate(LocalDate date) {
        if (date == null) {
            return "";
        }
        return date.format(SHORT_DATE_FORMATTER);
    }

    public static String formatTime(LocalTime time) {
        if (time == null) {
            return "";
        }
        return time.format(TIME_FORMATTER);
    }

    public static String formatDayName(LocalDate date) {
        if (date == null) {
            return "";
        }
        return date.format(DAY_NAME_FORMATTER);
    }

    public static String formatDayNumber(LocalDate date) {
        if (date == null) {
            return "";
        }
        return date.format(DAY_NUMBER_FORMATTER);
    }

    public static String formatMonthName(LocalDate date) {
        if (date == null) {
            return "";
        }
        return date.format(MONTH_NAME_FORMATTER);
    }
}