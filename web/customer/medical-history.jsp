<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Medical Visit History - SASUCare </title>
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
        <style>
            /* Custom CSS for the medical history page */
            .bg-primary {
                background-color: #3b82f6;
            }
            .bg-primary-100 {
                background-color: #dbeafe;
            }
            .text-primary {
                color: #3b82f6;
            }
            .text-primary-600 {
                color: #2563eb;
            }
            .text-primary-800 {
                color: #1e40af;
            }
            .border-primary-600 {
                border-color: #2563eb;
            }
            .hover\:bg-primary-700:hover {
                background-color: #1d4ed8;
            }
            .bg-primary-100 {
                background-color: #dbeafe;
            }
            .text-primary-800 {
                color: #1e40af;
            }

            /* Animation for loading spinner */
            @keyframes spin {
                from {
                    transform: rotate(0deg);
                }
                to {
                    transform: rotate(360deg);
                }
            }
            .animate-spin {
                animation: spin 1s linear infinite;
            }

            /* Modal styles */
            .modal-overlay {
                background-color: rgba(0, 0, 0, 0.5);
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 50;
            }
            .modal-hidden {
                display: none;
            }
        </style>
    </head>
    <body class="bg-gray-50 min-h-screen">
        <jsp:include page="../Header.jsp"/>
        <!-- Main Content -->
        <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
            <div class="mb-8">
                <h2 class="text-2xl font-semibold text-gray-900">${sessionScope.currentCustomer.fullname}'s Medical Visit History</h2>
                <p class="mt-1 text-gray-600">View and manage your past medical visits</p>
            </div>

            <!-- Filter Section -->
            <div class="bg-white rounded-lg shadow mb-6">
                <div class="p-6">
                    <h3 class="text-lg font-medium text-gray-900 mb-4"></h3>
                    <form action="<c:url value='/customer/medical-history'/>" method="get" id="filterForm">
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <!-- Doctor Filter -->
                            <div>
                                <label for="doctorId" class="block text-sm font-medium text-gray-700 mb-1">Doctor</label>
                                <select 
                                    id="doctorId" 
                                    name="doctorId" 
                                    class="block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm rounded-md"
                                    onchange="this.form.submit()"
                                    >
                                    <option value="">All Doctors</option>
                                    <c:forEach items="${doctors}" var="doctor">
                                        <option value="${doctor.id}" ${param.doctorId eq doctor.id ? 'selected' : ''}>
                                            ${doctor.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Date Range Filter -->
                            <div>
                                <label for="startDate" class="block text-sm font-medium text-gray-700 mb-1">Date Range From</label>
                                <input type="date" id="startDate" name="startDate" class="w-full shadow-sm focus:ring-primary-500 focus:border-primary-500 sm:text-sm border-gray-300 rounded-md" value="${param.startDate}">
                            </div>
                            <div>
                                <label for="endDate" class="block text-sm font-medium text-gray-700 mb-1">Date Range To</label>
                                <input type="date" id="endDate" name="endDate" class="w-full shadow-sm focus:ring-primary-500 focus:border-primary-500 sm:text-sm border-gray-300 rounded-md" value="${param.endDate}">
                            </div>
                        </div>
                        <div class="mt-6 flex justify-end">
                            <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded-md">Apply Filters</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Visit History Table -->
            <div class="bg-white rounded-lg shadow overflow-hidden">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Visit Date
                                <svg class="ml-1 h-4 w-4 text-gray-400 group-hover:text-gray-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 15l7-7 7 7" />
                                </svg>
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Doctor
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Reason for Visit
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Diagnoses
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Treatment Plan
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Next Appointment
                            </th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Appointment Status
                            </th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        <c:forEach items="${visitHistoryList}" var="visit">
                            <tr>
                                <td class="px-6 py-4">${visit.visitDate}</td>
                                <td class="px-6 py-4">
                                    <c:forEach var="doctor" items="${doctors}">
                                        <c:if test="${doctor.id eq visit.doctorId}">
                                            ${doctor.name}
                                        </c:if>
                                    </c:forEach>
                                </td>
                                <td class="px-6 py-4">${visit.reasonForVisit}</td>
                                <td class="px-6 py-4">${visit.diagnoses}</td>
                                <td class="px-6 py-4">${visit.treatmentPlan}</td>
                                <td class="px-6 py-4">${visit.nextAppointment}</td>
                                <td class="px-6 py-4">
                                    <span class="inline-flex px-2 py-1 text-xs font-semibold rounded-full
                                          ${visit.appointment.status == 'Completed' ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800'}">
                                        ${visit.appointment.status}
                                    </span>
                                </td>

                                <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                    <button
                                        onclick="viewDetails(${visit.id})"
                                        class="text-primary-600 hover:text-primary-900 mr-3"
                                        >
                                        <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                        </svg>
                                    </button>

                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Modal for Visit Details -->
            <div id="visitDetailsModal" class="modal">
                <div class="modal-content">
                    <span class="close" onclick="closeModal()">×</span>
                    <h2>Visit Details</h2>
                    <p><strong>Visit Date:</strong> <span id="modalVisitDate"></span></p>
                    <p><strong>Doctor:</strong> <span id="modalDoctor"></span></p>
                    <p><strong>Reason For Visit:</strong> <span id="modalReasonForVisit"></span></p>
                    <p><strong>Diagnoses:</strong> <span id="modalDiagnoses"></span></p>
                    <p><strong>Treatment Plan:</strong> <span id="modalTreatmentPlan"></span></p>
                    <p><strong>Next Appointment:</strong> <span id="modalNextAppointment"></span></p>
                </div>
            </div>


            <!-- Print functionality -->
            <div class="mt-4">
                <button onclick="window.print()" class="px-4 py-2 bg-green-600 text-white rounded-md">Print Report</button>
            </div>
        </main>
        <jsp:include page="../Footer.jsp"/>
        <script>
            
            // JavaScript functions to handle interactions
            function toggleSortDirection() {
                const sortDirectionInput = document.getElementById('sortDirection');
                sortDirectionInput.value = sortDirectionInput.value === 'asc' ? 'desc' : 'asc';
                document.getElementById('filterForm').submit();
            }

            function clearFilters() {
                document.getElementById('doctorId').value = '';
                document.getElementById('startDate').value = '';
                document.getElementById('endDate').value = '';
                document.getElementById('page').value = '1';
                document.getElementById('filterForm').submit();
            }

            function removeFilter(filterType) {
                document.getElementById(filterType).value = filterType === 'doctorId' ? '' : '';
                document.getElementById('page').value = '1';
                document.getElementById('filterForm').submit();
            }

            function goToPage(pageNumber) {
                if (pageNumber < 1 || pageNumber > <c:out value="${pagination.totalPages}" default="1" />)
                    return;

                document.getElementById('page').value = pageNumber;
                document.getElementById('filterForm').submit();
            }

            // Function to open a modal for Visit Details
            // Function to open a modal for Visit Details
            // Function to open a modal for Visit Details
            function viewDetails(visitId) {
                // Fetch the visit details by ID and show in a modal
                fetch( `/SWP391_GR6/visit-details/`+visitId)
                        .then(response => {
                            if (!response.ok) {
                                throw new Error("Error fetching visit details");
                            }
                            return response.json();  // Parse the JSON response
                        })
                        .then(visit => {
                            // Fill the modal with visit details
                            document.getElementById('modalVisitDate').textContent = visit.visitDate;
                            document.getElementById('modalDoctor').textContent = visit.doctorName;
                            document.getElementById('modalReasonForVisit').textContent = visit.reasonForVisit;
                            document.getElementById('modalDiagnoses').textContent = visit.diagnoses;
                            document.getElementById('modalTreatmentPlan').textContent = visit.treatmentPlan;
                            document.getElementById('modalNextAppointment').textContent = visit.nextAppointment;

                            // Show the modal
                            document.getElementById('visitDetailsModal').style.display = 'block';
                        })
                        .catch(err => {
                            console.error("Error fetching visit details:", err);
                            alert("There was an error fetching the visit details.");
                        });
            }

// Close the modal
            function closeModal() {
                document.getElementById('visitDetailsModal').style.display = 'none';
            }



            // Function to download visit details as a PDF
            function downloadVisitReport(visitId) {
                const visitUrl = `/visit-report/${visitId}`;

                fetch(visitUrl, {
                    method: 'GET',
                    headers: {
                        'Content-Type': 'application/pdf'
                    }
                })
                        .then(response => response.blob())
                        .then(blob => {
                            // Create a link element to trigger the download
                            const link = document.createElement('a');
                            link.href = URL.createObjectURL(blob);
                            link.download = `Visit_Report_${visitId}.pdf`;
                            link.click();
                        })
                        .catch(err => console.error("Error downloading visit report:", err));
            }
        </script>

    </body>
</html>
