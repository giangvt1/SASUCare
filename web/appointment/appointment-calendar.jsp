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
            :root {
                --primary-color: #4DA8DA;
                --primary-light: #E8F4F9;
                --primary-dark: #2980B9;
                --disabled-color:rgba(248, 248, 248, 0.85);
                --border-color: #BFDFF2;
                --text-color: #333;
            }

            .content {
                max-width: 1200px;
                margin: 0 auto;
                padding: 20px;
            }

            h1 {
                color: var(--primary-dark);
                margin-bottom: 20px;
            }

            .calendar {
                width: 100%;
                border-collapse: collapse;
                box-shadow: 0 2px 8px rgba(77, 168, 218, 0.1);
                margin-top: 20px;
            }

            .calendar th, .calendar td {
                width: 14.28%;
                padding: 12px;
                text-align: center;
                border: 1px solid var(--border-color);
            }

            .calendar th {
                background-color: var(--primary-color);
                color: white;
                font-weight: bold;
                text-transform: uppercase;
                font-size: 0.9em;
            }

            .calendar td.empty {
                background-color: var(--primary-light);
            }

            .calendar td.day {
                cursor: pointer;
                background-color: white;
                transition: background-color 0.2s ease;
            }

            .calendar td.day:hover {
                background-color: var(--primary-light);
                color: var(--primary-dark);
            }

            .calendar td.disabled-day {
                background-color: var(--disabled-color);
                color: #888;
                cursor: not-allowed;
            }

            /* Form styling */
            form {
                margin-bottom: 20px;
                display: flex;
                gap: 15px;
                align-items: center;
            }

            label {
                color: var(--text-color);
                font-weight: 500;
            }

            select {
                padding: 8px 12px;
                border: 1px solid var(--border-color);
                border-radius: 4px;
                background-color: white;
                color: var(--text-color);
                cursor: pointer;
                transition: border-color 0.2s ease;
            }

            select:hover, select:focus {
                border-color: var(--primary-color);
                outline: none;
            }

            button {
                padding: 8px 16px;
                background-color: var(--primary-color);
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                transition: background-color 0.2s ease;
            }

            button:hover {
                background-color: var(--primary-dark);
            }

            @media (max-width: 768px) {
                .calendar th, .calendar td {
                    padding: 8px;
                    font-size: 0.9em;
                }

                form {
                    flex-wrap: wrap;
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="../Header.jsp"/>

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
                        <% } 
                        // Xác định ngày trong vòng lặp
                        LocalDate loopDate = LocalDate.of(selectedYear, selectedMonth, day);
                        boolean isDisabled = loopDate.isBefore(currentDate) || loopDate.isEqual(currentDate);
                        %>

                        <td class="<%= isDisabled ? "disabled-day" : "day" %>" 
                            <%= !isDisabled ? "onclick=\"window.location.href = 'appointment/doctor?date=" + loopDate + "'\"" : "" %>>
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
        <jsp:include page="../Footer.jsp"/>
    </body>
</html>
