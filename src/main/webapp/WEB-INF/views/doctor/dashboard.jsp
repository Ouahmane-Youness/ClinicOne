<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard - Clinic</title>
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
                   class="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md font-medium">
                    <i class="fas fa-calendar-alt mr-2"></i>Schedule
                </a>
                <div class="flex items-center space-x-3">
                    <div class="text-right">
                        <p class="text-sm font-medium text-gray-700">Dr. ${docteur.nom} ${docteur.prenom}</p>
                        <p class="text-xs text-gray-500">${docteur.specialite}</p>
                    </div>
                    <form action="${pageContext.request.contextPath}/logout" method="post" class="inline">
                        <button type="submit"
                                class="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg transition duration-200">
                            <i class="fas fa-sign-out-alt mr-2"></i>Logout
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</nav>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-800">Welcome, Dr. ${docteur.nom}</h1>
        <p class="text-gray-600 mt-2">Manage your consultations and patient appointments</p>
    </div>

    <c:if test="${not empty param.success}">
        <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-6 rounded">
            <div class="flex">
                <i class="fas fa-check-circle mt-1 mr-3"></i>
                <p>${param.success}</p>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty param.error}">
        <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded">
            <div class="flex">
                <i class="fas fa-exclamation-circle mt-1 mr-3"></i>
                <p>${param.error}</p>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded">
            <div class="flex">
                <i class="fas fa-exclamation-circle mt-1 mr-3"></i>
                <p>${error}</p>
            </div>
        </div>
    </c:if>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">

        <div class="bg-white rounded-lg shadow-md p-6 border-l-4 border-yellow-500">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-gray-500 text-sm font-medium uppercase">Pending Validations</p>
                    <p class="text-3xl font-bold text-gray-800 mt-2">
                        <c:choose>
                            <c:when test="${not empty pendingValidations}">
                                ${pendingValidations.size()}
                            </c:when>
                            <c:otherwise>
                                0
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <div class="bg-yellow-100 rounded-full p-4">
                    <i class="fas fa-clock text-yellow-600 text-2xl"></i>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-lg shadow-md p-6 border-l-4 border-blue-500">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-gray-500 text-sm font-medium uppercase">Today's Appointments</p>
                    <p class="text-3xl font-bold text-gray-800 mt-2">
                        <c:choose>
                            <c:when test="${not empty todayConsultations}">
                                ${todayConsultations.size()}
                            </c:when>
                            <c:otherwise>
                                0
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <div class="bg-blue-100 rounded-full p-4">
                    <i class="fas fa-calendar-day text-blue-600 text-2xl"></i>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-lg shadow-md p-6 border-l-4 border-green-500">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-gray-500 text-sm font-medium uppercase">Upcoming</p>
                    <p class="text-3xl font-bold text-gray-800 mt-2">
                        <c:choose>
                            <c:when test="${not empty upcomingConsultations}">
                                ${upcomingConsultations.size()}
                            </c:when>
                            <c:otherwise>
                                0
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <div class="bg-green-100 rounded-full p-4">
                    <i class="fas fa-calendar-check text-green-600 text-2xl"></i>
                </div>
            </div>
        </div>
    </div>

    <c:if test="${not empty pendingValidations}">
        <div class="bg-white rounded-lg shadow-md p-6 mb-8">
            <h2 class="text-2xl font-bold text-gray-800 mb-4 flex items-center">
                <i class="fas fa-exclamation-circle text-yellow-500 mr-3"></i>
                Pending Validations
            </h2>
            <div class="space-y-4">
                <c:forEach var="consultation" items="${pendingValidations}">
                    <div class="border border-yellow-200 rounded-lg p-4 bg-yellow-50 hover:shadow-md transition duration-200">
                        <div class="flex justify-between items-start">
                            <div class="flex-1">
                                <h3 class="text-lg font-semibold text-gray-800">
                                        ${consultation.patient.nom} ${consultation.patient.prenom}
                                </h3>
                                <div class="flex items-center space-x-4 mt-2 text-sm text-gray-600">
                                    <div class="flex items-center">
                                        <i class="fas fa-calendar text-yellow-500 mr-2"></i>
                                            ${formattedShortDates[consultation.idConsultation]}
                                    </div>
                                    <div class="flex items-center">
                                        <i class="fas fa-clock text-yellow-500 mr-2"></i>
                                            ${formattedTimes[consultation.idConsultation]}
                                    </div>
                                    <div class="flex items-center">
                                        <i class="fas fa-door-open text-yellow-500 mr-2"></i>
                                        Room ${consultation.salle.nomSalle}
                                    </div>
                                </div>
                            </div>
                            <div class="flex space-x-2 ml-4">
                                <form action="${pageContext.request.contextPath}/doctor/validate-consultation"
                                      method="post" class="inline">
                                    <input type="hidden" name="consultationId" value="${consultation.idConsultation}"/>
                                    <input type="hidden" name="action" value="validate"/>
                                    <button type="submit"
                                            class="bg-green-500 hover:bg-green-600 text-white px-4 py-2 rounded-lg transition duration-200">
                                        <i class="fas fa-check mr-2"></i>Validate
                                    </button>
                                </form>
                                <form action="${pageContext.request.contextPath}/doctor/validate-consultation"
                                      method="post" class="inline">
                                    <input type="hidden" name="consultationId" value="${consultation.idConsultation}"/>
                                    <input type="hidden" name="action" value="refuse"/>
                                    <button type="submit"
                                            class="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg transition duration-200">
                                        <i class="fas fa-times mr-2"></i>Refuse
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty todayConsultations}">
        <div class="bg-white rounded-lg shadow-md p-6 mb-8">
            <h2 class="text-2xl font-bold text-gray-800 mb-4 flex items-center">
                <i class="fas fa-calendar-day text-blue-500 mr-3"></i>
                Today's Appointments
            </h2>
            <div class="space-y-4">
                <c:forEach var="consultation" items="${todayConsultations}">
                    <div class="border border-blue-200 rounded-lg p-4 bg-blue-50 hover:shadow-md transition duration-200">
                        <div class="flex justify-between items-start">
                            <div class="flex-1">
                                <h3 class="text-lg font-semibold text-gray-800">
                                        ${consultation.patient.nom} ${consultation.patient.prenom}
                                </h3>
                                <div class="flex items-center space-x-4 mt-2 text-sm text-gray-600">
                                    <div class="flex items-center">
                                        <i class="fas fa-clock text-blue-500 mr-2"></i>
                                            ${formattedTimes[consultation.idConsultation]}
                                    </div>
                                    <div class="flex items-center">
                                        <i class="fas fa-door-open text-blue-500 mr-2"></i>
                                        Room ${consultation.salle.nomSalle}
                                    </div>
                                    <div class="flex items-center">
                                        <i class="fas fa-info-circle text-blue-500 mr-2"></i>
                                            ${consultation.statut}
                                    </div>
                                </div>
                            </div>
                            <c:if test="${consultation.statut == 'VALIDEE'}">
                                <a href="${pageContext.request.contextPath}/doctor/complete-consultation?consultationId=${consultation.idConsultation}"
                                   class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-lg transition duration-200">
                                    <i class="fas fa-edit mr-2"></i>Complete
                                </a>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty upcomingConsultations}">
        <div class="bg-white rounded-lg shadow-md p-6">
            <h2 class="text-2xl font-bold text-gray-800 mb-4 flex items-center">
                <i class="fas fa-calendar-alt text-green-500 mr-3"></i>
                Upcoming Appointments
            </h2>
            <div class="space-y-4">
                <c:forEach var="consultation" items="${upcomingConsultations}">
                    <div class="border border-gray-200 rounded-lg p-4 hover:shadow-md transition duration-200">
                        <div class="flex justify-between items-start">
                            <div class="flex-1">
                                <h3 class="text-lg font-semibold text-gray-800">
                                        ${consultation.patient.nom} ${consultation.patient.prenom}
                                </h3>
                                <div class="flex items-center space-x-4 mt-2 text-sm text-gray-600">
                                    <div class="flex items-center">
                                        <i class="fas fa-calendar text-gray-500 mr-2"></i>
                                            ${formattedShortDates[consultation.idConsultation]}
                                    </div>
                                    <div class="flex items-center">
                                        <i class="fas fa-clock text-gray-500 mr-2"></i>
                                            ${formattedTimes[consultation.idConsultation]}
                                    </div>
                                    <div class="flex items-center">
                                        <i class="fas fa-door-open text-gray-500 mr-2"></i>
                                        Room ${consultation.salle.nomSalle}
                                    </div>
                                    <div class="flex items-center">
                                        <i class="fas fa-info-circle text-gray-500 mr-2"></i>
                                            ${consultation.statut}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>

    <c:if test="${empty pendingValidations && empty todayConsultations && empty upcomingConsultations}">
        <div class="bg-white rounded-lg shadow-md p-12 text-center">
            <i class="fas fa-calendar-check text-gray-300 text-6xl mb-4"></i>
            <h3 class="text-xl font-semibold text-gray-600 mb-2">No Appointments</h3>
            <p class="text-gray-500">You have no scheduled or pending appointments at the moment.</p>
        </div>
    </c:if>

</div>

</body>
</html>