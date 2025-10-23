<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Schedule - Clinic</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .appointment-card {
            transition: all 0.3s ease;
            cursor: pointer;
        }
        .appointment-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }
        .modal {
            backdrop-filter: blur(10px);
        }
        .calendar-cell {
            min-height: 120px;
        }
        .time-slot {
            height: 60px;
            border-right: 1px solid #e5e7eb;
        }
        .appointment-reserved {
            background: linear-gradient(135deg, #fef3c7, #fde047);
            border-left: 4px solid #f59e0b;
        }
        .appointment-validated {
            background: linear-gradient(135deg, #d1fae5, #34d399);
            border-left: 4px solid #10b981;
        }
        .appointment-completed {
            background: linear-gradient(135deg, #dbeafe, #60a5fa);
            border-left: 4px solid #3b82f6;
        }
        .appointment-cancelled {
            background: linear-gradient(135deg, #fee2e2, #f87171);
            border-left: 4px solid #ef4444;
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
                   class="bg-blue-100 text-blue-700 px-4 py-2 rounded-lg font-medium flex items-center space-x-2">
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

    <!-- Header Section -->
    <div class="bg-white rounded-2xl shadow-lg p-6 mb-8">
        <div class="flex items-center justify-between">
            <div class="flex items-center space-x-4">
                <div class="w-16 h-16 bg-gradient-to-r from-blue-500 to-purple-600 rounded-xl flex items-center justify-center">
                    <i class="fas fa-calendar-week text-white text-2xl"></i>
                </div>
                <div>
                    <h1 class="text-3xl font-bold text-gray-900">Weekly Schedule</h1>
                    <p class="mt-1 text-lg text-gray-600">
                        ${formattedStartDate} - ${formattedEndDate}
                    </p>
                </div>
            </div>
            <div class="flex items-center space-x-3">
                <a href="${pageContext.request.contextPath}/doctor/schedule?date=${selectedDate.minusDays(7)}"
                   class="px-6 py-3 bg-white border-2 border-gray-300 text-gray-700 font-semibold rounded-xl hover:bg-gray-50 transition duration-200 flex items-center space-x-2 shadow-sm">
                    <i class="fas fa-chevron-left"></i>
                    <span>Previous</span>
                </a>
                <a href="${pageContext.request.contextPath}/doctor/schedule"
                   class="px-6 py-3 bg-gradient-to-r from-blue-500 to-blue-600 text-white font-semibold rounded-xl hover:from-blue-600 hover:to-blue-700 transition duration-200 shadow-lg">
                    Today
                </a>
                <a href="${pageContext.request.contextPath}/doctor/schedule?date=${selectedDate.plusDays(7)}"
                   class="px-6 py-3 bg-white border-2 border-gray-300 text-gray-700 font-semibold rounded-xl hover:bg-gray-50 transition duration-200 flex items-center space-x-2 shadow-sm">
                    <span>Next</span>
                    <i class="fas fa-chevron-right"></i>
                </a>
            </div>
        </div>
    </div>

    <!-- Error Display -->
    <c:if test="${not empty error}">
        <div class="mb-6 bg-red-50 border-l-4 border-red-400 p-4 rounded-lg shadow-sm">
            <div class="flex">
                <i class="fas fa-exclamation-circle text-red-400 text-xl"></i>
                <p class="ml-3 text-sm text-red-700">${error}</p>
            </div>
        </div>
    </c:if>

    <!-- Calendar Grid -->
    <div class="bg-white rounded-2xl shadow-lg overflow-hidden mb-8">
        <!-- Calendar Header -->
        <div class="bg-gradient-to-r from-blue-500 to-blue-600 px-6 py-4">
            <div class="grid grid-cols-7 gap-4">
                <c:forEach begin="0" end="6" var="i">
                    <div class="text-center text-white">
                        <div class="text-sm font-medium opacity-80">${weekDayNames[i]}</div>
                        <div class="text-2xl font-bold mt-1">${weekDayNumbers[i]}</div>
                        <div class="text-xs opacity-70 mt-1">${weekMonthNames[i]}</div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Calendar Body -->
        <div class="p-6">
            <div class="grid grid-cols-7 gap-4">
                <c:forEach begin="0" end="6" var="dayOffset">
                    <c:set var="currentDay" value="${startOfWeek.plusDays(dayOffset)}"/>
                    <div class="calendar-cell bg-gray-50 rounded-xl p-4 border-2 border-gray-200">
                        <div class="space-y-2">
                            <c:set var="hasConsultations" value="false"/>
                            <c:forEach items="${weekConsultations}" var="consultation">
                                <c:if test="${consultation.date.equals(currentDay)}">
                                    <c:set var="hasConsultations" value="true"/>
                                    <div class="appointment-card p-3 rounded-lg shadow-sm ${consultation.statut == 'VALIDEE' ? 'appointment-validated' : consultation.statut == 'TERMINEE' ? 'appointment-completed' : consultation.statut == 'RESERVEE' ? 'appointment-reserved' : 'appointment-cancelled'}"
                                         onclick="showAppointmentModal('${consultation.idConsultation}', '${consultation.patient.prenom} ${consultation.patient.nom}', '${consultation.patient.email}', '${formattedTimes[consultation.idConsultation]}', '${consultation.salle.nomSalle}', '${consultation.statut}', '${consultation.patient.poids}', '${consultation.patient.taille}', '${consultation.compteRendu}')">

                                        <div class="flex items-center space-x-2 mb-2">
                                            <div class="w-6 h-6 rounded-full ${consultation.statut == 'VALIDEE' ? 'bg-green-500' : consultation.statut == 'TERMINEE' ? 'bg-blue-500' : consultation.statut == 'RESERVEE' ? 'bg-yellow-500' : 'bg-red-500'} flex items-center justify-center">
                                                <i class="fas ${consultation.statut == 'VALIDEE' ? 'fa-check' : consultation.statut == 'TERMINEE' ? 'fa-clipboard-check' : consultation.statut == 'RESERVEE' ? 'fa-clock' : 'fa-times'} text-white text-xs"></i>
                                            </div>
                                            <span class="text-xs font-bold ${consultation.statut == 'VALIDEE' ? 'text-green-800' : consultation.statut == 'TERMINEE' ? 'text-blue-800' : consultation.statut == 'RESERVEE' ? 'text-yellow-800' : 'text-red-800'}">
                                                ${formattedTimes[consultation.idConsultation]}
                                            </span>
                                        </div>

                                        <p class="text-sm font-semibold text-gray-800 mb-1 truncate">
                                            ${consultation.patient.prenom} ${consultation.patient.nom}
                                        </p>

                                        <div class="flex items-center space-x-1 text-xs text-gray-600 mb-2">
                                            <i class="fas fa-door-open"></i>
                                            <span>${consultation.salle.nomSalle}</span>
                                        </div>

                                        <div class="flex items-center justify-between">
                                            <span class="inline-block px-2 py-1 text-xs font-semibold rounded ${consultation.statut == 'VALIDEE' ? 'bg-green-200 text-green-800' : consultation.statut == 'TERMINEE' ? 'bg-blue-200 text-blue-800' : consultation.statut == 'RESERVEE' ? 'bg-yellow-200 text-yellow-800' : 'bg-red-200 text-red-800'}">
                                                ${consultation.statut}
                                            </span>
                                            <c:if test="${consultation.statut == 'VALIDEE'}">
                                                <i class="fas fa-stethoscope text-green-600 text-sm"></i>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>

                            <c:if test="${!hasConsultations}">
                                <div class="flex items-center justify-center h-full text-gray-400 py-8">
                                    <div class="text-center">
                                        <i class="fas fa-calendar-times text-3xl mb-2"></i>
                                        <p class="text-xs">No appointments</p>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <!-- Legend -->
    <div class="bg-white rounded-2xl shadow-lg p-6">
        <h3 class="text-lg font-bold text-gray-800 mb-4">Status Legend</h3>
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div class="appointment-reserved p-4 rounded-lg">
                <div class="flex items-center space-x-3">
                    <div class="w-8 h-8 bg-yellow-500 rounded-full flex items-center justify-center">
                        <i class="fas fa-clock text-white text-sm"></i>
                    </div>
                    <div>
                        <p class="text-sm font-semibold text-yellow-800">Reserved</p>
                        <p class="text-xs text-yellow-700">Pending validation</p>
                    </div>
                </div>
            </div>
            <div class="appointment-validated p-4 rounded-lg">
                <div class="flex items-center space-x-3">
                    <div class="w-8 h-8 bg-green-500 rounded-full flex items-center justify-center">
                        <i class="fas fa-check text-white text-sm"></i>
                    </div>
                    <div>
                        <p class="text-sm font-semibold text-green-800">Validated</p>
                        <p class="text-xs text-green-700">Confirmed appointment</p>
                    </div>
                </div>
            </div>
            <div class="appointment-completed p-4 rounded-lg">
                <div class="flex items-center space-x-3">
                    <div class="w-8 h-8 bg-blue-500 rounded-full flex items-center justify-center">
                        <i class="fas fa-clipboard-check text-white text-sm"></i>
                    </div>
                    <div>
                        <p class="text-sm font-semibold text-blue-800">Completed</p>
                        <p class="text-xs text-blue-700">Consultation finished</p>
                    </div>
                </div>
            </div>
            <div class="appointment-cancelled p-4 rounded-lg">
                <div class="flex items-center space-x-3">
                    <div class="w-8 h-8 bg-red-500 rounded-full flex items-center justify-center">
                        <i class="fas fa-times text-white text-sm"></i>
                    </div>
                    <div>
                        <p class="text-sm font-semibold text-red-800">Cancelled</p>
                        <p class="text-xs text-red-700">Appointment cancelled</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

</main>

<!-- Appointment Details Modal -->
<div id="appointmentModal" class="fixed inset-0 z-50 overflow-y-auto hidden modal">
    <div class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" onclick="closeModal()"></div>

        <div class="inline-block align-bottom bg-white rounded-2xl text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-2xl sm:w-full">
            <div class="bg-gradient-to-r from-blue-500 to-purple-600 px-6 py-4">
                <div class="flex items-center justify-between">
                    <h3 class="text-2xl font-bold text-white">Appointment Details</h3>
                    <button onclick="closeModal()" class="text-white hover:text-gray-200 transition duration-200">
                        <i class="fas fa-times text-2xl"></i>
                    </button>
                </div>
            </div>

            <div class="bg-white px-6 py-6">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <!-- Patient Info -->
                    <div class="space-y-4">
                        <div class="flex items-center space-x-4">
                            <div id="patientAvatar" class="w-16 h-16 bg-gradient-to-r from-blue-500 to-purple-600 rounded-full flex items-center justify-center text-white text-2xl font-bold">
                            </div>
                            <div>
                                <h4 id="patientName" class="text-xl font-bold text-gray-800"></h4>
                                <p id="patientEmail" class="text-gray-600"></p>
                            </div>
                        </div>

                        <div class="space-y-3">
                            <div class="flex items-center space-x-3 bg-gray-50 p-3 rounded-lg">
                                <i class="fas fa-weight text-blue-500"></i>
                                <div>
                                    <p class="text-xs text-gray-500">Weight</p>
                                    <p id="patientWeight" class="font-semibold"></p>
                                </div>
                            </div>
                            <div class="flex items-center space-x-3 bg-gray-50 p-3 rounded-lg">
                                <i class="fas fa-ruler-vertical text-blue-500"></i>
                                <div>
                                    <p class="text-xs text-gray-500">Height</p>
                                    <p id="patientHeight" class="font-semibold"></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Appointment Info -->
                    <div class="space-y-4">
                        <div class="space-y-3">
                            <div class="flex items-center space-x-3 bg-gray-50 p-3 rounded-lg">
                                <i class="fas fa-clock text-purple-500"></i>
                                <div>
                                    <p class="text-xs text-gray-500">Time</p>
                                    <p id="appointmentTime" class="font-semibold"></p>
                                </div>
                            </div>
                            <div class="flex items-center space-x-3 bg-gray-50 p-3 rounded-lg">
                                <i class="fas fa-door-open text-purple-500"></i>
                                <div>
                                    <p class="text-xs text-gray-500">Room</p>
                                    <p id="appointmentRoom" class="font-semibold"></p>
                                </div>
                            </div>
                            <div class="flex items-center space-x-3 bg-gray-50 p-3 rounded-lg">
                                <i class="fas fa-info-circle text-purple-500"></i>
                                <div>
                                    <p class="text-xs text-gray-500">Status</p>
                                    <p id="appointmentStatus" class="font-semibold"></p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Medical Report -->
                <div id="medicalReportSection" class="mt-6 hidden">
                    <h5 class="text-lg font-bold text-gray-800 mb-3 flex items-center">
                        <i class="fas fa-file-medical text-blue-500 mr-2"></i>
                        Medical Report
                    </h5>
                    <div class="bg-gray-50 rounded-lg p-4">
                        <p id="medicalReport" class="text-gray-700 whitespace-pre-wrap"></p>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="mt-6 flex justify-between">
                    <div id="actionButtons" class="flex space-x-3">
                        <!-- Dynamic buttons based on status -->
                    </div>
                    <button onclick="closeModal()" class="px-6 py-2 bg-gray-300 text-gray-700 rounded-lg hover:bg-gray-400 transition duration-200">
                        Close
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
let currentConsultationId = null;

function showAppointmentModal(consultationId, patientName, patientEmail, time, room, status, weight, height, medicalReport) {
    currentConsultationId = consultationId;

    // Set patient info
    document.getElementById('patientName').textContent = patientName;
    document.getElementById('patientEmail').textContent = patientEmail;
    document.getElementById('patientAvatar').textContent = patientName.split(' ').map(n => n[0]).join('');

    // Set patient metrics
    document.getElementById('patientWeight').textContent = weight && weight !== 'null' ? weight + ' kg' : 'Not specified';
    document.getElementById('patientHeight').textContent = height && height !== 'null' ? height + ' cm' : 'Not specified';

    // Set appointment info
    document.getElementById('appointmentTime').textContent = time;
    document.getElementById('appointmentRoom').textContent = room;
    document.getElementById('appointmentStatus').textContent = status;

    // Handle medical report
    const medicalReportSection = document.getElementById('medicalReportSection');
    if (medicalReport && medicalReport !== 'null' && medicalReport.trim() !== '') {
        document.getElementById('medicalReport').textContent = medicalReport;
        medicalReportSection.classList.remove('hidden');
    } else {
        medicalReportSection.classList.add('hidden');
    }

    // Set action buttons based on status
    const actionButtons = document.getElementById('actionButtons');
    actionButtons.innerHTML = '';

    if (status === 'VALIDEE') {
        actionButtons.innerHTML = `
            <a href="${pageContext.request.contextPath}/doctor/complete-consultation?consultationId=${consultationId}"
               class="px-6 py-2 bg-green-500 hover:bg-green-600 text-white rounded-lg transition duration-200 flex items-center space-x-2">
                <i class="fas fa-stethoscope"></i>
                <span>Complete Consultation</span>
            </a>
        `;
    } else if (status === 'RESERVEE') {
        actionButtons.innerHTML = `
            <form action="${pageContext.request.contextPath}/doctor/validate-consultation" method="post" class="inline">
                <input type="hidden" name="consultationId" value="${consultationId}"/>
                <input type="hidden" name="action" value="validate"/>
                <button type="submit" class="px-6 py-2 bg-green-500 hover:bg-green-600 text-white rounded-lg transition duration-200 flex items-center space-x-2">
                    <i class="fas fa-check"></i>
                    <span>Accept</span>
                </button>
            </form>
            <form action="${pageContext.request.contextPath}/doctor/validate-consultation" method="post" class="inline">
                <input type="hidden" name="consultationId" value="${consultationId}"/>
                <input type="hidden" name="action" value="refuse"/>
                <button type="submit" class="px-6 py-2 bg-red-500 hover:bg-red-600 text-white rounded-lg transition duration-200 flex items-center space-x-2">
                    <i class="fas fa-times"></i>
                    <span>Decline</span>
                </button>
            </form>
        `;
    }

    // Show modal
    document.getElementById('appointmentModal').classList.remove('hidden');
}

function closeModal() {
    document.getElementById('appointmentModal').classList.add('hidden');
    currentConsultationId = null;
}

// Close modal on Escape key
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeModal();
    }
});

// Initialize page
document.addEventListener('DOMContentLoaded', function() {
    // Add current time indicator
    function updateCurrentTime() {
        const now = new Date();
        const timeString = now.toLocaleTimeString();
        // You can add real-time features here
    }

    setInterval(updateCurrentTime, 1000);

    // Add loading states for form submissions
    document.querySelectorAll('form').forEach(form => {
        form.addEventListener('submit', function() {
            const button = form.querySelector('button[type="submit"]');
            if (button) {
                button.disabled = true;
                const originalText = button.innerHTML;
                button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';

                // Re-enable after 3 seconds to prevent permanent disable
                setTimeout(() => {
                    button.disabled = false;
                    button.innerHTML = originalText;
                }, 3000);
            }
        });
    });
});
</script>

</body>
</html>