<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Schedule - Clinico</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50">

<nav class="bg-white shadow-lg">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
            <div class="flex items-center">
                <div class="flex-shrink-0 flex items-center">
                    <i class="fas fa-hospital-symbol text-3xl text-teal-600"></i>
                    <span class="ml-2 text-2xl font-bold text-gray-800">Clinico</span>
                </div>
                <div class="hidden md:ml-10 md:flex md:space-x-8">
                    <a href="${pageContext.request.contextPath}/doctor/dashboard" class="border-b-2 border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 text-sm font-medium">
                        Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/doctor/schedule" class="border-b-2 border-teal-500 text-gray-900 inline-flex items-center px-1 pt-1 text-sm font-medium">
                        Schedule
                    </a>
                </div>
            </div>
            <div class="flex items-center">
                <a href="${pageContext.request.contextPath}/logout" class="text-gray-500 hover:text-gray-700">
                    <i class="fas fa-sign-out-alt text-xl"></i>
                </a>
            </div>
        </div>
    </div>
</nav>

<main class="max-w-7xl mx-auto py-8 px-4 sm:px-6 lg:px-8">

    <div class="mb-8 flex items-center justify-between">
        <div>
            <h1 class="text-3xl font-bold text-gray-900">Weekly Schedule</h1>
            <p class="mt-2 text-sm text-gray-600">
                <fmt:formatDate value="${startOfWeek}" pattern="MMMM dd"/> - <fmt:formatDate value="${endOfWeek}" pattern="dd, yyyy"/>
            </p>
        </div>
        <div class="flex items-center space-x-3">
            <a href="${pageContext.request.contextPath}/doctor/schedule?date=${selectedDate.minusDays(7)}"
               class="px-4 py-2 bg-white border-2 border-gray-300 text-gray-700 font-semibold rounded-lg hover:bg-gray-50 transition">
                <i class="fas fa-chevron-left mr-2"></i>
                Previous
            </a>
            <a href="${pageContext.request.contextPath}/doctor/schedule"
               class="px-4 py-2 bg-teal-500 text-white font-semibold rounded-lg hover:bg-teal-600 transition">
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
                <thead class="bg-gradient-to-r from-teal-500 to-teal-600">
                <tr>
                    <jsp:useBean id="startOfWeek" scope="request" type="java.time.LocalDate"/>
                    <c:forEach begin="0" end="6" var="i">
                        <th scope="col" class="px-6 py-4 text-center text-sm font-bold text-white uppercase tracking-wider">
                            <div class="flex flex-col items-center">
                                <span class="text-xs text-teal-100"><fmt:formatDate value="${startOfWeek.plusDays(i)}" pattern="EEE"/></span>
                                <span class="text-2xl font-bold mt-1"><fmt:formatDate value="${startOfWeek.plusDays(i)}" pattern="dd"/></span>
                                <span class="text-xs text-teal-100 mt-1"><fmt:formatDate value="${startOfWeek.plusDays(i)}" pattern="MMM"/></span>
                            </div>
                        </th>
                    </c:forEach>
                </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                <tr>
                    <c:forEach begin="0" end="6" var="dayOffset">
                        <jsp:useBean id="dayOffset" type="java.lang.Integer"/>
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
                                                            <fmt:formatDate value="${consultation.heure}" pattern="HH:mm"/>
                                                        </span>
                                            </div>
                                            <p class="text-sm font-semibold text-gray-800">${consultation.patient.prenom} ${consultation.patient.nom}</p>
                                            <p class="text-xs text-gray-600 mt-1">
                                                <i class="fas fa-door-open mr-1"></i>
                                                    ${consultation.salle.nomSalle}
                                            </p>
                                            <div class="mt-2">
                                                <c:choose>
                                                    <c:when test="${consultation.statut == 'RESERVEE'}">
                                                        <span class="text-xs px-2 py-1 rounded-full bg-yellow-200 text-yellow-800 font-semibold">Pending</span>
                                                    </c:when>
                                                    <c:when test="${consultation.statut == 'VALIDEE'}">
                                                        <span class="text-xs px-2 py-1 rounded-full bg-green-200 text-green-800 font-semibold">Confirmed</span>
                                                    </c:when>
                                                    <c:when test="${consultation.statut == 'TERMINEE'}">
                                                        <span class="text-xs px-2 py-1 rounded-full bg-blue-200 text-blue-800 font-semibold">Completed</span>
                                                    </c:when>
                                                    <c:when test="${consultation.statut == 'ANNULEE'}">
                                                        <span class="text-xs px-2 py-1 rounded-full bg-red-200 text-red-800 font-semibold">Cancelled</span>
                                                    </c:when>
                                                </c:choose>
                                            </div>
                                            <div class="mt-2 flex space-x-1">
                                                <c:if test="${consultation.statut == 'VALIDEE'}">
                                                    <a href="${pageContext.request.contextPath}/doctor/complete-consultation?consultationId=${consultation.idConsultation}"
                                                       class="flex-1 text-center px-2 py-1 bg-teal-500 hover:bg-teal-600 text-white text-xs font-semibold rounded transition">
                                                        Complete
                                                    </a>
                                                </c:if>
                                                <a href="${pageContext.request.contextPath}/doctor/patient-history?patientId=${consultation.patient.id}"
                                                   class="flex-1 text-center px-2 py-1 bg-purple-500 hover:bg-purple-600 text-white text-xs font-semibold rounded transition">
                                                    History
                                                </a>
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${!hasConsultations}">
                                    <div class="text-center py-8 text-gray-400">
                                        <i class="fas fa-calendar-times text-3xl mb-2"></i>
                                        <p class="text-xs">No appointments</p>
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

    <div class="mt-8 bg-white rounded-xl shadow p-6">
        <h3 class="text-lg font-bold text-gray-800 mb-4">Legend</h3>
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div class="flex items-center space-x-2">
                <div class="w-4 h-4 bg-yellow-100 border-l-4 border-yellow-500 rounded"></div>
                <span class="text-sm text-gray-700">Pending</span>
            </div>
            <div class="flex items-center space-x-2">
                <div class="w-4 h-4 bg-green-100 border-l-4 border-green-500 rounded"></div>
                <span class="text-sm text-gray-700">Confirmed</span>
            </div>
            <div class="flex items-center space-x-2">
                <div class="w-4 h-4 bg-blue-100 border-l-4 border-blue-500 rounded"></div>
                <span class="text-sm text-gray-700">Completed</span>
            </div>
            <div class="flex items-center space-x-2">
                <div class="w-4 h-4 bg-red-100 border-l-4 border-red-500 rounded"></div>
                <span class="text-sm text-gray-700">Cancelled</span>
            </div>
        </div>
    </div>

</main>

</body>
</html>