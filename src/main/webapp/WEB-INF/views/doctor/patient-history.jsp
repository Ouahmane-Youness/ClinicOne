<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient History - Clinico</title>
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

<main class="max-w-7xl mx-auto py-8 px-4 sm:px-6 lg:px-8">

    <div class="mb-8">
        <a href="${pageContext.request.contextPath}/doctor/dashboard" class="text-teal-600 hover:text-teal-700 font-medium text-sm">
            <i class="fas fa-arrow-left mr-2"></i>
            Back to Dashboard
        </a>
        <h1 class="text-3xl font-bold text-gray-900 mt-4">Patient Medical History</h1>
    </div>

    <div class="bg-white rounded-2xl shadow-lg overflow-hidden mb-8">
        <div class="bg-gradient-to-r from-purple-500 to-purple-600 px-6 py-8">
            <div class="flex items-center justify-between">
                <div class="flex items-center space-x-6">
                    <div class="w-24 h-24 rounded-full bg-white flex items-center justify-center text-purple-600 text-4xl font-bold shadow-xl">
                        ${patient.prenom.substring(0,1)}${patient.nom.substring(0,1)}
                    </div>
                    <div class="text-white">
                        <h2 class="text-3xl font-bold">${patient.prenom} ${patient.nom}</h2>
                        <p class="text-purple-100 mt-1 text-lg">${patient.email}</p>
                    </div>
                </div>
                <div class="text-right text-white">
                    <p class="text-purple-100 text-sm">Total Consultations</p>
                    <p class="text-4xl font-bold">${patientHistory.size()}</p>
                </div>
            </div>
        </div>

        <div class="p-6">
            <h3 class="text-lg font-bold text-gray-800 mb-4">Patient Information</h3>
            <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                <div class="bg-gray-50 rounded-xl p-4">
                    <div class="text-xs text-gray-500 mb-1">Weight</div>
                    <div class="text-2xl font-bold text-gray-800">
                        <c:choose>
                            <c:when test="${not empty patient.poids}">
                                ${patient.poids} <span class="text-sm text-gray-500">kg</span>
                            </c:when>
                            <c:otherwise>
                                <span class="text-sm text-gray-400">Not recorded</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="bg-gray-50 rounded-xl p-4">
                    <div class="text-xs text-gray-500 mb-1">Height</div>
                    <div class="text-2xl font-bold text-gray-800">
                        <c:choose>
                            <c:when test="${not empty patient.taille}">
                                ${patient.taille} <span class="text-sm text-gray-500">cm</span>
                            </c:when>
                            <c:otherwise>
                                <span class="text-sm text-gray-400">Not recorded</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="bg-gray-50 rounded-xl p-4">
                    <div class="text-xs text-gray-500 mb-1">BMI</div>
                    <div class="text-2xl font-bold text-gray-800">
                        <c:choose>
                            <c:when test="${not empty patient.poids && not empty patient.taille}">
                                <fmt:formatNumber value="${patient.poids / ((patient.taille / 100) * (patient.taille / 100))}" maxFractionDigits="1"/>
                            </c:when>
                            <c:otherwise>
                                <span class="text-sm text-gray-400">N/A</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="bg-gray-50 rounded-xl p-4">
                    <div class="text-xs text-gray-500 mb-1">Patient ID</div>
                    <div class="text-2xl font-bold text-gray-800">#${patient.id}</div>
                </div>
            </div>
        </div>
    </div>

    <c:choose>
        <c:when test="${empty patientHistory}">
            <div class="bg-white rounded-2xl shadow-lg p-12 text-center">
                <div class="inline-flex items-center justify-center w-24 h-24 rounded-full bg-gray-100 mb-6">
                    <i class="fas fa-folder-open text-5xl text-gray-400"></i>
                </div>
                <h2 class="text-2xl font-bold text-gray-800 mb-2">No Medical History</h2>
                <p class="text-gray-600">This patient has no consultation records yet</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="space-y-6">
                <c:forEach items="${patientHistory}" var="consultation" varStatus="status">
                    <div class="bg-white rounded-2xl shadow-lg overflow-hidden hover:shadow-xl transition">
                        <div class="flex items-center justify-between px-6 py-4 ${consultation.statut == 'TERMINEE' ? 'bg-gradient-to-r from-green-500 to-green-600' : consultation.statut == 'VALIDEE' ? 'bg-gradient-to-r from-blue-500 to-blue-600' : consultation.statut == 'ANNULEE' ? 'bg-gradient-to-r from-red-500 to-red-600' : 'bg-gradient-to-r from-yellow-500 to-yellow-600'}">
                            <div class="flex items-center space-x-4 text-white">
                                <div class="w-12 h-12 rounded-full bg-white/20 flex items-center justify-center">
                                    <i class="fas ${consultation.statut == 'TERMINEE' ? 'fa-check-circle' : consultation.statut == 'VALIDEE' ? 'fa-calendar-check' : consultation.statut == 'ANNULEE' ? 'fa-times-circle' : 'fa-clock'} text-2xl"></i>
                                </div>
                                <div>
                                    <h3 class="text-xl font-bold">Dr. ${consultation.docteur.nom} ${consultation.docteur.prenom}</h3>
                                    <p class="text-sm opacity-90">${consultation.docteur.specialite}</p>
                                </div>
                            </div>
                            <div class="text-right text-white">
                                <div class="text-lg font-bold">
                                    <fmt:formatDate value="${consultation.date}" pattern="MMM dd, yyyy"/>
                                </div>
                                <div class="text-sm opacity-90">
                                    <fmt:formatDate value="${consultation.heure}" pattern="HH:mm"/>
                                </div>
                            </div>
                        </div>

                        <div class="p-6">
                            <div class="grid grid-cols-3 gap-4 mb-6">
                                <div class="flex items-center space-x-3 bg-gray-50 rounded-lg p-3">
                                    <i class="fas fa-door-open text-teal-500 text-xl"></i>
                                    <div>
                                        <div class="text-xs text-gray-500">Room</div>
                                        <div class="font-semibold text-gray-800">${consultation.salle.nomSalle}</div>
                                    </div>
                                </div>
                                <div class="flex items-center space-x-3 bg-gray-50 rounded-lg p-3">
                                    <i class="fas fa-info-circle text-purple-500 text-xl"></i>
                                    <div>
                                        <div class="text-xs text-gray-500">Status</div>
                                        <div class="font-semibold ${consultation.statut == 'TERMINEE' ? 'text-green-600' : consultation.statut == 'VALIDEE' ? 'text-blue-600' : consultation.statut == 'ANNULEE' ? 'text-red-600' : 'text-yellow-600'}">
                                                ${consultation.statut}
                                        </div>
                                    </div>
                                </div>
                                <div class="flex items-center space-x-3 bg-gray-50 rounded-lg p-3">
                                    <i class="fas fa-hashtag text-blue-500 text-xl"></i>
                                    <div>
                                        <div class="text-xs text-gray-500">Consultation ID</div>
                                        <div class="font-semibold text-gray-800">#${consultation.idConsultation}</div>
                                    </div>
                                </div>
                            </div>

                            <c:if test="${consultation.statut == 'TERMINEE' && not empty consultation.compteRendu}">
                                <div class="bg-blue-50 border-l-4 border-blue-500 rounded-lg p-6">
                                    <h4 class="text-lg font-bold text-gray-800 mb-3 flex items-center">
                                        <i class="fas fa-file-medical-alt text-blue-600 mr-2"></i>
                                        Medical Report
                                    </h4>
                                    <div class="text-gray-700 whitespace-pre-line leading-relaxed">${consultation.compteRendu}</div>
                                </div>
                            </c:if>

                            <c:if test="${consultation.statut != 'TERMINEE' || empty consultation.compteRendu}">
                                <div class="bg-gray-50 border-l-4 border-gray-300 rounded-lg p-6 text-center">
                                    <i class="fas fa-file-excel text-gray-400 text-3xl mb-2"></i>
                                    <p class="text-gray-500 italic">No medical report available</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

</main>

</body>
</html>