<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Consultation - Clinic</title>
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

<main class="max-w-4xl mx-auto py-8 px-4 sm:px-6 lg:px-8">

    <div class="mb-8">
        <a href="${pageContext.request.contextPath}/doctor/dashboard"
           class="text-blue-600 hover:text-blue-700 font-medium text-sm">
            <i class="fas fa-arrow-left mr-2"></i>Back to Dashboard
        </a>
        <h1 class="text-3xl font-bold text-gray-900 mt-4">Complete Consultation</h1>
        <p class="mt-2 text-sm text-gray-600">Add medical report and finalize the consultation</p>
    </div>

    <c:if test="${not empty error}">
        <div class="mb-6 bg-red-50 border-l-4 border-red-400 p-4 rounded-lg">
            <div class="flex">
                <i class="fas fa-exclamation-circle text-red-400 text-xl"></i>
                <p class="ml-3 text-sm text-red-700">${error}</p>
            </div>
        </div>
    </c:if>

    <div class="bg-white rounded-2xl shadow-lg overflow-hidden mb-6">
        <div class="bg-gradient-to-r from-blue-500 to-blue-600 px-6 py-8">
            <div class="flex items-center space-x-6">
                <div class="w-20 h-20 rounded-full bg-white flex items-center justify-center text-blue-600 text-3xl font-bold shadow-lg">
                    ${consultation.patient.prenom.substring(0,1)}${consultation.patient.nom.substring(0,1)}
                </div>
                <div class="text-white">
                    <h2 class="text-2xl font-bold">${consultation.patient.prenom} ${consultation.patient.nom}</h2>
                    <p class="text-blue-100 mt-1">${consultation.patient.email}</p>
                </div>
            </div>
        </div>

        <div class="p-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                <div class="bg-gray-50 rounded-xl p-4">
                    <div class="flex items-center space-x-3">
                        <div class="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center">
                            <i class="fas fa-calendar text-blue-600 text-xl"></i>
                        </div>
                        <div>
                            <p class="text-xs text-gray-500">Consultation Date</p>
                            <p class="text-lg font-bold text-gray-800">${formattedDate}</p>
                        </div>
                    </div>
                </div>

                <div class="bg-gray-50 rounded-xl p-4">
                    <div class="flex items-center space-x-3">
                        <div class="w-12 h-12 rounded-full bg-purple-100 flex items-center justify-center">
                            <i class="fas fa-clock text-purple-600 text-xl"></i>
                        </div>
                        <div>
                            <p class="text-xs text-gray-500">Time</p>
                            <p class="text-lg font-bold text-gray-800">${formattedTime}</p>
                        </div>
                    </div>
                </div>

                <div class="bg-gray-50 rounded-xl p-4">
                    <div class="flex items-center space-x-3">
                        <div class="w-12 h-12 rounded-full bg-green-100 flex items-center justify-center">
                            <i class="fas fa-door-open text-green-600 text-xl"></i>
                        </div>
                        <div>
                            <p class="text-xs text-gray-500">Room</p>
                            <p class="text-lg font-bold text-gray-800">${consultation.salle.nomSalle}</p>
                        </div>
                    </div>
                </div>

                <div class="bg-gray-50 rounded-xl p-4">
                    <div class="flex items-center space-x-3">
                        <div class="w-12 h-12 rounded-full bg-yellow-100 flex items-center justify-center">
                            <i class="fas fa-check-circle text-yellow-600 text-xl"></i>
                        </div>
                        <div>
                            <p class="text-xs text-gray-500">Status</p>
                            <p class="text-lg font-bold text-yellow-800">${consultation.statut}</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="border-t border-gray-200 pt-6">
                <h3 class="text-lg font-bold text-gray-800 mb-4">Patient Information</h3>
                <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                    <div>
                        <p class="text-xs text-gray-500">Weight</p>
                        <p class="text-sm font-semibold text-gray-800">
                            <c:choose>
                                <c:when test="${not empty consultation.patient.poids}">
                                    ${consultation.patient.poids} kg
                                </c:when>
                                <c:otherwise>
                                    N/A
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <div>
                        <p class="text-xs text-gray-500">Height</p>
                        <p class="text-sm font-semibold text-gray-800">
                            <c:choose>
                                <c:when test="${not empty consultation.patient.taille}">
                                    ${consultation.patient.taille} cm
                                </c:when>
                                <c:otherwise>
                                    N/A
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <div>
                        <p class="text-xs text-gray-500">Email</p>
                        <p class="text-sm font-semibold text-gray-800">${consultation.patient.email}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="bg-white rounded-2xl shadow-lg overflow-hidden">
        <div class="bg-gradient-to-r from-gray-50 to-white px-6 py-4 border-b border-gray-200">
            <h2 class="text-xl font-bold text-gray-800 flex items-center">
                <i class="fas fa-file-medical-alt text-blue-600 mr-3"></i>
                Medical Report
            </h2>
        </div>

        <form action="${pageContext.request.contextPath}/doctor/complete-consultation" method="post" class="p-6">
            <input type="hidden" name="consultationId" value="${consultation.idConsultation}">

            <div class="mb-6">
                <label class="block text-sm font-semibold text-gray-700 mb-3">
                    Diagnosis and Treatment Plan
                    <span class="text-red-500">*</span>
                </label>
                <textarea
                        name="compteRendu"
                        required
                        rows="12"
                        placeholder="Enter detailed medical report including:&#10;- Chief complaint&#10;- Physical examination findings&#10;- Diagnosis&#10;- Treatment plan&#10;- Medications prescribed&#10;- Follow-up recommendations"
                        class="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:border-blue-500 focus:outline-none transition resize-none"
                ></textarea>
                <p class="mt-2 text-xs text-gray-500">
                    <i class="fas fa-info-circle mr-1"></i>
                    This report will be accessible to the patient in their medical history
                </p>
            </div>

            <div class="flex justify-between items-center pt-6 border-t border-gray-200">
                <a href="${pageContext.request.contextPath}/doctor/dashboard"
                   class="px-6 py-3 border-2 border-gray-300 text-gray-700 font-semibold rounded-xl hover:bg-gray-50 transition">
                    <i class="fas fa-times mr-2"></i>
                    Cancel
                </a>
                <button type="submit"
                        class="px-8 py-3 bg-gradient-to-r from-blue-500 to-blue-600 text-white font-bold rounded-xl hover:from-blue-600 hover:to-blue-700 transition transform hover:scale-105 shadow-lg">
                    <i class="fas fa-check-double mr-2"></i>
                    Complete Consultation
                </button>
            </div>
        </form>
    </div>

</main>

</body>
</html>