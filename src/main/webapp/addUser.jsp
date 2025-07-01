<%-- 
    Document   : addUser
    Created on : 20 Jan 2025, 12:00:02 pm
    Author     : efeys
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add New User</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 500px;
            margin: 50px auto;
            background-color: #ffffff;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            color: #6A4C9C;
        }
        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }
        input[type="text"],
        input[type="email"],
        input[type="password"],
        select {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border-radius: 6px;
            border: 1px solid #ccc;
            box-sizing: border-box;
            font-size: 16px;
            height: 40px;
        }
        input[type="submit"] {
            margin-top: 25px;
            background-color: #6A4C9C;
            color: white;
            border: none;
            padding: 12px;
            width: 100%;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #5a3c8d;
        }
        .error {
            color: red;
            margin-top: 15px;
            text-align: center;
        }
        .back-link {
            margin-top: 20px;
            display: block;
            text-align: center;
            text-decoration: none;
            color: #6A4C9C;
        }
        .back-link:hover {
            text-decoration: underline;
        }
        /* Password toggle styles */
        .input-container {
            position: relative;
        }
        .toggle-password {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #6A4C9C;
            font-size: 14px;
            user-select: none;
            background: transparent;
            border: none;
            padding: 0 5px;
            height: 100%;
            display: flex;
            align-items: center;
        }
        /* Email lowercase feedback */
        .lowercase-feedback {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 12px;
            color: #6A4C9C;
            display: none;
            background: rgba(255,255,255,0.9);
            padding: 2px 5px;
            border-radius: 4px;
        }
        input[type="email"] {
            padding-right: 100px;
        }
        input[type="password"] {
            padding-right: 60px;
        }
        .error {
    color: #ff4d4d;
    background-color: #ffe5e5;
    border: 1px solid #ffcccc;
    padding: 10px;
    border-radius: 5px;
    font-weight: bold;
}

    </style>
</head>
<body>
<div class="container">
    <h2>Add New User</h2>

    <form action="addUserServlet" method="post" onsubmit="return convertEmailToLowercase()">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required>

        <label for="password">Password:</label>
        <div class="input-container">
            <input type="password" id="password" name="password" required>
            <button type="button" class="toggle-password" onclick="togglePasswordVisibility()">Show</button>
        </div>

        <label for="email">Email:</label>
        <div class="input-container">
            <input type="email" id="email" name="email" required oninput="showLowercaseFeedback()">
            <span class="lowercase-feedback" id="lowercaseFeedback">✓ Lowercased</span>
        </div>

        <label for="role">Role:</label>
        <select id="role" name="role" required>
            <option value="">-- Select Role --</option>
            <option value="Staff">Staff</option>
            <option value="HEPA">HEPA</option>
        </select>

        <input type="submit" value="Add User">
    </form>

    <%
        String error = (String) request.getAttribute("errorMessage");
        if (error != null) {
    %>
    <p class="error"><%= error %></p>
    <%
        }
    %>

    <a class="back-link" href="StaffDashboard.jsp">&larr; Back to Dashboard</a>
</div>

<script>
    // Password visibility toggle
    function togglePasswordVisibility() {
        const passwordInput = document.getElementById('password');
        const toggleButton = document.querySelector('.toggle-password');
        
        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            toggleButton.textContent = 'Hide';
        } else {
            passwordInput.type = 'password';
            toggleButton.textContent = 'Show';
        }
    }

    // Email lowercase conversion with feedback
    function convertEmailToLowercase() {
        const emailInput = document.getElementById('email');
        const originalEmail = emailInput.value;
        const lowercasedEmail = originalEmail.toLowerCase();
        
        if (originalEmail !== lowercasedEmail) {
            emailInput.value = lowercasedEmail;
            const feedback = document.getElementById('lowercaseFeedback');
            feedback.style.display = 'inline-block';
            setTimeout(() => {
                feedback.style.display = 'none';
            }, 2000);
        }
        return true;
    }

    // Show feedback when user types uppercase letters
    function showLowercaseFeedback() {
        const emailInput = document.getElementById('email');
        const feedback = document.getElementById('lowercaseFeedback');
        
        if (/[A-Z]/.test(emailInput.value)) {
            feedback.style.display = 'inline-block';
        } else {
            feedback.style.display = 'none';
        }
    }
</script>
</body>
</html>