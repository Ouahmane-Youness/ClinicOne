<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complete Consultation - Clinico</title>
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
                    <a href="${pageContext.request.contextPath}/doctor/schedule" class="border-b-2 border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 text-sm font-medium">
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

<main class="max-w-4xl mx-auto py-8 px-4 sm:px-6 lg:px-8">

    <div class="mb-8">
        <a href="${pageContext.request.contextPath}/doctor/dashboard" class="text-teal-600 hover:text-teal-700 font-medium text-sm">
            <i class="fas fa-arrow-left mr-2"></i>
            Back to Dashboard
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
        <div class="bg-gradient-to-r from-teal-500 to-teal-600 px-6 py-8">
            <div class="flex items-center space-x-6">
                <div class="w-20 h-20 rounded-full bg-white flex items-center justify-center text-teal-600 text-3xl font-bold shadow-lg">
                    ${consultation.patient.prenom.substring(0,1)}${consultation.patient.nom.substring(0,1)}
                </div>
                <div class="text-white">
                    <h2 class="text-2xl font-bold">${consultation.patient.prenom} ${consultation.patient.nom}</h2>
                    <p class="text-teal-100 mt-1">${consultation.patient.email}</p>
                </div>
            </div>
        </div>

        <div class="p-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                <div class="bg-gray-50 rounded-xl p-4">
                    <div class="flex items-center space-x-3">
                        <div class="w-12 h-12 rounded-full bg-teal-100 flex items-center justify-center">
                            <i class="fas fa-calendar text-teal-600 text-xl"></i>
                        </div>
                        <div>
                            <p class="text-xs text-gray-500">Consultation Date</p>
                            <p class="text-lg font-bold text-gray-800">
                                <fmt:formatDate value="${consultation.date}" pattern="EEEE, MMMM dd, yyyy"/>
                            </p>
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
                            <p class="text-lg font-bold text-gray-800">
                                <fmt:formatDate value="${consultation.heure}" pattern="HH:mm"/>
                            </p>
                        </div>
                    </div>
                </div>

                <div class="bg-gray-50 rounded-xl p-4">
                    <div class="flex items-center space-x-3">
                        <div class="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center">
                            <i class="fas fa-door-open text-blue-600 text-xl"></i>
                        </div>
                        <div>
                            <p class="text-xs text-gray-500">Room</p>
                            <p class="text-lg font-bold text-gray-800">${consultation.salle.nomSalle}</p>
                        </div>
                    </div>
                </div>

                <div class="bg-gray-50 rounded-xl p-4">
                    <div class="flex items-center space-x-3">
                        <div class="w-12 h-12 rounded-full bg-green-100 flex items-center justify-center">
                            <i class="fas fa-check-circle text-green-600 text-xl"></i>
                        </div>
                        <div>
                            <p class="text-xs text-gray-500">Status</p>
                            <p class="text-lg font-bold text-green-800">Confirmed</p>
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
                                    Not provided
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
                                    Not provided
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <div>
                        <p class="text-xs text-gray-500">BMI</p>
                        <p class="text-sm font-semibold text-gray-800">
                            <c:choose>
                                <c:when test="${not empty consultation.patient.poids && not empty consultation.patient.taille}">
                                    <fmt:formatNumber value="${consultation.patient.poids / ((consultation.patient.taille / 100) * (consultation.patient.taille / 100))}" maxFractionDigits="1"/>
                                </c:when>
                                <c:otherwise>
                                    N/A
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/doctor/patient-history?patientId=${consultation.patient.id}"
                           class="inline-flex items-center px-3 py-2 bg-purple-500 hover:bg-purple-600 text-white text-xs font-semibold rounded-lg transition">
                            <i class="fas fa-history mr-1"></i>
                            View History
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="bg-white rounded-2xl shadow-lg overflow-hidden">
        <div class="px-6 py-5 border-b border-gray-200 bg-gradient-to-r from-gray-50 to-white">
            <h2 class="text-xl font-bold text-gray-800 flex items-center">
                <i class="fas fa-file-medical-alt text-teal-600 mr-3"></i>
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
                        class="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:border-teal-500 focus:outline-none transition resize-none"
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
                        class="px-8 py-3 bg-gradient-to-r from-teal-500 to-teal-600 text-white font-bold rounded-xl hover:from-teal-600 hover:to-teal-700 transition transform hover:scale-105 shadow-lg">
                    <i class="fas fa-check-double mr-2"></i>
                    Complete Consultation
                </button>
            </div>
        </form>
    </div>

</main>

</body>
</html>