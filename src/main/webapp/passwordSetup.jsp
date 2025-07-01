<%-- 
    Document   : passwordSetup
    Created on : 10 Jun 2025, 7:25:56 pm
    Author     : efeys
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    String email = request.getParameter("email");
    if (email == null || email.isEmpty()) {
        response.sendRedirect("verifyEmail.jsp?error=Please verify your email first");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Set New Password</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap');

        body {
            font-family: 'Poppins', Arial, sans-serif;
            background-color: #f9fafb; /* very light gray */
            color: #333;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .container {
            background-color: #ffffff;
            max-width: 420px;
            width: 90%;
            padding: 40px 45px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            text-align: center;
            transition: box-shadow 0.3s ease;
        }
        .container:hover {
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.12);
        }

        h2 {
            color: #6A4C9C;
            font-size: 2.1em;
            margin-bottom: 30px;
            font-weight: 600;
            letter-spacing: 0.02em;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 25px;
            text-align: left;
        }

        label {
            font-weight: 600;
            color: #6A4C9C;
            margin-bottom: 8px;
            user-select: none;
        }

        input[type="password"] {
            padding: 14px 18px;
            font-size: 1rem;
            border-radius: 8px;
            border: 1.6px solid #ccc;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
            width: 100%;
            box-sizing: border-box;
        }

        input[type="password"]:focus {
            border-color: #6A4C9C;
            outline: none;
            box-shadow: 0 0 8px rgba(106, 76, 156, 0.25);
        }

        input[type="submit"] {
            background-color: #6A4C9C;
            color: white;
            font-weight: 600;
            border: none;
            border-radius: 35px;
            padding: 14px 0;
            font-size: 1.15rem;
            cursor: pointer;
            box-shadow: 0 5px 12px rgba(106, 76, 156, 0.3);
            transition: background-color 0.3s ease, box-shadow 0.3s ease, transform 0.25s ease;
            letter-spacing: 0.05em;
            user-select: none;
        }

        input[type="submit"]:hover {
            background-color: #8659c0;
            box-shadow: 0 8px 20px rgba(134, 89, 192, 0.5);
            transform: translateY(-2px);
        }

        .error-message {
            margin-top: 20px;
            color: #d32f2f;
            background-color: #fce4e4;
            border: 1.5px solid #d32f2f;
            padding: 12px;
            border-radius: 6px;
            font-weight: 700;
            text-align: center;
            user-select: none;
        }

        /* Responsive */
        @media (max-width: 440px) {
            .container {
                padding: 30px 25px;
            }
            h2 {
                font-size: 1.7em;
            }
        }
    </style>
</head>
<body>
<div class="container" role="main" aria-label="Set New Password Form">
    <h2>Set Your Password</h2>
    <form action="PasswordSetupServlet" method="post" novalidate>
        <input type="hidden" name="email" value="<%= email %>" />

        <label for="password">New Password:</label>
        <input type="password" id="password" name="password" placeholder="Enter new password" required autocomplete="new-password" />

        <label for="confirmPassword">Confirm Password:</label>
        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm new password" required autocomplete="new-password" />

        <input type="submit" value="Set Password" />
    </form>
    <%
        String error = request.getParameter("error");
        if (error != null) {
    %>
    <p class="error-message" role="alert"><%= error %></p>
    <% } %>
</div>
</body>
</html>

