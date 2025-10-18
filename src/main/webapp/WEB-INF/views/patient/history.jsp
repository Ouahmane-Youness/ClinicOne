<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My History - Clinic</title>
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
                   class="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md font-medium">
                    <i class="fas fa-home mr-2"></i>Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/patient/book-consultation"
                   class="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md font-medium">
                    <i class="fas fa-calendar-plus mr-2"></i>Book
                </a>
                <a href="${pageContext.request.contextPath}/patient/history"
                   class="text-blue-600 px-3 py-2 rounded-md font-medium border-b-2 border-blue-600">
                    <i class="fas fa-history mr-2"></i>History
                </a>
                <a href="${pageContext.request.contextPath}/patient/profile"
                   class="text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md font-medium">
                    <i class="fas fa-user mr-2"></i>Profile
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

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

    <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-800">My Medical History</h1>
        <p class="text-gray-600 mt-2">View your completed consultations and medical reports</p>
    </div>

    <c:if test="${not empty param.success}">
        <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-6 rounded">
            <div class="flex">
                <i class="fas fa-check-circle mt-1 mr-3"></i>
                <p>${param.success}</p>
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

    <c:choose>
        <c:when test="${not empty pastConsultations}">
            <div class="space-y-6">
                <c:forEach var="consultation" items="${pastConsultations}">
                    <div class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition duration-200">

                        <div class="bg-gradient-to-r ${consultation.statut == 'TERMINEE' ? 'from-green-500 to-green-600' : consultation.statut == 'VALIDEE' ? 'from-blue-500 to-blue-600' : consultation.statut == 'ANNULEE' ? 'from-red-500 to-red-600' : 'from-yellow-500 to-yellow-600'} px-6 py-4">
                            <div class="flex justify-between items-center">
                                <div class="flex items-center space-x-4">
                                    <div class="bg-white bg-opacity-20 rounded-full p-3">
                                        <i class="fas ${consultation.statut == 'TERMINEE' ? 'fa-check-circle' : consultation.statut == 'VALIDEE' ? 'fa-calendar-check' : consultation.statut == 'ANNULEE' ? 'fa-times-circle' : 'fa-clock'} text-white text-2xl"></i>
                                    </div>
                                    <div class="text-white">
                                        <h3 class="text-xl font-bold">Dr. ${consultation.docteur.nom} ${consultation.docteur.prenom}</h3>
                                        <p class="text-sm opacity-90">${consultation.docteur.specialite}</p>
                                    </div>
                                </div>
                                <div class="text-right text-white">
                                    <div class="text-lg font-bold">
                                            ${formattedDates[consultation.idConsultation]}
                                    </div>
                                    <div class="text-sm opacity-90">
                                            ${formattedTimes[consultation.idConsultation]}
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="p-6">
                            <div class="grid grid-cols-3 gap-4 mb-6">
                                <div class="flex items-center space-x-3 bg-gray-50 rounded-lg p-3">
                                    <i class="fas fa-door-open text-purple-500 text-xl"></i>
                                    <div>
                                        <div class="text-xs text-gray-500">Room</div>
                                        <div class="font-semibold text-gray-800">${consultation.salle.nomSalle}</div>
                                    </div>
                                </div>
                                <div class="flex items-center space-x-3 bg-gray-50 rounded-lg p-3">
                                    <i class="fas fa-info-circle text-purple-500 text-xl"></i>
                                    <div>
                                        <div class="text-xs text-gray-500">Status</div>
                                        <div class="font-semibold ${consultation.statut == 'TERMINEE' ? 'text-green-600' : consultation.statut == 'VALIDEE' ? 'text-blue-600' : consultation.statut == 'ANNULEE' ? 'text-red-600' : 'text-yellow-600'}">${consultation.statut}</div>
                                    </div>
                                </div>
                                <div class="flex items-center space-x-3 bg-gray-50 rounded-lg p-3">
                                    <i class="fas fa-calendar text-purple-500 text-xl"></i>
                                    <div>
                                        <div class="text-xs text-gray-500">Date</div>
                                        <div class="font-semibold text-gray-800">${formattedShortDates[consultation.idConsultation]}</div>
                                    </div>
                                </div>
                            </div>

                            <c:if test="${not empty consultation.compteRendu}">
                                <div class="border-t border-gray-200 pt-4">
                                    <h4 class="text-sm font-semibold text-gray-700 mb-2 flex items-center">
                                        <i class="fas fa-file-medical text-purple-500 mr-2"></i>
                                        Medical Report
                                    </h4>
                                    <div class="bg-gray-50 rounded-lg p-4">
                                        <p class="text-gray-700 text-sm whitespace-pre-wrap">${consultation.compteRendu}</p>
                                    </div>
                                </div>
                            </c:if>

                            <c:if test="${consultation.statut == 'ANNULEE'}">
                                <div class="border-t border-gray-200 pt-4 mt-4">
                                    <div class="bg-red-50 border-l-4 border-red-500 p-3 rounded">
                                        <p class="text-sm text-red-700">
                                            <i class="fas fa-info-circle mr-2"></i>
                                            This consultation was cancelled
                                        </p>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="bg-white rounded-lg shadow-md p-12 text-center">
                <i class="fas fa-history text-gray-300 text-6xl mb-4"></i>
                <h3 class="text-xl font-semibold text-gray-600 mb-2">No Consultation History</h3>
                <p class="text-gray-500 mb-6">You haven't had any completed consultations yet.</p>
                <a href="${pageContext.request.contextPath}/patient/book-consultation"
                   class="inline-block bg-blue-500 hover:bg-blue-600 text-white px-6 py-3 rounded-lg transition duration-200">
                    <i class="fas fa-calendar-plus mr-2"></i>Book Your First Consultation
                </a>
            </div>
        </c:otherwise>
    </c:choose>

</div>

</body>
</html>