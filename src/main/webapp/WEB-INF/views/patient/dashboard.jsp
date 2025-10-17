<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard - Clinico</title>
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
                    <a href="${pageContext.request.contextPath}/doctor/dashboard" class="border-b-2 border-teal-500 text-gray-900 inline-flex items-center px-1 pt-1 text-sm font-medium">
                        Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/doctor/schedule" class="border-b-2 border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 text-sm font-medium">
                        Schedule
                    </a>
                </div>
            </div>
            <div class="flex items-center">
                <div class="flex items-center space-x-3">
                    <div class="text-right">
                        <p class="text-sm font-medium text-gray-700">Dr. ${docteur.nom}</p>
                        <p class="text-xs text-gray-500">${docteur.specialite}</p>
                    </div>
                    <div class="h-10 w-10 rounded-full bg-gradient-to-r from-teal-500 to-teal-600 flex items-center justify-center text-white font-semibold">
                        ${docteur.prenom.substring(0,1)}${docteur.nom.substring(0,1)}
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="ml-4 text-gray-500 hover:text-gray-700">
                    <i class="fas fa-sign-out-alt text-xl"></i>
                </a>
            </div>
        </div>
    </div>
</nav>

<main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">

    <div class="px-4 py-6 sm:px-0">
        <div class="mb-6">
            <h1 class="text-3xl font-bold text-gray-900">Welcome back, Dr. ${docteur.nom}!</h1>
            <p class="mt-1 text-sm text-gray-600">${docteur.departement.nom} Department • Room ${docteur.salle != null ? docteur.salle.nomSalle : 'Not Assigned'}</p>
        </div>

        <c:if test="${not empty param.success}">
            <div class="mb-6 bg-green-50 border-l-4 border-green-400 p-4 rounded-lg">
                <div class="flex">
                    <i class="fas fa-check-circle text-green-400 text-xl"></i>
                    <p class="ml-3 text-sm text-green-700">${param.success}</p>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty param.error}">
            <div class="mb-6 bg-red-50 border-l-4 border-red-400 p-4 rounded-lg">
                <div class="flex">
                    <i class="fas fa-exclamation-circle text-red-400 text-xl"></i>
                    <p class="ml-3 text-sm text-red-700">${param.error}</p>
                </div>
            </div>
        </c:if>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            <div class="bg-gradient-to-br from-teal-500 to-teal-600 rounded-2xl shadow-lg p-6 text-white">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-teal-100 text-sm font-medium">Today's</p>
                        <p class="text-3xl font-bold mt-2">${todayConsultations.size()}</p>
                        <p class="text-teal-100 text-xs mt-1">Consultations</p>
                    </div>
                    <div class="bg-white/20 rounded-full p-4">
                        <i class="fas fa-calendar-day text-3xl"></i>
                    </div>
                </div>
            </div>

            <div class="bg-gradient-to-br from-yellow-500 to-yellow-600 rounded-2xl shadow-lg p-6 text-white">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-yellow-100 text-sm font-medium">Pending</p>
                        <p class="text-3xl font-bold mt-2">${pendingValidations.size()}</p>
                        <p class="text-yellow-100 text-xs mt-1">Validations</p>
                    </div>
                    <div class="bg-white/20 rounded-full p-4">
                        <i class="fas fa-clock text-3xl"></i>
                    </div>
                </div>
            </div>

            <div class="bg-gradient-to-br from-purple-500 to-purple-600 rounded-2xl shadow-lg p-6 text-white">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-purple-100 text-sm font-medium">Upcoming</p>
                        <p class="text-3xl font-bold mt-2">${upcomingConsultations.size()}</p>
                        <p class="text-purple-100 text-xs mt-1">Appointments</p>
                    </div>
                    <div class="bg-white/20 rounded-full p-4">
                        <i class="fas fa-calendar-check text-3xl"></i>
                    </div>
                </div>
            </div>
        </div>

        <c:if test="${not empty pendingValidations}">
            <div class="bg-white rounded-2xl shadow-lg overflow-hidden mb-8">
                <div class="px-6 py-5 border-b border-gray-200 bg-gradient-to-r from-yellow-50 to-white">
                    <h2 class="text-xl font-bold text-gray-800 flex items-center">
                        <i class="fas fa-hourglass-half text-yellow-600 mr-3"></i>
                        Pending Validations
                    </h2>
                </div>

                <div class="p-6 space-y-4">
                    <c:forEach items="${pendingValidations}" var="consultation">
                        <div class="border-l-4 border-yellow-500 bg-gradient-to-r from-yellow-50 to-white rounded-lg p-5">
                            <div class="flex items-start justify-between">
                                <div class="flex-1">
                                    <div class="flex items-center space-x-4">
                                        <div class="bg-yellow-100 rounded-full p-3">
                                            <i class="fas fa-user text-yellow-600 text-xl"></i>
                                        </div>
                                        <div>
                                            <h3 class="text-lg font-bold text-gray-800">${consultation.patient.prenom} ${consultation.patient.nom}</h3>
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
                                    </div>
                                </div>

                                <div class="ml-4 flex space-x-2">
                                    <form action="${pageContext.request.contextPath}/doctor/validate-consultation" method="post" class="inline">
                                        <input type="hidden" name="consultationId" value="${consultation.idConsultation}">
                                        <input type="hidden" name="action" value="validate">
                                        <button type="submit" class="px-4 py-2 bg-green-500 hover:bg-green-600 text-white text-sm font-semibold rounded-lg transition">
                                            <i class="fas fa-check mr-1"></i>
                                            Accept
                                        </button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/doctor/validate-consultation" method="post" class="inline" onsubmit="return confirm('Are you sure you want to refuse this consultation?');">
                                        <input type="hidden" name="consultationId" value="${consultation.idConsultation}">
                                        <input type="hidden" name="action" value="refuse">
                                        <button type="submit" class="px-4 py-2 bg-red-500 hover:bg-red-600 text-white text-sm font-semibold rounded-lg transition">
                                            <i class="fas fa-times mr-1"></i>
                                            Refuse
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>

        <div class="bg-white rounded-2xl shadow-lg overflow-hidden">
            <div class="px-6 py-5 border-b border-gray-200 bg-gradient-to-r from-gray-50 to-white">
                <h2 class="text-xl font-bold text-gray-800 flex items-center">
                    <i class="fas fa-calendar-alt text-teal-600 mr-3"></i>
                    Today's Schedule
                </h2>
            </div>

            <div class="p-6">
                <c:choose>
                    <c:when test="${empty todayConsultations}">
                        <div class="text-center py-12">
                            <i class="fas fa-calendar-check text-6xl text-gray-300 mb-4"></i>
                            <p class="text-gray-500 text-lg">No consultations scheduled for today</p>
                            <p class="text-gray-400 text-sm mt-2">Enjoy your day!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="space-y-4">
                            <c:forEach items="${todayConsultations}" var="consultation">
                                <div class="border-l-4 ${consultation.statut == 'VALIDEE' ? 'border-green-500 bg-green-50' : consultation.statut == 'TERMINEE' ? 'border-blue-500 bg-blue-50' : 'border-gray-300 bg-gray-50'} rounded-lg p-5 hover:shadow-md transition">
                                    <div class="flex items-start justify-between">
                                        <div class="flex-1">
                                            <div class="flex items-center space-x-4">
                                                <div class="bg-teal-100 rounded-full p-3">
                                                    <i class="fas fa-user text-teal-600 text-xl"></i>
                                                </div>
                                                <div>
                                                    <h3 class="text-lg font-bold text-gray-800">${consultation.patient.prenom} ${consultation.patient.nom}</h3>
                                                    <div class="flex items-center space-x-4 mt-2 text-sm text-gray-600">
                                                        <div class="flex items-center">
                                                            <i class="fas fa-clock text-teal-500 mr-2"></i>
                                                                ${formattedTimes[consultation.idConsultation]}
                                                        </div>
                                                        <div class="flex items-center">
                                                            <i class="fas fa-door-open text-teal-500 mr-2"></i>
                                                            Room ${consultation.salle.nomSalle}
                                                        </div>
                                                    </div>
                                                    <div class="mt-2">
                                                        <c:choose>
                                                            <c:when test="${consultation.statut == 'RESERVEE'}">
                                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-yellow-100 text-yellow-800">
                                                                        <i class="fas fa-clock mr-1"></i>
                                                                        Pending
                                                                    </span>
                                                            </c:when>
                                                            <c:when test="${consultation.statut == 'VALIDEE'}">
                                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-green-100 text-green-800">
                                                                        <i class="fas fa-check-circle mr-1"></i>
                                                                        Confirmed
                                                                    </span>
                                                            </c:when>
                                                            <c:when test="${consultation.statut == 'TERMINEE'}">
                                                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-blue-100 text-blue-800">
                                                                        <i class="fas fa-check-double mr-1"></i>
                                                                        Completed
                                                                    </span>
                                                            </c:when>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="ml-4 flex flex-col space-y-2">
                                            <c:if test="${consultation.statut == 'VALIDEE'}">
                                                <a href="${pageContext.request.contextPath}/doctor/complete-consultation?consultationId=${consultation.idConsultation}"
                                                   class="px-4 py-2 bg-teal-500 hover:bg-teal-600 text-white text-sm font-semibold rounded-lg transition text-center">
                                                    <i class="fas fa-file-medical mr-1"></i>
                                                    Complete
                                                </a>
                                            </c:if>
                                            <a href="${pageContext.request.contextPath}/doctor/patient-history?patientId=${consultation.patient.id}"
                                               class="px-4 py-2 bg-purple-500 hover:bg-purple-600 text-white text-sm font-semibold rounded-lg transition text-center">
                                                <i class="fas fa-history mr-1"></i>
                                                History
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </div>
</main>

</body>
</html>