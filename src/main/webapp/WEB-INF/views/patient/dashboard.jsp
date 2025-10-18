<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard - Clinic</title>
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
                <a href="${pageContext.request.contextPath}/patient/dashboard"
                   class="text-blue-600 px-3 py-2 rounded-md font-medium border-b-2 border-blue-600">
                    <i class="fas fa-home mr-2"></i>Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/patient/book-consultation"
                   class="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md font-medium">
                    <i class="fas fa-calendar-plus mr-2"></i>Book
                </a>
                <a href="${pageContext.request.contextPath}/patient/history"
                   class="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md font-medium">
                    <i class="fas fa-history mr-2"></i>History
                </a>
                <a href="${pageContext.request.contextPath}/patient/profile"
                   class="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md font-medium">
                    <i class="fas fa-user mr-2"></i>Profile
                </a>
                <div class="flex items-center space-x-3">
                    <div class="text-right">
                        <p class="text-sm font-medium text-gray-700">${patient.prenom} ${patient.nom}</p>
                        <p class="text-xs text-gray-500">Patient</p>
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
        <h1 class="text-3xl font-bold text-gray-800">Welcome, ${patient.prenom}!</h1>
        <p class="text-gray-600 mt-2">Manage your appointments and medical records</p>
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

        <div class="bg-white rounded-lg shadow-md p-6 border-l-4 border-blue-500">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-gray-500 text-sm font-medium uppercase">Upcoming Appointments</p>
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
                <div class="bg-blue-100 rounded-full p-4">
                    <i class="fas fa-calendar-check text-blue-600 text-2xl"></i>
                </div>
            </div>
        </div>

        <a href="${pageContext.request.contextPath}/patient/book-consultation"
           class="bg-gradient-to-r from-green-500 to-green-600 rounded-lg shadow-md p-6 border-l-4 border-green-700 hover:shadow-lg transition duration-200">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-white text-sm font-medium uppercase opacity-90">Book New</p>
                    <p class="text-2xl font-bold text-white mt-2">Consultation</p>
                </div>
                <div class="bg-white bg-opacity-20 rounded-full p-4">
                    <i class="fas fa-plus-circle text-white text-2xl"></i>
                </div>
            </div>
        </a>

        <a href="${pageContext.request.contextPath}/patient/history"
           class="bg-white rounded-lg shadow-md p-6 border-l-4 border-purple-500 hover:shadow-lg transition duration-200">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-gray-500 text-sm font-medium uppercase">View Your</p>
                    <p class="text-2xl font-bold text-gray-800 mt-2">History</p>
                </div>
                <div class="bg-purple-100 rounded-full p-4">
                    <i class="fas fa-history text-purple-600 text-2xl"></i>
                </div>
            </div>
        </a>
    </div>

    <c:choose>
        <c:when test="${not empty upcomingConsultations}">
            <div class="bg-white rounded-lg shadow-md p-6">
                <h2 class="text-2xl font-bold text-gray-800 mb-4 flex items-center">
                    <i class="fas fa-calendar-alt text-blue-500 mr-3"></i>
                    Your Upcoming Appointments
                </h2>
                <div class="space-y-4">
                    <c:forEach var="consultation" items="${upcomingConsultations}">
                        <div class="border border-gray-200 rounded-lg p-5 hover:shadow-md transition duration-200 ${consultation.statut == 'RESERVEE' ? 'bg-yellow-50 border-l-4 border-yellow-500' : consultation.statut == 'VALIDEE' ? 'bg-green-50 border-l-4 border-green-500' : 'bg-gray-50'}">
                            <div class="flex justify-between items-start">
                                <div class="flex-1">
                                    <div class="flex items-center space-x-3 mb-3">
                                        <div class="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center">
                                            <i class="fas fa-user-md text-blue-600 text-xl"></i>
                                        </div>
                                        <div>
                                            <h3 class="text-lg font-semibold text-gray-800">
                                                Dr. ${consultation.docteur.nom} ${consultation.docteur.prenom}
                                            </h3>
                                            <p class="text-sm text-gray-600">${consultation.docteur.specialite}</p>
                                        </div>
                                    </div>

                                    <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mt-4">
                                        <div class="flex items-center space-x-2">
                                            <i class="fas fa-calendar text-gray-500"></i>
                                            <span class="text-sm text-gray-700">${formattedDates[consultation.idConsultation]}</span>
                                        </div>
                                        <div class="flex items-center space-x-2">
                                            <i class="fas fa-clock text-gray-500"></i>
                                            <span class="text-sm text-gray-700">${formattedTimes[consultation.idConsultation]}</span>
                                        </div>
                                        <div class="flex items-center space-x-2">
                                            <i class="fas fa-door-open text-gray-500"></i>
                                            <span class="text-sm text-gray-700">Room ${consultation.salle.nomSalle}</span>
                                        </div>
                                        <div class="flex items-center space-x-2">
                                            <i class="fas fa-info-circle ${consultation.statut == 'RESERVEE' ? 'text-yellow-500' : consultation.statut == 'VALIDEE' ? 'text-green-500' : 'text-gray-500'}"></i>
                                            <span class="text-sm font-semibold ${consultation.statut == 'RESERVEE' ? 'text-yellow-700' : consultation.statut == 'VALIDEE' ? 'text-green-700' : 'text-gray-700'}">${consultation.statut}</span>
                                        </div>
                                    </div>
                                </div>

                                <c:if test="${consultation.statut == 'RESERVEE' || consultation.statut == 'VALIDEE'}">
                                    <form action="${pageContext.request.contextPath}/patient/cancel-consultation"
                                          method="post"
                                          class="ml-4"
                                          onsubmit="return confirm('Are you sure you want to cancel this appointment?');">
                                        <input type="hidden" name="consultationId" value="${consultation.idConsultation}"/>
                                        <button type="submit"
                                                class="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg transition duration-200 text-sm font-semibold">
                                            <i class="fas fa-times mr-2"></i>Cancel
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="bg-white rounded-lg shadow-md p-12 text-center">
                <i class="fas fa-calendar-times text-gray-300 text-6xl mb-4"></i>
                <h3 class="text-xl font-semibold text-gray-600 mb-2">No Upcoming Appointments</h3>
                <p class="text-gray-500 mb-6">You don't have any scheduled appointments at the moment.</p>
                <a href="${pageContext.request.contextPath}/patient/book-consultation"
                   class="inline-block bg-blue-500 hover:bg-blue-600 text-white px-6 py-3 rounded-lg transition duration-200 font-semibold">
                    <i class="fas fa-calendar-plus mr-2"></i>Book a Consultation
                </a>
            </div>
        </c:otherwise>
    </c:choose>

</div>

</body>
</html>