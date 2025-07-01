<%@ page import="com.svs.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Super Admin Dashboard</title>

    <style>
        /* Global Reset */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        /* Body Styling */
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f5f5f5;
            color: #333;
            line-height: 1.6;
            padding: 0;
            margin: 0;
        }

        /* Header Styles */
        header {
            background-color: #6A4C9C;
            color: white;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            position: relative;
        }

        header h1 {
            font-size: 2.8em;
            margin: 0;
        }

        header p {
            font-size: 1.2em;
            margin-top: 10px;
            opacity: 0.9;
        }

        /* Logout Button */
        .logout-button {
            position: absolute;
            top: 20px;
            right: 20px;
            background-color: white;
            color: #6A4C9C;
            padding: 10px 20px;
            font-size: 1em;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            transition: background-color 0.3s ease, color 0.3s ease;
            font-weight: bold;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
        }

        .logout-button:hover {
            background-color: #6A4C9C;
            color: white;
        }

        /* Main Content Container */
        .container {
            max-width: 900px;
            margin: 40px auto;
            padding: 30px;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        /* Section Headings */
        h2 {
            color: #6A4C9C;
            font-size: 2em;
            margin-bottom: 30px;
        }

        /* Buttons (Links styled as buttons) */
        a {
            display: inline-block;
            text-decoration: none;
            background-color: #6A4C9C;
            color: white;
            padding: 15px 30px;
            border-radius: 25px;
            font-size: 1.2em;
            margin: 15px;
            text-align: center;
            transition: background-color 0.3s, transform 0.3s;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        a:hover {
            background-color: #8e44ad;
            transform: translateY(-3px);
        }

        a:active {
            transform: translateY(0);
        }

        /* Footer Styling */
        footer {
            background-color: #6A4C9C;
            color: white;
            text-align: center;
            padding: 15px;
            position: fixed;
            bottom: 0;
            width: 100%;
            font-size: 0.9em;
            opacity: 0.8;
        }

    </style>
</head>
<body>

<header>
    <h1>Welcome, Super Admin</h1>
    <p>Manage Users and Elections</p>
    <!-- Logout Button -->
    <form action="login.jsp" method="get" style="display: inline;">
        <button type="submit" class="logout-button">Logout</button>
    </form>
</header>

<div class="container">
    <h2>User Management</h2>
    <a href="addUser.jsp">Add User</a>
    <a href="viewUsers.jsp">View Users</a>
</div>

<footer>
    <p>&copy; 2025 Super Admin Dashboard. All Rights Reserved.</p>
</footer>

</body>
</html>
