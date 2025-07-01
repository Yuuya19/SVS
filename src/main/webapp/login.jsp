<%-- 
    Document   : login
    Created on : 20 Jan 2025, 10:38:33 am
    Author     : efeys
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Login</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap');

        /* Global Styles */
        body {
            font-family: 'Poppins', 'Helvetica Neue', sans-serif;
            background-color: #f9fafb;
            color: #333;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        header {
            background-color: #6A4C9C;
            color: #fff;
            padding: 30px 0;
            text-align: center;
            font-size: 2.25rem;
            font-weight: 700;
            text-transform: uppercase;
            user-select: none;
        }

        footer {
            background-color: #6A4C9C;
            color: #fff;
            padding: 12px 0;
            text-align: center;
            font-size: 0.9rem;
            user-select: none;
        }

        .container {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .logo {
            width: 120px;
            margin-bottom: 25px;
            user-select: none;
        }

        .login-box {
            background-color: #fff;
            border-radius: 12px;
            padding: 40px 45px;
            max-width: 400px;
            width: 100%;
            box-shadow: 0 10px 28px rgba(0,0,0,0.08);
            text-align: center;
            transition: box-shadow 0.3s ease;
        }
        .login-box:hover {
            box-shadow: 0 12px 35px rgba(0,0,0,0.12);
        }

        h2 {
            font-size: 1.6rem;
            color: #6A4C9C;
            margin-bottom: 20px;
            font-weight: 600;
            letter-spacing: 0.03em;
            user-select: none;
        }

        .info-hint {
            background-color: #f0e6ff;
            border-left: 5px solid #6A4C9C;
            color: #4A2A6A;
            padding: 14px 18px;
            margin: 18px 0 28px;
            font-size: 0.9rem;
            border-radius: 8px;
            text-align: left;
            user-select: none;
        }

        form {
            text-align: left;
        }

        .form-group {
            margin-bottom: 22px;
        }

        label {
            display: block;
            font-size: 1rem;
            color: #6A4C9C;
            font-weight: 600;
            margin-bottom: 6px;
            user-select: none;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 14px 16px;
            font-size: 1rem;
            border-radius: 8px;
            border: 1.5px solid #ddd;
            box-sizing: border-box;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
            color: #333;
        }

        input[type="text"]:focus,
        input[type="password"]:focus {
            border-color: #6A4C9C;
            outline: none;
            box-shadow: 0 0 10px rgba(106, 76, 156, 0.3);
        }

        input[type="submit"] {
            background-color: #6A4C9C;
            color: #fff;
            border: none;
            border-radius: 35px;
            padding: 14px 0;
            font-size: 1.1rem;
            font-weight: 700;
            width: 100%;
            cursor: pointer;
            box-shadow: 0 5px 15px rgba(106, 76, 156, 0.3);
            transition: background-color 0.3s ease, transform 0.3s ease;
            user-select: none;
        }

        input[type="submit"]:hover {
            background-color: #8659c0;
            transform: translateY(-2px);
            box-shadow: 0 8px 22px rgba(134, 89, 192, 0.5);
        }

        .error {
            color: #d32f2f;
            font-size: 0.9rem;
            margin-top: 18px;
            text-align: center;
            font-weight: 600;
            user-select: none;
        }

        .password-container {
            position: relative;
        }

        .toggle-password {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            background: transparent;
            border: none;
            padding: 0 8px;
            font-size: 0.9rem;
            color: #6A4C9C;
            font-weight: 600;
            user-select: none;
        }

        /* Responsive design */
        @media (max-width: 480px) {
            header {
                font-size: 1.75rem;
                padding: 20px 0;
            }

            .login-box {
                padding: 30px 25px;
                width: 90%;
            }

            .logo {
                width: 90px;
                margin-bottom: 18px;
            }

            h2 {
                font-size: 1.3rem;
                margin-bottom: 16px;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header>
        STUDENT VOTING SYSTEM
    </header>

    <div class="container" role="main" aria-label="Login Form">
        <!-- Logo Image -->
        <img src="picture/umtlogo.png" alt="University Logo" class="logo" />

        <!-- Login Box -->
        <div class="login-box">
            <h2>Login</h2>

            <p class="info-hint" aria-live="polite">
                <strong>New user?</strong> Enter your username only and leave the password field blank to set up your password.
            </p>

            <form action="LoginServlet" method="POST" novalidate>
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" required autocomplete="username" />
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="password-container">
                        <input type="password" id="password" name="password" style="padding-right: 60px;" autocomplete="current-password" />
                        <button type="button" class="toggle-password" onclick="togglePasswordVisibility()" aria-label="Toggle password visibility">Show</button>
                    </div>
                </div>

                <div class="form-group">
                    <input type="submit" value="Login" />
                </div>
            </form>

            <%-- Error messages --%>
            <%
                String error = request.getParameter("error");
                if ("Database error".equals(error)) {
            %>
            <div class="error" role="alert">
                There was an error while connecting to the database.
            </div>
            <% } else if ("Invalid credentials".equals(error)) { %>
            <div class="error" role="alert">
                Invalid username or password. Please try again.
            </div>
            <% } %>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        &copy; 2025 Student Voting System. All rights reserved.
    </footer>

    <script>
        function togglePasswordVisibility() {
            const passwordInput = document.getElementById('password');
            const toggleBtn = document.querySelector('.toggle-password');
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleBtn.textContent = 'Hide';
            } else {
                passwordInput.type = 'password';
                toggleBtn.textContent = 'Show';
            }
        }
    </script>
</body>
</html>
