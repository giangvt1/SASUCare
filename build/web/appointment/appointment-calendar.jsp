<%@ page contentType="text/html;charset=UTF-8" language="java" %> 
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.YearMonth" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.format.TextStyle" %>
<%@ page import="java.util.Locale" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // Get current date
    LocalDate currentDate = LocalDate.now();
    int selectedMonth = request.getParameter("month") != null ? Integer.parseInt(request.getParameter("month")) : currentDate.getMonthValue();
    int selectedYear = request.getParameter("year") != null ? Integer.parseInt(request.getParameter("year")) : currentDate.getYear();

    // Get month name
    String monthName = LocalDate.of(selectedYear, selectedMonth, 1).getMonth().getDisplayName(TextStyle.FULL, Locale.ENGLISH);
    
    // Set up the month and year for the calendar
    YearMonth yearMonth = YearMonth.of(selectedYear, selectedMonth);
    int daysInMonth = yearMonth.lengthOfMonth();
    LocalDate firstOfMonth = LocalDate.of(selectedYear, selectedMonth, 1);
    int startDayOfWeek = firstOfMonth.getDayOfWeek().getValue() % 7; // Adjust to 0-based index (0=Sunday)
    
    // Calculate previous and next month/year
    int prevMonth = selectedMonth == 1 ? 12 : selectedMonth - 1;
    int prevYear = selectedMonth == 1 ? selectedYear - 1 : selectedYear;
    int nextMonth = selectedMonth == 12 ? 1 : selectedMonth + 1;
    int nextYear = selectedMonth == 12 ? selectedYear + 1 : selectedYear;
    
    // Formatter for display dates
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Select Appointment Date</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            :root {
                --primary-color: #3b82f6;
                --primary-light: #dbeafe;
                --primary-dark: #2563eb;
                --secondary-color: #10b981;
                --success-light: #d1fae5;
                --disabled-color: #f3f4f6;
                --disabled-text: #9ca3af;
                --border-color: #e5e7eb;
                --text-color: #1f2937;
                --text-muted: #6b7280;
                --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
                --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
                --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
                --radius-sm: 0.125rem;
                --radius: 0.375rem;
                --radius-md: 0.5rem;
                --radius-lg: 0.75rem;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            
            body {
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                color: var(--text-color);
                background-color: #f9fafb;
                line-height: 1.5;
            }

            .calendar-container {
                max-width: 1000px;
                margin: 0 auto;
                padding: 2rem 1rem;
            }

            .calendar-header {
                text-align: center;
                margin-bottom: 2rem;
            }

            .calendar-header h1 {
                font-size: 2rem;
                color: var(--text-color);
                margin-bottom: 0.5rem;
            }

            .calendar-header p {
                color: var(--text-muted);
                font-size: 1.125rem;
            }

            .date-navigation {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 1.5rem;
                background-color: white;
                border-radius: var(--radius-lg);
                padding: 1rem 1.5rem;
                box-shadow: var(--shadow);
            }

            .month-year {
                font-size: 1.5rem;
                font-weight: 600;
                color: var(--text-color);
            }

            .nav-buttons {
                display: flex;
                gap: 0.5rem;
            }

            .nav-btn {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 2.5rem;
                height: 2.5rem;
                border: none;
                border-radius: var(--radius);
                background-color: var(--primary-light);
                color: var(--primary-color);
                cursor: pointer;
                transition: all 0.2s;
            }

            .nav-btn:hover {
                background-color: var(--primary-color);
                color: white;
            }

            .calendar-grid {
                display: grid;
                grid-template-columns: repeat(7, 1fr);
                background-color: white;
                border-radius: var(--radius-lg);
                overflow: hidden;
                box-shadow: var(--shadow);
            }

            .day-header {
                text-align: center;
                font-weight: 600;
                font-size: 0.875rem;
                padding: 1rem 0.5rem;
                background-color: var(--primary-color);
                color: white;
                text-transform: uppercase;
            }

            .calendar-day {
                position: relative;
                min-height: 100px;
                padding: 0.5rem;
                border: 1px solid var(--border-color);
                text-align: center;
                transition: all 0.2s;
            }

            .calendar-day:hover:not(.empty):not(.disabled) {
                background-color: var(--primary-light);
                border-color: var(--primary-color);
            }

            .day-number {
                display: inline-block;
                width: 2rem;
                height: 2rem;
                line-height: 2rem;
                font-weight: 500;
                margin-bottom: 0.5rem;
                border-radius: var(--radius-full);
            }

            .calendar-day.today .day-number {
                background-color: var(--primary-color);
                color: white;
                font-weight: 600;
            }

            .calendar-day.empty {
                background-color: #f9fafb;
            }

            .calendar-day.disabled {
                background-color: var(--disabled-color);
            }

            .calendar-day.disabled .day-number {
                color: var(--disabled-text);
            }

            .calendar-day .date-info {
                font-size: 0.75rem;
                color: var(--text-muted);
            }

            .calendar-day:not(.empty):not(.disabled) {
                cursor: pointer;
            }

            .available-tag {
                display: inline-block;
                margin-top: 0.25rem;
                padding: 0.25rem 0.5rem;
                font-size: 0.75rem;
                border-radius: var(--radius);
                background-color: var(--success-light);
                color: var(--secondary-color);
            }

            .date-picker {
                margin-bottom: 2rem;
                padding: 1.5rem;
                background-color: white;
                border-radius: var(--radius-lg);
                box-shadow: var(--shadow);
            }

            .date-picker h2 {
                font-size: 1.25rem;
                margin-bottom: 1rem;
                color: var(--text-color);
            }

            .date-picker-form {
                display: flex;
                flex-wrap: wrap;
                gap: 1rem;
                align-items: center;
            }

            .form-group {
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .form-group label {
                font-weight: 500;
                color: var(--text-color);
            }

            .form-control {
                padding: 0.625rem 1rem;
                border: 1px solid var(--border-color);
                border-radius: var(--radius);
                color: var(--text-color);
                background-color: white;
                min-width: 120px;
            }

            .form-control:focus {
                outline: none;
                border-color: var(--primary-color);
                box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.25);
            }

            .btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                padding: 0.625rem 1.25rem;
                font-size: 0.875rem;
                font-weight: 500;
                line-height: 1.5;
                border-radius: var(--radius);
                cursor: pointer;
                transition: all 0.2s;
            }

            .btn-primary {
                background-color: var(--primary-color);
                color: white;
                border: none;
            }

            .btn-primary:hover {
                background-color: var(--primary-dark);
            }

            .quick-date-selector {
                display: flex;
                flex-wrap: wrap;
                gap: 0.75rem;
                margin-top: 1rem;
            }

            .date-selector-card {
                flex: 1;
                min-width: 150px;
                display: flex;
                flex-direction: column;
                align-items: center;
                padding: 1rem;
                background-color: white;
                border: 1px solid var(--border-color);
                border-radius: var(--radius);
                cursor: pointer;
                transition: all 0.2s;
            }

            .date-selector-card:hover {
                border-color: var(--primary-color);
                background-color: var(--primary-light);
            }

            .date-selector-card.disabled {
                background-color: var(--disabled-color);
                border-color: var(--border-color);
                cursor: not-allowed;
            }

            .date-selector-card.disabled .date-name,
            .date-selector-card.disabled .date-number {
                color: var(--disabled-text);
            }

            .date-day {
                font-size: 0.875rem;
                font-weight: 500;
                color: var(--text-muted);
                margin-bottom: 0.25rem;
            }

            .date-number {
                font-size: 1.75rem;
                font-weight: 700;
                color: var(--text-color);
                margin-bottom: 0.25rem;
            }

            .date-name {
                font-size: 0.875rem;
                color: var(--text-muted);
            }

            .help-text {
                text-align: center;
                margin-top: 1.5rem;
                color: var(--text-muted);
            }

            @media (max-width: 768px) {
                .calendar-grid {
                    grid-template-columns: repeat(7, 1fr);
                }
                
                .calendar-day {
                    min-height: 80px;
                    padding: 0.25rem;
                }
                
                .day-number {
                    width: 1.75rem;
                    height: 1.75rem;
                    line-height: 1.75rem;
                    font-size: 0.875rem;
                }
                
                .date-selector-card {
                    min-width: 100px;
                }
            }

            @media (max-width: 576px) {
                .calendar-grid {
                    font-size: 0.875rem;
                }
                
                .calendar-day {
                    min-height: 60px;
                }
                
                .day-number {
                    width: 1.5rem;
                    height: 1.5rem;
                    line-height: 1.5rem;
                }
                
                .available-tag {
                    font-size: 0.675rem;
                    padding: 0.125rem 0.375rem;
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="../Header.jsp"/>

        <div class="calendar-container">
            <div class="calendar-header">
                <h1>Choose an Appointment Date</h1>
                <p>Select a date to see available doctors and time slots</p>
            </div>

            <!-- Quick Date Selector -->
            <div class="date-picker">
                <h2>Quick Select</h2>
                <div class="quick-date-selector">
                    <% 
                        // Show next 5 days for quick selection
                        for(int i = 0; i < 5; i++) {
                            LocalDate quickDate = currentDate.plusDays(i);
                            boolean isAvailable = i > 0; // Today is not available (example rule)
                            String dayOfWeek = quickDate.getDayOfWeek().getDisplayName(TextStyle.SHORT, Locale.ENGLISH);
                            int dayOfMonth = quickDate.getDayOfMonth();
                            String monthShort = quickDate.getMonth().getDisplayName(TextStyle.SHORT, Locale.ENGLISH);
                    %>
                    <a href="<%= isAvailable ? "appointment/doctor?date=" + quickDate : "#" %>" 
                       class="date-selector-card <%= isAvailable ? "" : "disabled" %>"
                       <%= isAvailable ? "" : "onclick=\"return false;\"" %>>
                        <span class="date-day"><%= dayOfWeek %></span>
                        <span class="date-number"><%= dayOfMonth %></span>
                        <span class="date-name"><%= monthShort %></span>
                    </a>
                    <% } %>
                </div>
            </div>

            <!-- Date Navigation -->
            <div class="date-navigation">
                <a href="?month=<%= prevMonth %>&year=<%= prevYear %>" class="nav-btn">
                    <i class="fas fa-chevron-left"></i>
                </a>
                <div class="month-year"><%= monthName %> <%= selectedYear %></div>
                <a href="?month=<%= nextMonth %>&year=<%= nextYear %>" class="nav-btn">
                    <i class="fas fa-chevron-right"></i>
                </a>
            </div>
            
            <!-- Calendar Grid -->
            <div class="calendar-grid">
                <!-- Day Headers -->
                <div class="day-header">Sun</div>
                <div class="day-header">Mon</div>
                <div class="day-header">Tue</div>
                <div class="day-header">Wed</div>
                <div class="day-header">Thu</div>
                <div class="day-header">Fri</div>
                <div class="day-header">Sat</div>
                
                <% 
                    // Print empty cells until the first day of the month
                    for (int i = 0; i < startDayOfWeek; i++) {
                %>
                    <div class="calendar-day empty"></div>
                <% } %>
                
                <% 
                    // Print the days of the month
                    for (int day = 1; day <= daysInMonth; day++) {
                        LocalDate loopDate = LocalDate.of(selectedYear, selectedMonth, day);
                        boolean isDisabled = loopDate.isBefore(currentDate);
                        boolean isToday = loopDate.equals(currentDate);
                        
                        // Format the date for the link
                        String formattedDate = loopDate.toString();
                        
                        // Additional date information
                        String fullDateDisplay = loopDate.format(formatter);
                        
                        // Get the day of week name
                        String dayName = loopDate.getDayOfWeek().getDisplayName(TextStyle.SHORT, Locale.ENGLISH);
                %>
                    <div class="calendar-day <%= isDisabled ? "disabled" : "" %> <%= isToday ? "today" : "" %>"
                         <%= !isDisabled ? "onclick=\"window.location.href = 'appointment/doctor?date=" + formattedDate + "'\"" : "" %>>
                        <div class="day-number"><%= day %></div>
                        <div class="date-info"><%= dayName %></div>
                        <% if (!isDisabled && !isToday) { %>
                            <div class="available-tag">Available</div>
                        <% } %>
                    </div>
                <% } %>
                
                <% 
                    // Fill the remaining cells in the grid
                    int remainingCells = 7 - ((startDayOfWeek + daysInMonth) % 7);
                    if (remainingCells < 7) {
                        for (int i = 0; i < remainingCells; i++) {
                %>
                    <div class="calendar-day empty"></div>
                <% 
                        }
                    } 
                %>
            </div>
            
            <p class="help-text">
                <i class="fas fa-info-circle"></i> 
                Click on an available date to see doctor availability and book your appointment.
            </p>
        </div>

        <jsp:include page="../Footer.jsp"/>
    </body>
</html>