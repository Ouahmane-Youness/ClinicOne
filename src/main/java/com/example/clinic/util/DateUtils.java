package com.example.clinic.util;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

public class DateUtils {

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("MMM dd, yyyy");
    private static final DateTimeFormatter SHORT_DATE_FORMATTER = DateTimeFormatter.ofPattern("MMM dd");
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("hh:mm a");
    private static final DateTimeFormatter DAY_NAME_FORMATTER = DateTimeFormatter.ofPattern("EEE");
    private static final DateTimeFormatter DAY_NUMBER_FORMATTER = DateTimeFormatter.ofPattern("dd");
    private static final DateTimeFormatter MONTH_NAME_FORMATTER = DateTimeFormatter.ofPattern("MMM");
    private static final DateTimeFormatter FULL_DAY_FORMATTER = DateTimeFormatter.ofPattern("EEEE");
    private static final DateTimeFormatter MONTH_YEAR_FORMATTER = DateTimeFormatter.ofPattern("MMMM yyyy");
    private static final DateTimeFormatter ISO_DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

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

    public static String formatFullDayName(LocalDate date) {
        if (date == null) {
            return "";
        }
        return date.format(FULL_DAY_FORMATTER);
    }

    public static String formatMonthYear(LocalDate date) {
        if (date == null) {
            return "";
        }
        return date.format(MONTH_YEAR_FORMATTER);
    }

    public static String formatIsoDate(LocalDate date) {
        if (date == null) {
            return "";
        }
        return date.format(ISO_DATE_FORMATTER);
    }

    public static String getRelativeDate(LocalDate date) {
        if (date == null) {
            return "";
        }

        LocalDate today = LocalDate.now();
        long daysDiff = ChronoUnit.DAYS.between(today, date);

        if (daysDiff == 0) {
            return "Today";
        } else if (daysDiff == 1) {
            return "Tomorrow";
        } else if (daysDiff == -1) {
            return "Yesterday";
        } else if (daysDiff > 1 && daysDiff <= 7) {
            return "In " + daysDiff + " days";
        } else if (daysDiff < -1 && daysDiff >= -7) {
            return Math.abs(daysDiff) + " days ago";
        } else {
            return formatDate(date);
        }
    }

    public static boolean isToday(LocalDate date) {
        if (date == null) {
            return false;
        }
        return date.equals(LocalDate.now());
    }

    public static boolean isPast(LocalDate date) {
        if (date == null) {
            return false;
        }
        return date.isBefore(LocalDate.now());
    }

    public static boolean isFuture(LocalDate date) {
        if (date == null) {
            return false;
        }
        return date.isAfter(LocalDate.now());
    }

    public static boolean isWeekend(LocalDate date) {
        if (date == null) {
            return false;
        }
        int dayOfWeek = date.getDayOfWeek().getValue();
        return dayOfWeek == 6 || dayOfWeek == 7; // Saturday or Sunday
    }

    public static LocalDate getStartOfWeek(LocalDate date) {
        if (date == null) {
            return null;
        }
        return date.minusDays(date.getDayOfWeek().getValue() - 1);
    }

    public static LocalDate getEndOfWeek(LocalDate date) {
        if (date == null) {
            return null;
        }
        return getStartOfWeek(date).plusDays(6);
    }

    public static long daysBetween(LocalDate start, LocalDate end) {
        if (start == null || end == null) {
            return 0;
        }
        return ChronoUnit.DAYS.between(start, end);
    }

    public static String formatTimeRange(LocalTime start, LocalTime end) {
        if (start == null || end == null) {
            return "";
        }
        return formatTime(start) + " - " + formatTime(end);
    }

    public static boolean isBusinessHours(LocalTime time) {
        if (time == null) {
            return false;
        }
        LocalTime businessStart = LocalTime.of(9, 0);
        LocalTime businessEnd = LocalTime.of(17, 0);
        return !time.isBefore(businessStart) && time.isBefore(businessEnd);
    }

    public static String getTimeOfDay(LocalTime time) {
        if (time == null) {
            return "";
        }

        int hour = time.getHour();
        if (hour < 6) {
            return "Early Morning";
        } else if (hour < 12) {
            return "Morning";
        } else if (hour < 17) {
            return "Afternoon";
        } else if (hour < 21) {
            return "Evening";
        } else {
            return "Night";
        }
    }
}