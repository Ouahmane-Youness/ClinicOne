<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Medical History - Clinico</title>
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
                    <a href="${pageContext.request.contextPath}/patient/book-consultation" class="border-b-2 border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700 inline-flex items-center px-1 pt-1 text-sm font-medium">
                        Book Consultation
                    </a>
                    <a href="${pageContext.request.contextPath}/patient/history" class="border-b-2 border-blue-500 text-gray-900 inline-flex items-center px-1 pt-1 text-sm font-medium">
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

<main class="max-w-7xl mx-auto py-8 px-4 sm:px-6 lg:px-8">

    <div class="mb-8 flex items-center justify-between">
        <div>
            <h1 class="text-3xl font-bold text-gray-900">Medical History</h1>
            <p class="mt-2 text-sm text-gray-600">View your past consultations and medical reports</p>
        </div>
        <div class="bg-white rounded-xl shadow px-6 py-4">
            <div class="text-sm text-gray-500">Total Consultations</div>
            <div class="text-3xl font-bold text-blue-600">${pastConsultations.size()}</div>
        </div>
    </div>

    <c:if test="${not empty error}">
        <div class="mb-6 bg-red-50 border-l-4 border-red-400 p-4 rounded-lg">
            <div class="flex">
                <i class="fas fa-exclamation-circle text-red-400 text-xl"></i>
                <p class="ml-3 text-sm text-red-700">${error}</p>
            </div>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${empty pastConsultations}">
            <div class="bg-white rounded-2xl shadow-lg p-12 text-center">
                <div class="inline-flex items-center justify-center w-24 h-24 rounded-full bg-gray-100 mb-6">
                    <i class="fas fa-history text-5xl text-gray-400"></i>
                </div>
                <h2 class="text-2xl font-bold text-gray-800 mb-2">No Medical History Yet</h2>
                <p class="text-gray-600 mb-6">Your completed consultations will appear here</p>
                <a href="${pageContext.request.contextPath}/patient/book-consultation" class="inline-flex items-center px-6 py-3 bg-gradient-to-r from-blue-500 to-blue-600 text-white font-semibold rounded-xl hover:from-blue-600 hover:to-blue-700 transition">
                    <i class="fas fa-calendar-plus mr-2"></i>
                    Book Your First Consultation
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="space-y-6">
                <c:forEach items="${pastConsultations}" var="consultation">
                    <div class="bg-white rounded-2xl shadow-lg overflow-hidden hover:shadow-xl transition">
                        <div class="bg-gradient-to-r from-purple-500 to-purple-600 px-6 py-4 text-white">
                            <div class="flex items-center justify-between">
                                <div class="flex items-center space-x-3">
                                    <div class="w-12 h-12 rounded-full bg-white/20 flex items-center justify-center">
                                        <i class="fas fa-user-md text-2xl"></i>
                                    </div>
                                    <div>
                                        <h3 class="text-xl font-bold">Dr. ${consultation.docteur.nom} ${consultation.docteur.prenom}</h3>
                                        <p class="text-sm text-purple-100">${consultation.docteur.specialite}</p>
                                    </div>
                                </div>
                                <div class="text-right">
                                    <div class="text-sm text-purple-100">Consultation Date</div>
                                    <div class="text-lg font-bold">
                                        <fmt:formatDate value="${consultation.date}" pattern="MMM dd, yyyy"/>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="p-6">
                            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
                                <div class="flex items-center space-x-3 bg-gray-50 rounded-lg p-4">
                                    <i class="fas fa-calendar text-purple-500 text-xl"></i>
                                    <div>
                                        <div class="text-xs text-gray-500">Date</div>
                                        <div class="font-semibold text-gray-800">
                                            <fmt:formatDate value="${consultation.date}" pattern="EEEE, MMM dd"/>
                                        </div>
                                    </div>
                                </div>
                                <div class="flex items-center space-x-3 bg-gray-50 rounded-lg p-4">
                                    <i class="fas fa-clock text-purple-500 text-xl"></i>
                                    <div>
                                        <div class="text-xs text-gray-500">Time</div>
                                        <div class="font-semibold text-gray-800">
                                            <fmt:formatDate value="${consultation.heure}" pattern="HH:mm"/>
                                        </div>
                                    </div>
                                </div>
                                <div class="flex items-center space-x-3 bg-gray-50 rounded-lg p-4">
                                    <i class="fas fa-door-open text-purple-500 text-xl"></i>
                                    <div>
                                        <div class="text-xs text-gray-500">Room</div>
                                        <div class="font-semibold text-gray-800">${consultation.salle.nomSalle}</div>
                                    </div>
                                </div>
                            </div>

                            <div class="bg-blue-50 border-l-4 border-blue-500 rounded-lg p-6">
                                <div class="flex items-start space-x-3 mb-3">
                                    <i class="fas fa-file-medical-alt text-blue-600 text-xl mt-1"></i>
                                    <div class="flex-1">
                                        <h4 class="text-lg font-bold text-gray-800 mb-2">Medical Report</h4>
                                        <c:choose>
                                            <c:when test="${consultation.statut == 'TERMINEE' && not empty consultation.compteRendu}">
                                                <div class="text-gray-700 whitespace-pre-line leading-relaxed">${consultation.compteRendu}</div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="text-gray-500 italic">No medical report available for this consultation</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <div class="mt-4 flex items-center justify-between">
                                <div>
                                    <c:choose>
                                        <c:when test="${consultation.statut == 'TERMINEE'}">
                                                <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-green-100 text-green-800">
                                                    <i class="fas fa-check-circle mr-1"></i>
                                                    Completed
                                                </span>
                                        </c:when>
                                        <c:when test="${consultation.statut == 'ANNULEE'}">
                                                <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-red-100 text-red-800">
                                                    <i class="fas fa-times-circle mr-1"></i>
                                                    Cancelled
                                                </span>
                                        </c:when>
                                    </c:choose>
                                </div>
                                <div class="text-sm text-gray-500">
                                    Consultation ID: #${consultation.idConsultation}
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

</main>

</body>
</html>