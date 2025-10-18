<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Weekly Schedule - Clinic</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50">

<nav class="bg-white shadow-lg">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
            <div class="flex items-center">
                <i class="fas fa-hospital text-blue-600 text-2xl mr-3"></i>
                <span class="text-xl font-bold text-gray-800">Clinic Management</span>
            </div>
            <div class="flex items-center space-x-4">
                <a href="${pageContext.request.contextPath}/doctor/dashboard"
                   class="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md font-medium">
                    <i class="fas fa-home mr-2"></i>Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/doctor/schedule"
                   class="text-blue-600 px-3 py-2 rounded-md font-medium border-b-2 border-blue-600">
                    <i class="fas fa-calendar-alt mr-2"></i>Schedule
                </a>
                <form action="${pageContext.request.contextPath}/logout" method="post" class="inline">
                    <button type="submit"
                            class="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg transition duration-200">
                        <i class="fas fa-sign-out-alt mr-2"></i>Logout
                    </button>
                </form>
            </div>
        </div>
    </div>
</nav>

<main class="max-w-7xl mx-auto py-8 px-4 sm:px-6 lg:px-8">

    <div class="mb-8 flex items-center justify-between">
        <div>
            <h1 class="text-3xl font-bold text-gray-900">Weekly Schedule</h1>
            <p class="mt-2 text-sm text-gray-600">
                ${formattedStartDate} - ${formattedEndDate}
            </p>
        </div>
        <div class="flex items-center space-x-3">
            <a href="${pageContext.request.contextPath}/doctor/schedule?date=${selectedDate.minusDays(7)}"
               class="px-4 py-2 bg-white border-2 border-gray-300 text-gray-700 font-semibold rounded-lg hover:bg-gray-50 transition">
                <i class="fas fa-chevron-left mr-2"></i>Previous
            </a>
            <a href="${pageContext.request.contextPath}/doctor/schedule"
               class="px-4 py-2 bg-blue-500 text-white font-semibold rounded-lg hover:bg-blue-600 transition">
                Today
            </a>
            <a href="${pageContext.request.contextPath}/doctor/schedule?date=${selectedDate.plusDays(7)}"
               class="px-4 py-2 bg-white border-2 border-gray-300 text-gray-700 font-semibold rounded-lg hover:bg-gray-50 transition">
                Next
                <i class="fas fa-chevron-right ml-2"></i>
            </a>
        </div>
    </div>

    <c:if test="${not empty error}">
        <div class="mb-6 bg-red-50 border-l-4 border-red-400 p-4 rounded-lg">
            <div class="flex">
                <i class="fas fa-exclamation-circle text-red-400 text-xl"></i>
                <p class="ml-3 text-sm text-red-700">${error}</p>
            </div>
        </div>
    </c:if>

    <div class="bg-white rounded-2xl shadow-lg overflow-hidden">
        <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gradient-to-r from-blue-500 to-blue-600">
                <tr>
                    <c:forEach begin="0" end="6" var="i">
                        <th scope="col" class="px-6 py-4 text-center text-sm font-bold text-white uppercase tracking-wider">
                            <div class="flex flex-col items-center">
                                <span class="text-xs text-blue-100">${weekDayNames[i]}</span>
                                <span class="text-2xl font-bold mt-1">${weekDayNumbers[i]}</span>
                                <span class="text-xs text-blue-100 mt-1">${weekMonthNames[i]}</span>
                            </div>
                        </th>
                    </c:forEach>
                </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                <tr>
                    <c:forEach begin="0" end="6" var="dayOffset">
                        <c:set var="currentDay" value="${startOfWeek.plusDays(dayOffset)}"/>
                        <td class="px-4 py-4 align-top bg-gray-50">
                            <div class="space-y-2 min-h-[400px]">
                                <c:set var="hasConsultations" value="false"/>
                                <c:forEach items="${weekConsultations}" var="consultation">
                                    <c:if test="${consultation.date.equals(currentDay)}">
                                        <c:set var="hasConsultations" value="true"/>
                                        <div class="p-3 rounded-lg shadow-sm ${consultation.statut == 'VALIDEE' ? 'bg-green-100 border-l-4 border-green-500' : consultation.statut == 'TERMINEE' ? 'bg-blue-100 border-l-4 border-blue-500' : consultation.statut == 'RESERVEE' ? 'bg-yellow-100 border-l-4 border-yellow-500' : 'bg-red-100 border-l-4 border-red-500'}">
                                            <div class="flex items-center space-x-2 mb-2">
                                                <i class="fas fa-clock text-xs ${consultation.statut == 'VALIDEE' ? 'text-green-600' : consultation.statut == 'TERMINEE' ? 'text-blue-600' : consultation.statut == 'RESERVEE' ? 'text-yellow-600' : 'text-red-600'}"></i>
                                                <span class="text-xs font-bold ${consultation.statut == 'VALIDEE' ? 'text-green-800' : consultation.statut == 'TERMINEE' ? 'text-blue-800' : consultation.statut == 'RESERVEE' ? 'text-yellow-800' : 'text-red-800'}">
                                                        ${formattedTimes[consultation.idConsultation]}
                                                </span>
                                            </div>
                                            <p class="text-sm font-semibold text-gray-800 mb-1">
                                                    ${consultation.patient.prenom} ${consultation.patient.nom}
                                            </p>
                                            <div class="flex items-center space-x-2 text-xs text-gray-600">
                                                <i class="fas fa-door-open"></i>
                                                <span>Room ${consultation.salle.nomSalle}</span>
                                            </div>
                                            <div class="mt-2">
                                                <span class="inline-block px-2 py-1 text-xs font-semibold rounded ${consultation.statut == 'VALIDEE' ? 'bg-green-200 text-green-800' : consultation.statut == 'TERMINEE' ? 'bg-blue-200 text-blue-800' : consultation.statut == 'RESERVEE' ? 'bg-yellow-200 text-yellow-800' : 'bg-red-200 text-red-800'}">
                                                        ${consultation.statut}
                                                </span>
                                            </div>

                                            <c:if test="${consultation.statut == 'VALIDEE'}">
                                                <div class="mt-2">
                                                    <a href="${pageContext.request.contextPath}/doctor/complete-consultation?consultationId=${consultation.idConsultation}"
                                                       class="block text-center bg-blue-500 hover:bg-blue-600 text-white text-xs font-semibold py-1 px-2 rounded transition">
                                                        <i class="fas fa-edit mr-1"></i>Complete
                                                    </a>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:if>
                                </c:forEach>

                                <c:if test="${!hasConsultations}">
                                    <div class="flex items-center justify-center h-full text-gray-400">
                                        <div class="text-center">
                                            <i class="fas fa-calendar-times text-3xl mb-2"></i>
                                            <p class="text-xs">No appointments</p>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </td>
                    </c:forEach>
                </tr>
                </tbody>
            </table>
        </div>
    </div>

    <div class="mt-8 grid grid-cols-4 gap-4">
        <div class="bg-yellow-50 border-l-4 border-yellow-500 p-4 rounded">
            <div class="flex items-center">
                <i class="fas fa-clock text-yellow-600 text-xl mr-3"></i>
                <div>
                    <p class="text-xs text-gray-600">Reserved</p>
                    <p class="text-sm font-semibold text-gray-800">Pending Validation</p>
                </div>
            </div>
        </div>
        <div class="bg-green-50 border-l-4 border-green-500 p-4 rounded">
            <div class="flex items-center">
                <i class="fas fa-check-circle text-green-600 text-xl mr-3"></i>
                <div>
                    <p class="text-xs text-gray-600">Validated</p>
                    <p class="text-sm font-semibold text-gray-800">Confirmed</p>
                </div>
            </div>
        </div>
        <div class="bg-blue-50 border-l-4 border-blue-500 p-4 rounded">
            <div class="flex items-center">
                <i class="fas fa-clipboard-check text-blue-600 text-xl mr-3"></i>
                <div>
                    <p class="text-xs text-gray-600">Completed</p>
                    <p class="text-sm font-semibold text-gray-800">Finished</p>
                </div>
            </div>
        </div>
        <div class="bg-red-50 border-l-4 border-red-500 p-4 rounded">
            <div class="flex items-center">
                <i class="fas fa-times-circle text-red-600 text-xl mr-3"></i>
                <div>
                    <p class="text-xs text-gray-600">Cancelled</p>
                    <p class="text-sm font-semibold text-gray-800">Not Happening</p>
                </div>
            </div>
        </div>
    </div>

</main>

</body>
</html>