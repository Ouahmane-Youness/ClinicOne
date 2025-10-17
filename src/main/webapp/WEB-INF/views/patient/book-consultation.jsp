<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Consultation - Clinico</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50">

<nav class="bg-white shadow-lg">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
            <div class="flex items-center">
                <div class="flex-shrink-0 flex items-center">
                    <i class="fas fa-hospital-symbol text-3xl text-blue-600"></i>
                    <span class="ml-2 text-2xl font-bold text-gray-800">Clinico</span>
                </div>
                <div class="hidden md:ml-10 md:flex md:space-x-8">
                    <a href="${pageContext.request.contextPath}/patient/dashboard" class="border-b-2 border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 text-sm font-medium">
                        Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/patient/book-consultation" class="border-b-2 border-blue-500 text-gray-900 inline-flex items-center px-1 pt-1 text-sm font-medium">
                        Book Consultation
                    </a>
                    <a href="${pageContext.request.contextPath}/patient/history" class="border-b-2 border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 text-sm font-medium">
                        History
                    </a>
                    <a href="${pageContext.request.contextPath}/patient/profile" class="border-b-2 border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 text-sm font-medium">
                        Profile
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

<main class="max-w-5xl mx-auto py-8 px-4 sm:px-6 lg:px-8">

    <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900">Book a Consultation</h1>
        <p class="mt-2 text-sm text-gray-600">Choose a department, doctor, date, and time for your appointment</p>
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
        <div class="px-8 py-6 bg-gradient-to-r from-blue-500 to-blue-600">
            <div class="flex items-center space-x-8">
                <div class="flex items-center space-x-3">
                    <div class="w-10 h-10 rounded-full ${not empty selectedDepartementId ? 'bg-white text-blue-600' : 'bg-blue-400 text-white'} flex items-center justify-center font-bold">
                        1
                    </div>
                    <span class="text-white font-semibold">Department</span>
                </div>
                <i class="fas fa-arrow-right text-white"></i>
                <div class="flex items-center space-x-3">
                    <div class="w-10 h-10 rounded-full ${not empty selectedDocteurId ? 'bg-white text-blue-600' : 'bg-blue-400 text-white'} flex items-center justify-center font-bold">
                        2
                    </div>
                    <span class="text-white font-semibold">Doctor & Date</span>
                </div>
                <i class="fas fa-arrow-right text-white"></i>
                <div class="flex items-center space-x-3">
                    <div class="w-10 h-10 rounded-full ${not empty availableSlots ? 'bg-white text-blue-600' : 'bg-blue-400 text-white'} flex items-center justify-center font-bold">
                        3
                    </div>
                    <span class="text-white font-semibold">Time</span>
                </div>
            </div>
        </div>

        <div class="p-8">

            <div class="mb-8">
                <label class="block text-lg font-bold text-gray-800 mb-4">
                    <i class="fas fa-building text-blue-600 mr-2"></i>
                    Step 1: Select Department
                </label>
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                    <c:forEach items="${departements}" var="dept">
                        <a href="${pageContext.request.contextPath}/patient/book-consultation?departementId=${dept.idDepartement}"
                           class="block p-6 border-2 ${selectedDepartementId == dept.idDepartement ? 'border-blue-500 bg-blue-50' : 'border-gray-200 hover:border-blue-300'} rounded-xl transition">
                            <div class="flex items-center space-x-3">
                                <div class="w-12 h-12 rounded-full bg-gradient-to-br from-blue-400 to-blue-500 flex items-center justify-center text-white">
                                    <i class="fas fa-hospital text-xl"></i>
                                </div>
                                <div>
                                    <h3 class="font-bold text-gray-800">${dept.nom}</h3>
                                    <c:if test="${selectedDepartementId == dept.idDepartement}">
                                        <span class="text-xs text-blue-600 font-semibold">✓ Selected</span>
                                    </c:if>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </div>

            <c:if test="${not empty docteurs}">
                <div class="mb-8 pb-8 border-b border-gray-200">
                    <label class="block text-lg font-bold text-gray-800 mb-4">
                        <i class="fas fa-user-md text-blue-600 mr-2"></i>
                        Step 2: Select Doctor & Date
                    </label>
                    <div class="grid grid-cols-1 gap-4">
                        <c:forEach items="${docteurs}" var="docteur">
                            <div class="border-2 ${selectedDocteurId == docteur.id ? 'border-blue-500 bg-blue-50' : 'border-gray-200'} rounded-xl p-6">
                                <div class="flex items-start justify-between">
                                    <div class="flex items-start space-x-4">
                                        <div class="w-16 h-16 rounded-full bg-gradient-to-br from-purple-400 to-purple-500 flex items-center justify-center text-white text-xl font-bold">
                                                ${docteur.prenom.substring(0,1)}${docteur.nom.substring(0,1)}
                                        </div>
                                        <div>
                                            <h3 class="text-xl font-bold text-gray-800">Dr. ${docteur.nom} ${docteur.prenom}</h3>
                                            <p class="text-sm text-gray-600">${docteur.specialite}</p>
                                            <div class="mt-2 flex items-center text-sm text-gray-500">
                                                <i class="fas fa-door-open text-blue-500 mr-2"></i>
                                                <c:choose>
                                                    <c:when test="${not empty docteur.salle}">
                                                        Room ${docteur.salle.nomSalle}
                                                    </c:when>
                                                    <c:otherwise>
                                                        No room assigned
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    <div>
                                        <form action="${pageContext.request.contextPath}/patient/book-consultation" method="get" class="flex items-center space-x-2">
                                            <input type="hidden" name="departementId" value="${selectedDepartementId}">
                                            <input type="hidden" name="docteurId" value="${docteur.id}">
                                            <input type="date" name="date" value="${selectedDate}" min="${java.time.LocalDate.now()}" required
                                                   class="px-4 py-2 border-2 border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none">
                                            <button type="submit" class="px-4 py-2 bg-gradient-to-r from-blue-500 to-blue-600 text-white font-semibold rounded-lg hover:from-blue-600 hover:to-blue-700 transition">
                                                Check Slots
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty availableSlots}">
                <div>
                    <label class="block text-lg font-bold text-gray-800 mb-4">
                        <i class="fas fa-clock text-blue-600 mr-2"></i>
                        Step 3: Select Time Slot
                    </label>
                    <form action="${pageContext.request.contextPath}/patient/book-consultation" method="post">
                        <input type="hidden" name="docteurId" value="${selectedDocteurId}">
                        <input type="hidden" name="date" value="${selectedDate}">

                        <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-3 mb-6">
                            <c:forEach items="${availableSlots}" var="slot">
                                <label class="relative">
                                    <input type="radio" name="time" value="${slot}" required class="peer hidden">
                                    <div class="p-4 border-2 border-gray-200 rounded-lg text-center cursor-pointer peer-checked:border-blue-500 peer-checked:bg-blue-50 hover:border-blue-300 transition">
                                        <i class="fas fa-clock text-blue-500 mb-1"></i>
                                        <p class="font-semibold text-gray-800">${slot}</p>
                                    </div>
                                </label>
                            </c:forEach>
                        </div>

                        <div class="flex justify-end">
                            <button type="submit" class="px-8 py-3 bg-gradient-to-r from-green-500 to-green-600 text-white font-bold rounded-xl hover:from-green-600 hover:to-green-700 transition transform hover:scale-105 shadow-lg">
                                <i class="fas fa-check mr-2"></i>
                                Confirm Booking
                            </button>
                        </div>
                    </form>
                </div>
            </c:if>

        </div>
    </div>

</main>

</body>
</html>