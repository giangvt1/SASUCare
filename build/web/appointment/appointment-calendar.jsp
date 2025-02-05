<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.YearMonth" %>
<%@ page import="java.time.format.TextStyle" %>
<%@ page import="java.util.Locale" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // Get current date
    LocalDate currentDate = LocalDate.now();
    int selectedMonth = request.getParameter("month") != null ? Integer.parseInt(request.getParameter("month")) : currentDate.getMonthValue();
    int selectedYear = request.getParameter("year") != null ? Integer.parseInt(request.getParameter("year")) : currentDate.getYear();

    // Set up the month and year for the calendar
    YearMonth yearMonth = YearMonth.of(selectedYear, selectedMonth);
    int daysInMonth = yearMonth.lengthOfMonth();
    LocalDate firstOfMonth = LocalDate.of(selectedYear, selectedMonth, 1);
    int startDayOfWeek = firstOfMonth.getDayOfWeek().getValue() % 7; // Adjust to 0-based index (0=Sunday)
%>

<html>
    <head>
        <title>Calendar</title>
        <style>
            .calendar {
                width: 100%;
                border-collapse: collapse;
            }
            .calendar th, .calendar td {
                width: 14.28%;
                padding: 10px;
                text-align: center;
                border: 1px solid #ccc;
            }
            .calendar th {
                background-color: #f5f5f5;
                font-weight: bold;
            }
            .calendar td.empty {
                background-color: #eaeaea;
            }
            .calendar td.day {
                cursor: pointer;
            }
        </style>
    </head>
    <body>
        
        <div class="content">
       
        <h1>Calendar</h1>

        <!-- Dropdowns for selecting month and year -->
        <form action="" method="get">
            <label for="month">Month:</label>
            <select id="month" name="month">
                <c:forEach var="m" begin="1" end="12">
                    <option value="${m}" ${selectedMonth == m ? "selected" : ""}>${m}</option>
                </c:forEach>
            </select>

            <label for="year">Year:</label>
            <select id="year" name="year">
                <c:forEach var="y" begin="2022" end="2030">
                    <option value="${y}" ${selectedYear == y ? "selected" : ""}>${y}</option>
                </c:forEach>
            </select>

            <button type="submit">Select</button>
        </form>

        <!-- Calendar table -->
        <table class="calendar">
            <thead>
                <tr>
                    <th>SUN</th>
                    <th>MON</th>
                    <th>TUE</th>
                    <th>WED</th>
                    <th>THU</th>
                    <th>FRI</th>
                    <th>SAT</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <% 
                        // Print empty cells until the first day of the month
                        int dayOfWeekCounter = 0;
                        for (int i = 0; i < startDayOfWeek; i++) {
                    %>
                    <td class="empty"></td>
                    <% 
                            dayOfWeekCounter++;
                        }

                        // Print the days of the month
                        for (int day = 1; day <= daysInMonth; day++) {
                            if (dayOfWeekCounter % 7 == 0 && dayOfWeekCounter != 0) {
                    %>
                </tr>
                <tr>
                    <%      } %>

                    <td class="day" onclick="window.location.href = 'appointment/doctor?date=<%= selectedYear %>-<%= String.format("%02d", selectedMonth) %>-<%= String.format("%02d", day) %>'">
                        <%= day %>
                    </td>
                    <% 
                            dayOfWeekCounter++;
                        }

                        // Fill remaining cells to complete the last week
                        while (dayOfWeekCounter % 7 != 0) {
                    %>
                    <td class="empty"></td>
                    <% 
                            dayOfWeekCounter++;
                        }
                    %>
                </tr>
            </tbody>
        </table>
                </div>
    </body>
</html>
