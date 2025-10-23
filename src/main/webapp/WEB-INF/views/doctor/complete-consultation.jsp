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
    <style>
        .card-hover {
            transition: all 0.3s ease;
        }
        .card-hover:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }
        .pulse-animation {
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.5; }
        }
        .gradient-bg {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .medical-template {
            background: #f8fafc;
            border: 2px dashed #cbd5e0;
            transition: all 0.3s ease;
        }
        .medical-template:hover {
            border-color: #4299e1;
            background: #ebf8ff;
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

<main class="max-w-6xl mx-auto py-8 px-4 sm:px-6 lg:px-8">

    <!-- Header Section -->
    <div class="mb-8">
        <div class="flex items-center space-x-4 mb-6">
            <a href="${pageContext.request.contextPath}/doctor/dashboard"
               class="text-blue-600 hover:text-blue-700 font-medium text-sm flex items-center space-x-2 bg-blue-50 hover:bg-blue-100 px-4 py-2 rounded-lg transition">
                <i class="fas fa-arrow-left"></i>
                <span>Back to Dashboard</span>
            </a>
            <div class="flex-1"></div>
            <div class="text-right">
                <p class="text-sm text-gray-500">Consultation in progress</p>
                <div class="flex items-center space-x-2">
                    <div class="w-3 h-3 bg-green-500 rounded-full pulse-animation"></div>
                    <span class="text-sm font-medium text-green-600">Active Session</span>
                </div>
            </div>
        </div>

        <div class="text-center">
            <div class="w-20 h-20 gradient-bg rounded-full flex items-center justify-center mx-auto mb-4">
                <i class="fas fa-stethoscope text-white text-3xl"></i>
            </div>
            <h1 class="text-3xl font-bold text-gray-900">Complete Consultation</h1>
            <p class="mt-2 text-lg text-gray-600">Add medical report and finalize the consultation</p>
        </div>
    </div>

    <!-- Error Display -->
    <c:if test="${not empty error}">
        <div class="mb-6 bg-red-50 border-l-4 border-red-400 p-4 rounded-lg shadow-sm">
            <div class="flex">
                <i class="fas fa-exclamation-circle text-red-400 text-xl mr-3"></i>
                <p class="text-sm text-red-700 font-medium">${error}</p>
            </div>
        </div>
    </c:if>

    <!-- Patient Information Card -->
    <div class="bg-white rounded-2xl shadow-lg overflow-hidden mb-8 card-hover">
        <div class="gradient-bg px-8 py-8">
            <div class="flex items-center space-x-6">
                <div class="w-24 h-24 rounded-full bg-white flex items-center justify-center text-blue-600 text-3xl font-bold shadow-lg">
                    ${consultation.patient.prenom.substring(0,1)}${consultation.patient.nom.substring(0,1)}
                </div>
                <div class="text-white flex-1">
                    <h2 class="text-3xl font-bold">${consultation.patient.prenom} ${consultation.patient.nom}</h2>
                    <p class="text-blue-100 mt-1 text-lg">${consultation.patient.email}</p>
                    <div class="mt-3 flex items-center space-x-4">
                        <span class="bg-white bg-opacity-20 px-3 py-1 rounded-full text-sm flex items-center space-x-2">
                            <i class="fas fa-id-card"></i>
                            <span>Patient ID: ${consultation.patient.id}</span>
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Consultation Details Grid -->
        <div class="p-8">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                <!-- Date -->
                <div class="bg-gradient-to-br from-blue-50 to-blue-100 rounded-xl p-6 border border-blue-200">
                    <div class="flex items-center space-x-3">
                        <div class="w-12 h-12 rounded-full bg-blue-500 flex items-center justify-center">
                            <i class="fas fa-calendar text-white text-xl"></i>
                        </div>
                        <div>
                            <p class="text-xs text-blue-600 font-medium uppercase tracking-wide">Date</p>
                            <p class="text-lg font-bold text-blue-800">${formattedDate}</p>
                        </div>
                    </div>
                </div>

                <!-- Time -->
                <div class="bg-gradient-to-br from-purple-50 to-purple-100 rounded-xl p-6 border border-purple-200">
                    <div class="flex items-center space-x-3">
                        <div class="w-12 h-12 rounded-full bg-purple-500 flex items-center justify-center">
                            <i class="fas fa-clock text-white text-xl"></i>
                        </div>
                        <div>
                            <p class="text-xs text-purple-600 font-medium uppercase tracking-wide">Time</p>
                            <p class="text-lg font-bold text-purple-800">${formattedTime}</p>
                        </div>
                    </div>
                </div>

                <!-- Room -->
                <div class="bg-gradient-to-br from-green-50 to-green-100 rounded-xl p-6 border border-green-200">
                    <div class="flex items-center space-x-3">
                        <div class="w-12 h-12 rounded-full bg-green-500 flex items-center justify-center">
                            <i class="fas fa-door-open text-white text-xl"></i>
                        </div>
                        <div>
                            <p class="text-xs text-green-600 font-medium uppercase tracking-wide">Room</p>
                            <p class="text-lg font-bold text-green-800">${consultation.salle.nomSalle}</p>
                        </div>
                    </div>
                </div>

                <!-- Status -->
                <div class="bg-gradient-to-br from-yellow-50 to-yellow-100 rounded-xl p-6 border border-yellow-200">
                    <div class="flex items-center space-x-3">
                        <div class="w-12 h-12 rounded-full bg-yellow-500 flex items-center justify-center">
                            <i class="fas fa-check-circle text-white text-xl"></i>
                        </div>
                        <div>
                            <p class="text-xs text-yellow-600 font-medium uppercase tracking-wide">Status</p>
                            <p class="text-lg font-bold text-yellow-800">${consultation.statut}</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Patient Health Information -->
            <div class="border-t border-gray-200 pt-8">
                <h3 class="text-xl font-bold text-gray-800 mb-6 flex items-center">
                    <i class="fas fa-user-md text-blue-500 mr-3"></i>
                    Patient Health Information
                </h3>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div class="bg-gray-50 rounded-xl p-6">
                        <div class="flex items-center space-x-3">
                            <i class="fas fa-weight text-gray-600 text-xl"></i>
                            <div>
                                <p class="text-sm text-gray-500">Weight</p>
                                <p class="text-lg font-bold text-gray-800">
                                    <c:choose>
                                        <c:when test="${not empty consultation.patient.poids}">
                                            ${consultation.patient.poids} kg
                                        </c:when>
                                        <c:otherwise>
                                            Not recorded
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="bg-gray-50 rounded-xl p-6">
                        <div class="flex items-center space-x-3">
                            <i class="fas fa-ruler-vertical text-gray-600 text-xl"></i>
                            <div>
                                <p class="text-sm text-gray-500">Height</p>
                                <p class="text-lg font-bold text-gray-800">
                                    <c:choose>
                                        <c:when test="${not empty consultation.patient.taille}">
                                            ${consultation.patient.taille} cm
                                        </c:when>
                                        <c:otherwise>
                                            Not recorded
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="bg-gray-50 rounded-xl p-6">
                        <div class="flex items-center space-x-3">
                            <i class="fas fa-calculator text-gray-600 text-xl"></i>
                            <div>
                                <p class="text-sm text-gray-500">BMI</p>
                                <p class="text-lg font-bold text-gray-800">
                                    <c:choose>
                                        <c:when test="${not empty consultation.patient.poids && not empty consultation.patient.taille}">
                                            <c:set var="bmi" value="${consultation.patient.poids / ((consultation.patient.taille / 100) * (consultation.patient.taille / 100))}"/>
                                            <c:choose>
                                                <c:when test="${bmi < 10 || bmi > 50}">
                                                    Invalid data
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
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Medical Report Form -->
    <div class="bg-white rounded-2xl shadow-lg overflow-hidden card-hover">
        <div class="bg-gradient-to-r from-gray-50 to-white px-8 py-6 border-b border-gray-200">
            <div class="flex items-center justify-between">
                <div class="flex items-center space-x-3">
                    <div class="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
                        <i class="fas fa-file-medical-alt text-blue-600 text-xl"></i>
                    </div>
                    <div>
                        <h2 class="text-2xl font-bold text-gray-800">Medical Report</h2>
                        <p class="text-gray-600">Document findings and treatment plan</p>
                    </div>
                </div>
                <div class="text-right">
                    <p class="text-sm text-gray-500">Required field</p>
                    <p class="text-xs text-red-600 flex items-center"><i class="fas fa-asterisk mr-1"></i>Mandatory</p>
                </div>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/doctor/complete-consultation" method="post" class="p-8">
            <input type="hidden" name="consultationId" value="${consultation.idConsultation}">

            <!-- Quick Templates -->
            <div class="mb-8">
                <h3 class="text-lg font-semibold text-gray-800 mb-4">Quick Report Templates</h3>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div class="medical-template rounded-xl p-4 cursor-pointer" onclick="useTemplate('routine')">
                        <div class="flex items-center space-x-3">
                            <i class="fas fa-clipboard-check text-blue-500 text-xl"></i>
                            <div>
                                <p class="font-semibold text-gray-800">Routine Checkup</p>
                                <p class="text-sm text-gray-600">Standard health examination template</p>
                            </div>
                        </div>
                    </div>
                    <div class="medical-template rounded-xl p-4 cursor-pointer" onclick="useTemplate('followup')">
                        <div class="flex items-center space-x-3">
                            <i class="fas fa-redo text-green-500 text-xl"></i>
                            <div>
                                <p class="font-semibold text-gray-800">Follow-up Visit</p>
                                <p class="text-sm text-gray-600">Progress review template</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Text Area -->
            <div class="mb-8">
                <label class="block text-lg font-semibold text-gray-700 mb-4">
                    Medical Report Content
                    <span class="text-red-500 ml-1">*</span>
                </label>

                <div class="relative">
                    <textarea
                            id="medicalReport"
                            name="compteRendu"
                            required
                            rows="15"
                            placeholder="Enter comprehensive medical report...&#10;&#10;Suggested sections:&#10;• Chief Complaint&#10;• Present Illness&#10;• Physical Examination&#10;• Assessment/Diagnosis&#10;• Treatment Plan&#10;• Medications&#10;• Follow-up Instructions"
                            class="w-full px-6 py-4 border-2 border-gray-200 rounded-xl focus:border-blue-500 focus:outline-none transition resize-none text-gray-700 leading-relaxed"
                    ></textarea>

                    <div class="absolute bottom-4 right-4 text-xs text-gray-400">
                        <span id="charCount">0</span> characters
                    </div>
                </div>

                <!-- Helper Text -->
                <div class="mt-4 bg-blue-50 border border-blue-200 rounded-lg p-4">
                    <div class="flex items-start space-x-3">
                        <i class="fas fa-info-circle text-blue-500 text-lg mt-0.5"></i>
                        <div class="text-sm text-blue-700">
                            <p class="font-semibold mb-1">Report Guidelines:</p>
                            <ul class="list-disc list-inside space-y-1 text-blue-600">
                                <li>Be clear and objective in your assessment</li>
                                <li>Include all relevant findings and observations</li>
                                <li>Specify any prescribed medications and dosages</li>
                                <li>Provide clear follow-up instructions</li>
                                <li>This report will be accessible to the patient</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="flex justify-between items-center pt-8 border-t border-gray-200">
                <div class="flex items-center space-x-4">
                    <a href="${pageContext.request.contextPath}/doctor/dashboard"
                       class="px-8 py-3 border-2 border-gray-300 text-gray-700 font-semibold rounded-xl hover:bg-gray-50 transition duration-200 flex items-center space-x-2">
                        <i class="fas fa-times"></i>
                        <span>Cancel</span>
                    </a>
                    <button type="button" onclick="saveDraft()"
                            class="px-8 py-3 border-2 border-blue-300 text-blue-700 font-semibold rounded-xl hover:bg-blue-50 transition duration-200 flex items-center space-x-2">
                        <i class="fas fa-save"></i>
                        <span>Save Draft</span>
                    </button>
                </div>

                <button type="submit" id="submitBtn"
                        class="px-12 py-3 bg-gradient-to-r from-green-500 to-green-600 text-white font-bold rounded-xl hover:from-green-600 hover:to-green-700 transition transform hover:scale-105 shadow-lg flex items-center space-x-2">
                    <i class="fas fa-check-double"></i>
                    <span>Complete Consultation</span>
                </button>
            </div>
        </form>
    </div>

</main>

<script>
// Character count functionality
const textarea = document.getElementById('medicalReport');
const charCount = document.getElementById('charCount');

textarea.addEventListener('input', function() {
    charCount.textContent = this.value.length;

    // Change color based on length
    if (this.value.length < 100) {
        charCount.className = 'text-red-400';
    } else if (this.value.length < 500) {
        charCount.className = 'text-yellow-400';
    } else {
        charCount.className = 'text-green-400';
    }
});

// Template functions
function useTemplate(type) {
    const textarea = document.getElementById('medicalReport');
    let template = '';

    if (type === 'routine') {
        template = `CHIEF COMPLAINT:
[Patient's main concern or reason for visit]

PRESENT ILLNESS:
[Description of current symptoms, duration, severity, associated factors]

PHYSICAL EXAMINATION:
• Vital Signs:
• General Appearance:
• Head/Neck:
• Cardiovascular:
• Respiratory:
• Abdomen:
• Neurological:

ASSESSMENT:
[Primary diagnosis and differential diagnoses]

TREATMENT PLAN:
1.
2.
3.

MEDICATIONS:
[Prescribed medications with dosage and instructions]

FOLLOW-UP:
[Next appointment recommendations and instructions]

PATIENT EDUCATION:
[Information provided to patient about condition and care]`;
    } else if (type === 'followup') {
        template = `FOLLOW-UP CONSULTATION

PREVIOUS DIAGNOSIS:
[Reference to previous condition/diagnosis]

CURRENT STATUS:
[Patient's current condition and progress since last visit]

SYMPTOM REVIEW:
• Improvement:
• Unchanged:
• Worsening:

EXAMINATION FINDINGS:
[Relevant physical examination findings]

ASSESSMENT:
[Progress evaluation and current status]

PLAN MODIFICATIONS:
[Any changes to treatment plan]

MEDICATIONS:
• Continue:
• Modify:
• Discontinue:
• New:

NEXT STEPS:
[Follow-up schedule and recommendations]`;
    }

    textarea.value = template;
    textarea.focus();

    // Update character count
    charCount.textContent = template.length;
    charCount.className = 'text-green-400';
}

// Save draft functionality
function saveDraft() {
    const content = document.getElementById('medicalReport').value;
    if (content.trim()) {
        localStorage.setItem('consultation_draft_${consultation.idConsultation}', content);

        // Show success message
        const btn = event.target;
        const originalText = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-check mr-2"></i>Saved!';
        btn.className = btn.className.replace('border-blue-300 text-blue-700', 'border-green-300 text-green-700');

        setTimeout(() => {
            btn.innerHTML = originalText;
            btn.className = btn.className.replace('border-green-300 text-green-700', 'border-blue-300 text-blue-700');
        }, 2000);
    }
}

// Load draft on page load
document.addEventListener('DOMContentLoaded', function() {
    const savedDraft = localStorage.getItem('consultation_draft_${consultation.idConsultation}');
    if (savedDraft) {
        document.getElementById('medicalReport').value = savedDraft;
        charCount.textContent = savedDraft.length;

        // Show notification about loaded draft
        const notification = document.createElement('div');
        notification.className = 'fixed top-4 right-4 bg-blue-500 text-white px-4 py-2 rounded-lg shadow-lg z-50';
        notification.innerHTML = '<i class="fas fa-info-circle mr-2"></i>Draft loaded from local storage';
        document.body.appendChild(notification);

        setTimeout(() => {
            notification.remove();
        }, 3000);
    }

    // Auto-save every 30 seconds
    setInterval(() => {
        const content = document.getElementById('medicalReport').value;
        if (content.trim()) {
            localStorage.setItem('consultation_draft_${consultation.idConsultation}', content);
        }
    }, 30000);

    // Form validation
    const form = document.querySelector('form');
    const submitBtn = document.getElementById('submitBtn');

    form.addEventListener('submit', function(e) {
        const content = document.getElementById('medicalReport').value.trim();

        if (content.length < 50) {
            e.preventDefault();
            alert('Please provide a more detailed medical report (minimum 50 characters).');
            return;
        }

        // Show loading state
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Processing...';

        // Clear draft after successful submission
        localStorage.removeItem('consultation_draft_${consultation.idConsultation}');
    });

    // Real-time validation
    textarea.addEventListener('input', function() {
        const content = this.value.trim();
        const submitBtn = document.getElementById('submitBtn');

        if (content.length < 50) {
            submitBtn.classList.add('opacity-50', 'cursor-not-allowed');
            submitBtn.disabled = true;
        } else {
            submitBtn.classList.remove('opacity-50', 'cursor-not-allowed');
            submitBtn.disabled = false;
        }
    });
});

// Keyboard shortcuts
document.addEventListener('keydown', function(e) {
    // Ctrl+S to save draft
    if (e.ctrlKey && e.key === 's') {
        e.preventDefault();
        saveDraft();
    }

    // Ctrl+Enter to submit form
    if (e.ctrlKey && e.key === 'Enter') {
        e.preventDefault();
        const content = document.getElementById('medicalReport').value.trim();
        if (content.length >= 50) {
            document.querySelector('form').submit();
        }
    }
});
</script>

</body>
</html>