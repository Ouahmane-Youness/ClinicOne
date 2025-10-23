<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Medical File - Clinic</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .timeline-item {
            position: relative;
            padding-left: 2rem;
        }
        .timeline-item::before {
            content: '';
            position: absolute;
            left: 0.5rem;
            top: 0;
            bottom: 0;
            width: 2px;
            background: linear-gradient(to bottom, #3b82f6, #1d4ed8);
        }
        .timeline-item:last-child::before {
            background: linear-gradient(to bottom, #3b82f6, transparent);
        }
        .timeline-dot {
            position: absolute;
            left: 0;
            top: 1.5rem;
            width: 1rem;
            height: 1rem;
            border-radius: 50%;
            transform: translateX(-50%);
        }
        .card-hover {
            transition: all 0.3s ease;
        }
        .card-hover:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }
        .health-metric {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .visit-card {
            transition: all 0.3s ease;
            cursor: pointer;
        }
        .visit-card:hover {
            transform: translateY(-1px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
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
                   class="text-gray-700 hover:text-blue-600 px-4 py-2 rounded-lg font-medium flex items-center space-x-2 hover:bg-gray-100 transition">
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

<main class="max-w-7xl mx-auto py-8 px-4 sm:px-6 lg:px-8">

    <!-- Header with Patient Info -->
    <div class="mb-8">
        <a href="${pageContext.request.contextPath}/doctor/dashboard"
           class="text-blue-600 hover:text-blue-700 font-medium text-sm flex items-center space-x-2 mb-4">
            <i class="fas fa-arrow-left"></i>
            <span>Back to Dashboard</span>
        </a>

        <div class="bg-white rounded-2xl shadow-lg overflow-hidden">
            <div class="bg-gradient-to-r from-blue-500 to-purple-600 px-8 py-8">
                <div class="flex items-center space-x-6">
                    <div class="w-24 h-24 rounded-full bg-white flex items-center justify-center text-blue-600 text-3xl font-bold shadow-lg">
                        ${patient.prenom.substring(0,1)}${patient.nom.substring(0,1)}
                    </div>
                    <div class="text-white">
                        <h1 class="text-3xl font-bold">${patient.prenom} ${patient.nom}</h1>
                        <p class="text-blue-100 mt-1 text-lg">${patient.email}</p>
                        <div class="mt-3 flex items-center space-x-4">
                            <span class="bg-white bg-opacity-20 px-3 py-1 rounded-full text-sm">
                                <i class="fas fa-user-medical mr-2"></i>Patient ID: ${patient.id}
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Patient Health Metrics -->
            <div class="p-8">
                <h2 class="text-xl font-bold text-gray-800 mb-6">Health Metrics</h2>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <!-- Weight -->
                    <div class="health-metric text-white rounded-xl p-6 card-hover">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-purple-100 text-sm font-medium uppercase tracking-wide">Weight</p>
                                <p class="text-2xl font-bold mt-2">
                                    <c:choose>
                                        <c:when test="${not empty patient.poids}">
                                            ${patient.poids} kg
                                        </c:when>
                                        <c:otherwise>
                                            Not recorded
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            <div class="bg-white bg-opacity-20 rounded-full p-3">
                                <i class="fas fa-weight text-xl"></i>
                            </div>
                        </div>
                    </div>

                    <!-- Height -->
                    <div class="health-metric text-white rounded-xl p-6 card-hover">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-purple-100 text-sm font-medium uppercase tracking-wide">Height</p>
                                <p class="text-2xl font-bold mt-2">
                                    <c:choose>
                                        <c:when test="${not empty patient.taille}">
                                            ${patient.taille} cm
                                        </c:when>
                                        <c:otherwise>
                                            Not recorded
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            <div class="bg-white bg-opacity-20 rounded-full p-3">
                                <i class="fas fa-ruler-vertical text-xl"></i>
                            </div>
                        </div>
                    </div>

                    <!-- BMI -->
                    <div class="health-metric text-white rounded-xl p-6 card-hover">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-purple-100 text-sm font-medium uppercase tracking-wide">BMI</p>
                                <p class="text-2xl font-bold mt-2">
                                    <c:choose>
                                        <c:when test="${not empty patient.poids && not empty patient.taille}">
                                            <c:set var="bmi" value="${patient.poids / ((patient.taille / 100) * (patient.taille / 100))}"/>
                                            <c:choose>
                                                <c:when test="${bmi < 10 || bmi > 50}">
                                                    Invalid
                                                </c:when>
                                                <c:otherwise>
                                                    ${String.format("%.1f", bmi)}
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            N/A
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            <div class="bg-white bg-opacity-20 rounded-full p-3">
                                <i class="fas fa-calculator text-xl"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Visit Statistics -->
                <div class="mt-8 grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div class="bg-green-50 border-2 border-green-200 rounded-xl p-6">
                        <div class="flex items-center space-x-3">
                            <div class="w-12 h-12 bg-green-100 rounded-full flex items-center justify-center">
                                <i class="fas fa-calendar-check text-green-600 text-xl"></i>
                            </div>
                            <div>
                                <p class="text-gray-600 text-sm">Total Visits</p>
                                <p class="text-2xl font-bold text-gray-800">${patientHistory.size()}</p>
                            </div>
                        </div>
                    </div>

                    <div class="bg-blue-50 border-2 border-blue-200 rounded-xl p-6">
                        <div class="flex items-center space-x-3">
                            <div class="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center">
                                <i class="fas fa-clipboard-check text-blue-600 text-xl"></i>
                            </div>
                            <div>
                                <p class="text-gray-600 text-sm">Completed</p>
                                <p class="text-2xl font-bold text-gray-800">
                                    <c:set var="completedCount" value="0"/>
                                    <c:forEach var="consultation" items="${patientHistory}">
                                        <c:if test="${consultation.statut == 'TERMINEE'}">
                                            <c:set var="completedCount" value="${completedCount + 1}"/>
                                        </c:if>
                                    </c:forEach>
                                    ${completedCount}
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="bg-purple-50 border-2 border-purple-200 rounded-xl p-6">
                        <div class="flex items-center space-x-3">
                            <div class="w-12 h-12 bg-purple-100 rounded-full flex items-center justify-center">
                                <i class="fas fa-calendar text-purple-600 text-xl"></i>
                            </div>
                            <div>
                                <p class="text-gray-600 text-sm">Last Visit</p>
                                <p class="text-lg font-bold text-gray-800">
                                    <c:choose>
                                        <c:when test="${not empty patientHistory}">
                                            <c:forEach var="consultation" items="${patientHistory}" begin="0" end="0">
                                                ${consultation.date}
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            Never
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Medical History Timeline -->
    <div class="bg-white rounded-2xl shadow-lg p-8">
        <div class="flex items-center justify-between mb-8">
            <div class="flex items-center space-x-3">
                <div class="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
                    <i class="fas fa-history text-blue-600 text-xl"></i>
                </div>
                <div>
                    <h2 class="text-2xl font-bold text-gray-800">Medical History Timeline</h2>
                    <p class="text-gray-600">Chronological record of all consultations</p>
                </div>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty patientHistory}">
                <div class="timeline">
                    <c:forEach var="consultation" items="${patientHistory}" varStatus="status">
                        <div class="timeline-item mb-8">
                            <div class="timeline-dot ${consultation.statut == 'TERMINEE' ? 'bg-green-500' : consultation.statut == 'VALIDEE' ? 'bg-blue-500' : consultation.statut == 'RESERVEE' ? 'bg-yellow-500' : 'bg-red-500'}"></div>

                            <div class="visit-card bg-gray-50 rounded-xl p-6 border-2 ${consultation.statut == 'TERMINEE' ? 'border-green-200 hover:border-green-300' : consultation.statut == 'VALIDEE' ? 'border-blue-200 hover:border-blue-300' : consultation.statut == 'RESERVEE' ? 'border-yellow-200 hover:border-yellow-300' : 'border-red-200 hover:border-red-300'}"
                                 onclick="toggleDetails('consultation-${consultation.idConsultation}')">

                                <div class="flex items-center justify-between mb-4">
                                    <div class="flex items-center space-x-4">
                                        <div class="w-16 h-16 ${consultation.statut == 'TERMINEE' ? 'bg-green-100' : consultation.statut == 'VALIDEE' ? 'bg-blue-100' : consultation.statut == 'RESERVEE' ? 'bg-yellow-100' : 'bg-red-100'} rounded-xl flex items-center justify-center">
                                            <i class="fas ${consultation.statut == 'TERMINEE' ? 'fa-check-circle text-green-600' : consultation.statut == 'VALIDEE' ? 'fa-calendar-check text-blue-600' : consultation.statut == 'RESERVEE' ? 'fa-clock text-yellow-600' : 'fa-times-circle text-red-600'} text-2xl"></i>
                                        </div>
                                        <div>
                                            <h3 class="text-xl font-bold text-gray-800">
                                                Consultation with Dr. ${consultation.docteur.nom} ${consultation.docteur.prenom}
                                            </h3>
                                            <p class="text-gray-600">${consultation.docteur.specialite}</p>
                                            <div class="flex items-center space-x-4 mt-2">
                                                <div class="flex items-center text-sm text-gray-600">
                                                    <i class="fas fa-calendar mr-2"></i>
                                                    ${consultation.date}
                                                </div>
                                                <div class="flex items-center text-sm text-gray-600">
                                                    <i class="fas fa-clock mr-2"></i>
                                                    ${consultation.heure}
                                                </div>
                                                <div class="flex items-center text-sm text-gray-600">
                                                    <i class="fas fa-door-open mr-2"></i>
                                                    Room ${consultation.salle.nomSalle}
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="flex items-center space-x-3">
                                        <span class="inline-block px-4 py-2 text-sm font-semibold rounded-full ${consultation.statut == 'TERMINEE' ? 'bg-green-200 text-green-800' : consultation.statut == 'VALIDEE' ? 'bg-blue-200 text-blue-800' : consultation.statut == 'RESERVEE' ? 'bg-yellow-200 text-yellow-800' : 'bg-red-200 text-red-800'}">
                                            ${consultation.statut}
                                        </span>
                                        <i class="fas fa-chevron-down text-gray-400 transform transition-transform duration-200" id="chevron-consultation-${consultation.idConsultation}"></i>
                                    </div>
                                </div>

                                <!-- Expandable Details -->
                                <div id="consultation-${consultation.idConsultation}" class="hidden mt-6 border-t border-gray-200 pt-6">
                                    <c:if test="${not empty consultation.compteRendu}">
                                        <div class="bg-white rounded-lg p-6 border border-gray-200">
                                            <h4 class="text-lg font-bold text-gray-800 mb-4 flex items-center">
                                                <i class="fas fa-file-medical text-blue-500 mr-3"></i>
                                                Medical Report
                                            </h4>
                                            <div class="prose prose-sm max-w-none">
                                                <p class="text-gray-700 whitespace-pre-wrap leading-relaxed">${consultation.compteRendu}</p>
                                            </div>
                                        </div>
                                    </c:if>

                                    <c:if test="${empty consultation.compteRendu}">
                                        <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
                                            <div class="flex items-center">
                                                <i class="fas fa-info-circle text-yellow-600 mr-3"></i>
                                                <p class="text-yellow-800">
                                                    <c:choose>
                                                        <c:when test="${consultation.statut == 'RESERVEE'}">
                                                            This consultation is pending validation.
                                                        </c:when>
                                                        <c:when test="${consultation.statut == 'VALIDEE'}">
                                                            This consultation is confirmed but not yet completed.
                                                        </c:when>
                                                        <c:when test="${consultation.statut == 'ANNULEE'}">
                                                            This consultation was cancelled.
                                                        </c:when>
                                                        <c:otherwise>
                                                            No medical report available for this consultation.
                                                        </c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-12">
                    <div class="w-24 h-24 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-6">
                        <i class="fas fa-user-md text-gray-400 text-3xl"></i>
                    </div>
                    <h3 class="text-xl font-bold text-gray-600 mb-2">No Medical History</h3>
                    <p class="text-gray-500">This patient has no consultation history with you yet.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Quick Actions -->
    <div class="mt-8 bg-white rounded-2xl shadow-lg p-6">
        <h3 class="text-lg font-bold text-gray-800 mb-4">Quick Actions</h3>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <a href="${pageContext.request.contextPath}/doctor/dashboard"
               class="bg-gradient-to-r from-blue-500 to-blue-600 text-white p-4 rounded-xl text-center hover:from-blue-600 hover:to-blue-700 transition duration-200 card-hover">
                <i class="fas fa-home text-xl mb-2"></i>
                <p class="font-semibold">Back to Dashboard</p>
            </a>
            <a href="${pageContext.request.contextPath}/doctor/schedule"
               class="bg-gradient-to-r from-purple-500 to-purple-600 text-white p-4 rounded-xl text-center hover:from-purple-600 hover:to-purple-700 transition duration-200 card-hover">
                <i class="fas fa-calendar-alt text-xl mb-2"></i>
                <p class="font-semibold">View Schedule</p>
            </a>
        </div>
    </div>

</main>

<script>
function toggleDetails(consultationId) {
    const details = document.getElementById(consultationId);
    const chevron = document.getElementById('chevron-' + consultationId);

    if (details.classList.contains('hidden')) {
        details.classList.remove('hidden');
        chevron.style.transform = 'rotate(180deg)';
    } else {
        details.classList.add('hidden');
        chevron.style.transform = 'rotate(0deg)';
    }
}

// Initialize page
document.addEventListener('DOMContentLoaded', function() {
    // Add smooth transitions for all expandable content
    document.querySelectorAll('[id^="consultation-"]').forEach(element => {
        element.style.transition = 'all 0.3s ease';
    });

    // Add keyboard navigation
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            // Close all expanded consultations
            document.querySelectorAll('[id^="consultation-"]:not(.hidden)').forEach(element => {
                element.classList.add('hidden');
                const consultationId = element.id;
                const chevron = document.getElementById('chevron-' + consultationId);
                if (chevron) {
                    chevron.style.transform = 'rotate(0deg)';
                }
            });
        }
    });
});
</script>

</body>
</html>