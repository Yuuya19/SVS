<%-- 
    Document   : verifyEmail.jsp
    Created on : 10 Jun 2025, 7:22:33 pm
    Author     : efeys
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Verify Email</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap');

        body {
            font-family: 'Poppins', Arial, sans-serif;
            background-color: #f9fafb; /* very light gray */
            margin: 0;
            padding: 0;
            display: flex;
            height: 100vh;
            justify-content: center;
            align-items: center;
            color: #333;
        }
        .container {
            background: #ffffff;
            padding: 40px 45px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            width: 380px;
            text-align: center;
            transition: box-shadow 0.3s ease;
        }
        .container:hover {
            box-shadow: 0 12px 35px rgba(0,0,0,0.12);
        }
        h2 {
            color: #6A4C9C;
            margin-bottom: 30px;
            font-weight: 600;
            font-size: 2.1em;
            letter-spacing: 0.02em;
        }
        label {
            display: block;
            text-align: left;
            margin-bottom: 10px;
            font-weight: 600;
            color: #6A4C9C;
            font-size: 1rem;
            user-select: none;
        }
        input[type="text"], input[type="email"] {
            width: 100%;
            padding: 14px 18px;
            border: 1.6px solid #ccc;
            border-radius: 8px;
            margin-bottom: 25px;
            font-size: 1rem;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
            box-sizing: border-box;
        }
        input[type="text"]:focus, input[type="email"]:focus {
            border-color: #6A4C9C;
            outline: none;
            box-shadow: 0 0 8px rgba(106, 76, 156, 0.25);
        }
        input[type="submit"] {
            background-color: #6A4C9C;
            color: white;
            border: none;
            padding: 14px 0;
            width: 100%;
            border-radius: 35px;
            font-size: 1.15rem;
            cursor: pointer;
            font-weight: 600;
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
        .error-msg {
            color: #d32f2f;
            font-weight: 700;
            margin-top: 20px;
            font-size: 0.95rem;
            background-color: #fce4e4;
            border: 1.5px solid #d32f2f;
            padding: 12px;
            border-radius: 6px;
            text-align: center;
            user-select: none;
        }
        /* Responsive */
        @media (max-width: 420px) {
            .container {
                width: 90%;
                padding: 30px 25px;
            }
            h2 {
                font-size: 1.7em;
            }
        }
    </style>
</head>
<body>
    <div class="container" role="main" aria-label="Verify Email Form">
        <h2>Verify Your Email</h2>
        <form action="VerifyEmailServlet" method="post" novalidate>
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" placeholder="Enter your username" required autocomplete="username" />
            
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" placeholder="Enter your email address" required autocomplete="email" />
            
            <input type="submit" value="Verify" />
        </form>
        <%
            String error = request.getParameter("error");
            if (error != null) {
        %>
        <p class="error-msg" role="alert"><%= error %></p>
        <% } %>
    </div>
</body>
</html>
