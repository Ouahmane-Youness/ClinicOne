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
    <style>
        .card-hover {
            transition: all 0.3s ease;
        }
        .card-hover:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .pending-card {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        .today-card {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }
        .upcoming-card {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
        }
    </style>
</head>
<body class="bg-gray-50">

<nav class="bg-white shadow-lg border-b-4 border-blue-500">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
            <div class="flex items-center">
                <div class="flex items-center space-x-3">
                    <div class="w-10 h-10 bg-gradient-to-r from-blue-500 to-blue-600 rounded-lg flex items-center justify-center">
                        <i class="fas fa-hospital text-white text-xl"></i>
                    </div>
                    <div>
                        <span class="text-xl font-bold text-gray-800">Clinic Management</span>
                        <p class="text-xs text-gray-500">Doctor Portal</p>
                    </div>
                </div>
            </div>
            <div class="flex items-center space-x-4">
                <a href="${pageContext.request.contextPath}/doctor/dashboard"
                   class="bg-blue-100 text-blue-700 px-4 py-2 rounded-lg font-medium flex items-center space-x-2">
                    <i class="fas fa-home"></i>
                    <span>Dashboard</span>
                </a>
                <a href="${pageContext.request.contextPath}/doctor/schedule"
                   class="text-gray-700 hover:text-blue-600 px-4 py-2 rounded-lg font-medium flex items-center space-x-2 hover:bg-gray-100 transition">
                    <i class="fas fa-calendar-alt"></i>
                    <span>Schedule</span>
                </a>
                <div class="flex items-center space-x-3 bg-gray-100 rounded-lg px-4 py-2">
                    <div class="w-8 h-8 bg-gradient-to-r from-purple-500 to-purple-600 rounded-full flex items-center justify-center">
                        <span class="text-white text-sm font-bold">${docteur.prenom.substring(0,1)}</span>
                    </div>
                    <div class="text-right">
                        <p class="text-sm font-medium text-gray-700">Dr. ${docteur.nom} ${docteur.prenom}</p>
                        <p class="text-xs text-gray-500">${docteur.specialite}</p>
                    </div>
                </div>
                <form action="${pageContext.request.contextPath}/logout" method="post" class="inline">
                    <button type="submit"
                            class="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg transition duration-200 flex items-center space-x-2">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Logout</span>
                    </button>
                </form>
            </div>
        </div>
    </div>
</nav>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <div class="mb-8">
        <div class="flex items-center space-x-4 mb-4">
            <div class="w-16 h-16 bg-gradient-to-r from-blue-500 to-purple-600 rounded-xl flex items-center justify-center">
                <i class="fas fa-user-md text-white text-2xl"></i>
            </div>
            <div>
                <h1 class="text-3xl font-bold text-gray-800">Welcome back, Dr. ${docteur.nom}</h1>
                <p class="text-gray-600">Here's what's happening with your practice today</p>
            </div>
        </div>
    </div>

    <c:if test="${not empty param.success}">
        <div class="bg-gradient-to-r from-green-50 to-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-6 rounded-lg shadow-sm">
            <div class="flex items-center">
                <i class="fas fa-check-circle text-green-500 text-xl mr-3"></i>
                <p class="font-medium">${param.success}</p>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty param.error}">
        <div class="bg-gradient-to-r from-red-50 to-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded-lg shadow-sm">
            <div class="flex items-center">
                <i class="fas fa-exclamation-circle text-red-500 text-xl mr-3"></i>
                <p class="font-medium">${param.error}</p>
            </div>
        </div>
    </c:if>

    <!-- Statistics Overview -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <!-- Pending Validations -->
        <div class="pending-card text-white rounded-2xl p-6 card-hover">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-pink-100 text-sm font-medium uppercase tracking-wide">Pending Requests</p>
                    <p class="text-3xl font-bold mt-2">
                        <c:choose>
                            <c:when test="${not empty pendingValidations}">
                                ${pendingValidations.size()}
                            </c:when>
                            <c:otherwise>0</c:otherwise>
                        </c:choose>
                    </p>
                    <p class="text-pink-100 text-xs mt-1">Need your attention</p>
                </div>
                <div class="bg-white bg-opacity-20 rounded-full p-4">
                    <i class="fas fa-clock text-2xl"></i>
                </div>
            </div>
        </div>

        <!-- Today's Appointments -->
        <div class="today-card text-white rounded-2xl p-6 card-hover">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-blue-100 text-sm font-medium uppercase tracking-wide">Today's Schedule</p>
                    <p class="text-3xl font-bold mt-2">
                        <c:choose>
                            <c:when test="${not empty todayConsultations}">
                                ${todayConsultations.size()}
                            </c:when>
                            <c:otherwise>0</c:otherwise>
                        </c:choose>
                    </p>
                    <p class="text-blue-100 text-xs mt-1">Confirmed appointments</p>
                </div>
                <div class="bg-white bg-opacity-20 rounded-full p-4">
                    <i class="fas fa-calendar-day text-2xl"></i>
                </div>
            </div>
        </div>

        <!-- Total Patients -->
        <div class="upcoming-card text-white rounded-2xl p-6 card-hover">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-green-100 text-sm font-medium uppercase tracking-wide">Total Patients</p>
                    <p class="text-3xl font-bold mt-2">${totalPatients}</p>
                    <p class="text-green-100 text-xs mt-1">Under your care</p>
                </div>
                <div class="bg-white bg-opacity-20 rounded-full p-4">
                    <i class="fas fa-users text-2xl"></i>
                </div>
            </div>
        </div>

        <!-- Completed Today -->
        <div class="stats-card text-white rounded-2xl p-6 card-hover">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-purple-100 text-sm font-medium uppercase tracking-wide">Completed Today</p>
                    <p class="text-3xl font-bold mt-2">${completedToday}</p>
                    <p class="text-purple-100 text-xs mt-1">Consultations done</p>
                </div>
                <div class="bg-white bg-opacity-20 rounded-full p-4">
                    <i class="fas fa-check-double text-2xl"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Pending Validations Section -->
    <c:if test="${not empty pendingValidations}">
        <div class="bg-white rounded-2xl shadow-lg p-6 mb-8 border border-red-200">
            <div class="flex items-center justify-between mb-6">
                <div class="flex items-center space-x-3">
                    <div class="w-12 h-12 bg-red-100 rounded-xl flex items-center justify-center">
                        <i class="fas fa-exclamation-circle text-red-600 text-xl"></i>
                    </div>
                    <div>
                        <h2 class="text-2xl font-bold text-gray-800">Pending Validation Requests</h2>
                        <p class="text-gray-600 text-sm">These patients are waiting for your confirmation</p>
                    </div>
                </div>
                <span class="bg-red-100 text-red-800 text-xs font-semibold px-3 py-1 rounded-full">
                    ${pendingValidations.size()} pending
                </span>
            </div>
            <div class="grid gap-4">
                <c:forEach var="consultation" items="${pendingValidations}">
                    <div class="border-2 border-red-200 rounded-xl p-6 bg-gradient-to-r from-red-50 to-pink-50 hover:shadow-md transition duration-200">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center space-x-4">
                                <div class="w-12 h-12 bg-gradient-to-r from-red-500 to-pink-500 rounded-full flex items-center justify-center text-white font-bold text-lg">
                                    ${consultation.patient.prenom.substring(0,1)}${consultation.patient.nom.substring(0,1)}
                                </div>
                                <div>
                                    <h3 class="text-lg font-bold text-gray-800">
                                        ${consultation.patient.prenom} ${consultation.patient.nom}
                                    </h3>
                                    <div class="flex items-center space-x-4 mt-1">
                                        <div class="flex items-center text-sm text-gray-600">
                                            <i class="fas fa-calendar text-red-500 mr-2"></i>
                                            ${formattedShortDates[consultation.idConsultation]}
                                        </div>
                                        <div class="flex items-center text-sm text-gray-600">
                                            <i class="fas fa-clock text-red-500 mr-2"></i>
                                            ${formattedTimes[consultation.idConsultation]}
                                        </div>
                                        <div class="flex items-center text-sm text-gray-600">
                                            <i class="fas fa-door-open text-red-500 mr-2"></i>
                                            Room ${consultation.salle.nomSalle}
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="flex space-x-3">
                                <form action="${pageContext.request.contextPath}/doctor/validate-consultation" method="post" class="inline">
                                    <input type="hidden" name="consultationId" value="${consultation.idConsultation}"/>
                                    <input type="hidden" name="action" value="validate"/>
                                    <button type="submit" class="bg-green-500 hover:bg-green-600 text-white px-6 py-3 rounded-xl font-semibold transition duration-200 flex items-center space-x-2 shadow-lg">
                                        <i class="fas fa-check"></i>
                                        <span>Accept</span>
                                    </button>
                                </form>
                                <form action="${pageContext.request.contextPath}/doctor/validate-consultation" method="post" class="inline">
                                    <input type="hidden" name="consultationId" value="${consultation.idConsultation}"/>
                                    <input type="hidden" name="action" value="refuse"/>
                                    <button type="submit" class="bg-red-500 hover:bg-red-600 text-white px-6 py-3 rounded-xl font-semibold transition duration-200 flex items-center space-x-2 shadow-lg">
                                        <i class="fas fa-times"></i>
                                        <span>Decline</span>
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>

    <!-- Today's Appointments Section -->
    <c:if test="${not empty todayConsultations}">
        <div class="bg-white rounded-2xl shadow-lg p-6 mb-8 border border-blue-200">
            <div class="flex items-center justify-between mb-6">
                <div class="flex items-center space-x-3">
                    <div class="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
                        <i class="fas fa-calendar-day text-blue-600 text-xl"></i>
                    </div>
                    <div>
                        <h2 class="text-2xl font-bold text-gray-800">Today's Appointments</h2>
                        <p class="text-gray-600 text-sm">Your confirmed consultations for today</p>
                    </div>
                </div>
                <span class="bg-blue-100 text-blue-800 text-xs font-semibold px-3 py-1 rounded-full">
                    ${todayConsultations.size()} scheduled
                </span>
            </div>
            <div class="grid gap-4">
                <c:forEach var="consultation" items="${todayConsultations}">
                    <div class="border-2 border-blue-200 rounded-xl p-6 bg-gradient-to-r from-blue-50 to-indigo-50 hover:shadow-md transition duration-200">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center space-x-4">
                                <div class="w-12 h-12 bg-gradient-to-r from-blue-500 to-indigo-500 rounded-full flex items-center justify-center text-white font-bold text-lg">
                                    ${consultation.patient.prenom.substring(0,1)}${consultation.patient.nom.substring(0,1)}
                                </div>
                                <div>
                                    <h3 class="text-lg font-bold text-gray-800">
                                        ${consultation.patient.prenom} ${consultation.patient.nom}
                                    </h3>
                                    <div class="flex items-center space-x-4 mt-1">
                                        <div class="flex items-center text-sm text-gray-600">
                                            <i class="fas fa-clock text-blue-500 mr-2"></i>
                                            ${formattedTimes[consultation.idConsultation]}
                                        </div>
                                        <div class="flex items-center text-sm text-gray-600">
                                            <i class="fas fa-door-open text-blue-500 mr-2"></i>
                                            Room ${consultation.salle.nomSalle}
                                        </div>
                                        <div class="flex items-center text-sm text-gray-600">
                                            <i class="fas fa-envelope text-blue-500 mr-2"></i>
                                            ${consultation.patient.email}
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="flex space-x-3">
                                <a href="${pageContext.request.contextPath}/doctor/patient-history?patientId=${consultation.patient.id}"
                                   class="bg-purple-500 hover:bg-purple-600 text-white px-4 py-2 rounded-lg font-semibold transition duration-200 flex items-center space-x-2">
                                    <i class="fas fa-user-circle"></i>
                                    <span>History</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/doctor/complete-consultation?consultationId=${consultation.idConsultation}"
                                   class="bg-green-500 hover:bg-green-600 text-white px-4 py-2 rounded-lg font-semibold transition duration-200 flex items-center space-x-2">
                                    <i class="fas fa-stethoscope"></i>
                                    <span>Complete</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>

    <!-- Two Column Layout for Upcoming and Recent -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <!-- Upcoming Appointments -->
        <div class="bg-white rounded-2xl shadow-lg p-6 border border-green-200">
            <div class="flex items-center justify-between mb-6">
                <div class="flex items-center space-x-3">
                    <div class="w-10 h-10 bg-green-100 rounded-lg flex items-center justify-center">
                        <i class="fas fa-calendar-alt text-green-600"></i>
                    </div>
                    <div>
                        <h2 class="text-xl font-bold text-gray-800">Upcoming Appointments</h2>
                        <p class="text-gray-600 text-sm">Next few consultations</p>
                    </div>
                </div>
            </div>
            <c:choose>
                <c:when test="${not empty upcomingConsultations}">
                    <div class="space-y-4">
                        <c:forEach var="consultation" items="${upcomingConsultations}">
                            <div class="border border-green-200 rounded-lg p-4 bg-green-50 hover:shadow-sm transition duration-200">
                                <div class="flex items-center justify-between">
                                    <div>
                                        <h3 class="font-semibold text-gray-800">
                                            ${consultation.patient.prenom} ${consultation.patient.nom}
                                        </h3>
                                        <div class="flex items-center space-x-3 mt-1 text-sm text-gray-600">
                                            <div class="flex items-center">
                                                <i class="fas fa-calendar text-green-500 mr-1"></i>
                                                ${formattedShortDates[consultation.idConsultation]}
                                            </div>
                                            <div class="flex items-center">
                                                <i class="fas fa-clock text-green-500 mr-1"></i>
                                                ${formattedTimes[consultation.idConsultation]}
                                            </div>
                                        </div>
                                    </div>
                                    <span class="bg-green-100 text-green-800 text-xs font-semibold px-2 py-1 rounded">
                                        ${consultation.statut}
                                    </span>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-8">
                        <i class="fas fa-calendar-check text-gray-300 text-4xl mb-3"></i>
                        <p class="text-gray-500">No upcoming appointments</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Recent Completed -->
        <div class="bg-white rounded-2xl shadow-lg p-6 border border-purple-200">
            <div class="flex items-center justify-between mb-6">
                <div class="flex items-center space-x-3">
                    <div class="w-10 h-10 bg-purple-100 rounded-lg flex items-center justify-center">
                        <i class="fas fa-check-circle text-purple-600"></i>
                    </div>
                    <div>
                        <h2 class="text-xl font-bold text-gray-800">Recently Completed</h2>
                        <p class="text-gray-600 text-sm">Latest consultations</p>
                    </div>
                </div>
            </div>
            <c:choose>
                <c:when test="${not empty recentCompleted}">
                    <div class="space-y-4">
                        <c:forEach var="consultation" items="${recentCompleted}">
                            <div class="border border-purple-200 rounded-lg p-4 bg-purple-50 hover:shadow-sm transition duration-200">
                                <div class="flex items-center justify-between">
                                    <div>
                                        <h3 class="font-semibold text-gray-800">
                                            ${consultation.patient.prenom} ${consultation.patient.nom}
                                        </h3>
                                        <div class="flex items-center space-x-3 mt-1 text-sm text-gray-600">
                                            <div class="flex items-center">
                                                <i class="fas fa-calendar text-purple-500 mr-1"></i>
                                                ${formattedShortDates[consultation.idConsultation]}
                                            </div>
                                            <div class="flex items-center">
                                                <i class="fas fa-clock text-purple-500 mr-1"></i>
                                                ${formattedTimes[consultation.idConsultation]}
                                            </div>
                                        </div>
                                    </div>
                                    <span class="bg-purple-100 text-purple-800 text-xs font-semibold px-2 py-1 rounded">
                                        Completed
                                    </span>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-8">
                        <i class="fas fa-clipboard-check text-gray-300 text-4xl mb-3"></i>
                        <p class="text-gray-500">No recent completions</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="mt-8 bg-white rounded-2xl shadow-lg p-6">
        <h2 class="text-xl font-bold text-gray-800 mb-4">Quick Actions</h2>
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
            <a href="${pageContext.request.contextPath}/doctor/schedule"
               class="bg-gradient-to-r from-blue-500 to-blue-600 text-white p-4 rounded-xl text-center hover:from-blue-600 hover:to-blue-700 transition duration-200 card-hover">
                <i class="fas fa-calendar-alt text-2xl mb-2"></i>
                <p class="font-semibold">View Full Schedule</p>
            </a>
            <a href="#"
               class="bg-gradient-to-r from-green-500 to-green-600 text-white p-4 rounded-xl text-center hover:from-green-600 hover:to-green-700 transition duration-200 card-hover">
                <i class="fas fa-users text-2xl mb-2"></i>
                <p class="font-semibold">Patient Records</p>
            </a>
            <a href="#"
               class="bg-gradient-to-r from-purple-500 to-purple-600 text-white p-4 rounded-xl text-center hover:from-purple-600 hover:to-purple-700 transition duration-200 card-hover">
                <i class="fas fa-chart-bar text-2xl mb-2"></i>
                <p class="font-semibold">Statistics</p>
            </a>
        </div>
    </div>

    <!-- Empty State for No Activity -->
    <c:if test="${empty pendingValidations && empty todayConsultations && empty upcomingConsultations}">
        <div class="bg-white rounded-2xl shadow-lg p-12 text-center mt-8">
            <div class="w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-6">
                <i class="fas fa-calendar-check text-gray-400 text-3xl"></i>
            </div>
            <h3 class="text-2xl font-bold text-gray-600 mb-2">All Caught Up!</h3>
            <p class="text-gray-500 mb-6">You have no pending appointments or validations at the moment.</p>
            <a href="${pageContext.request.contextPath}/doctor/schedule"
               class="inline-block bg-blue-500 hover:bg-blue-600 text-white px-6 py-3 rounded-lg transition duration-200">
                View Your Schedule
            </a>
        </div>
    </c:if>

</div>

<script>
// Add some interactive features
document.addEventListener('DOMContentLoaded', function() {
    // Add real-time clock
    function updateTime() {
        const now = new Date();
        const timeString = now.toLocaleTimeString();
        // You can add a time display element if needed
    }

    setInterval(updateTime, 1000);

    // Add smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth'
                });
            }
        });
    });

    // Add loading states for forms
    document.querySelectorAll('form').forEach(form => {
        form.addEventListener('submit', function() {
            const button = form.querySelector('button[type="submit"]');
            if (button) {
                button.disabled = true;
                button.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Processing...';
            }
        });
    });
});
</script>

</body>
</html>