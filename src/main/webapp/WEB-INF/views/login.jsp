<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clinico - Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-white min-h-screen flex items-center justify-center p-8">

<div class="flex rounded-2xl shadow-2xl overflow-hidden max-w-5xl w-full">

    <div class="w-1/2 bg-gradient-to-br from-teal-700 to-teal-900 p-16 flex flex-col justify-between">

        <div class="flex items-center gap-3 text-white">
            <div class="bg-red-500 rounded-full p-2">
                <i class="fas fa-plus text-2xl"></i>
            </div>
            <span class="text-2xl font-bold">Clinico</span>
        </div>

        <div class="flex items-center justify-center">
            <img src="${pageContext.request.contextPath}/images/loginIll.jpg" alt="Doctor Illustration" class="w-full max-w-md">
        </div>

        <div class="text-center text-white/80 text-sm">
            © 2025 - Clinico Management System
        </div>
    </div>

    <div class="w-1/2 bg-white p-16 flex flex-col justify-center">

        <div class="inline-flex items-center gap-2 bg-red-50 text-red-600 px-4 py-2 rounded-full text-sm font-semibold mb-6 self-start">
            <i class="fas fa-hospital"></i>
            <span>Clinico System</span>
        </div>

        <h1 class="text-4xl font-bold text-gray-800 mb-2">Welcome Back!</h1>
        <p class="text-gray-500 mb-8">Please login to your account</p>

        <c:if test="${not empty error}">
            <div class="bg-red-50 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded-lg flex items-center gap-3">
                <i class="fas fa-exclamation-circle text-xl"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" class="space-y-5">

            <div>
                <label class="block text-gray-700 font-medium mb-2 text-sm">Login As</label>
                <div class="relative">
                    <i class="fas fa-user-tag absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                    <select
                            name="userType"
                            required
                            class="w-full pl-12 pr-4 py-3 border-2 border-gray-200 rounded-xl focus:border-blue-500 focus:outline-none transition appearance-none bg-white"
                    >
                        <option value="" disabled ${empty userType ? 'selected' : ''}>Select your role</option>
                        <option value="PATIENT" ${userType == 'PATIENT' ? 'selected' : ''}>Patient</option>
                        <option value="DOCTEUR" ${userType == 'DOCTEUR' ? 'selected' : ''}>Doctor</option>
                        <option value="ADMIN" ${userType == 'ADMIN' ? 'selected' : ''}>Admin</option>
                    </select>
                    <i class="fas fa-chevron-down absolute right-4 top-1/2 transform -translate-y-1/2 text-gray-400 pointer-events-none"></i>
                </div>
            </div>

            <div>
                <label class="block text-gray-700 font-medium mb-2 text-sm">Email Address</label>
                <div class="relative">
                    <i class="fas fa-envelope absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                    <input
                            type="email"
                            name="email"
                            value="${email}"
                            placeholder="your.email@example.com"
                            required
                            class="w-full pl-12 pr-4 py-3 border-2 border-gray-200 rounded-xl focus:border-blue-500 focus:outline-none transition"
                    >
                </div>
            </div>

            <div>
                <label class="block text-gray-700 font-medium mb-2 text-sm">Password</label>
                <div class="relative">
                    <i class="fas fa-lock absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                    <input
                            type="password"
                            name="password"
                            id="password"
                            placeholder="••••••••••"
                            required
                            class="w-full pl-12 pr-12 py-3 border-2 border-gray-200 rounded-xl focus:border-blue-500 focus:outline-none transition"
                    >
                    <i
                            class="fas fa-eye absolute right-4 top-1/2 transform -translate-y-1/2 text-gray-400 cursor-pointer hover:text-blue-500 transition"
                            id="togglePassword"
                            onclick="togglePassword()"
                    ></i>
                </div>
            </div>

            <button
                    type="submit"
                    class="w-full bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700 text-white font-semibold py-3 rounded-xl transition duration-300 transform hover:scale-[1.02] active:scale-[0.98] shadow-lg hover:shadow-xl"
            >
                Login
            </button>
        </form>

        <div class="flex items-center justify-center gap-4 mt-6 text-sm">
            <a href="#" class="text-blue-500 hover:text-blue-700 font-medium transition">Lost your password?</a>
            <span class="text-gray-300">|</span>
            <a href="${pageContext.request.contextPath}/patient/register" class="text-blue-500 hover:text-blue-700 font-medium transition">Register Account</a>
        </div>
    </div>
</div>

<script>
    function togglePassword() {
        const passwordInput = document.getElementById('password');
        const toggleIcon = document.getElementById('togglePassword');

        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            toggleIcon.classList.remove('fa-eye');
            toggleIcon.classList.add('fa-eye-slash');
        } else {
            passwordInput.type = 'password';
            toggleIcon.classList.remove('fa-eye-slash');
            toggleIcon.classList.add('fa-eye');
        }
    }
</script>
</body>
</html>