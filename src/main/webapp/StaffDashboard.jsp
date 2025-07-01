<%-- 
    Document   : StaffDashboard
    Created on : 17 Apr 2025, 1:06:12 am
    Author     : efeys
--%>
<%@ page import="com.svs.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Dashboard</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f7f6;
            color: #333;
            margin: 0;
            padding: 0;
        }

        header {
            background-color: #6A4C9C;
            color: white;
            padding: 30px 20px;
            text-align: center;
            position: relative;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        header h1 {
            font-size: 2.5em;
            margin: 0;
        }

        header p {
            font-size: 1.1em;
            margin-top: 10px;
        }

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
        }

        .logout-button:hover {
            background-color: #6A4C9C;
            color: white;
        }

        .container {
            max-width: 900px;
            margin: 40px auto;
            padding: 30px;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        h2 {
            color: #6A4C9C;
            font-size: 2em;
            margin-bottom: 20px;
        }

        a {
            display: inline-block;
            text-decoration: none;
            background-color: #6A4C9C;
            color: white;
            padding: 12px 25px;
            border-radius: 30px;
            font-size: 1.2em;
            margin: 15px 10px;
            transition: background-color 0.3s, transform 0.3s;
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);
        }

        a:hover {
            background-color: #8e44ad;
            transform: translateY(-3px);
        }

        a:active {
            transform: translateY(0);
        }

        footer {
            background-color: #6A4C9C;
            color: white;
            text-align: center;
            padding: 15px;
            position: fixed;
            bottom: 0;
            width: 100%;
            font-size: 0.9em;
        }
    </style>
</head>
<body>

<header>
    <h1>Welcome, Staff</h1>
    <p>Manage Elections and User Accounts</p>
    <form action="login.jsp" method="get" style="display: inline;">
        <button type="submit" class="logout-button">Logout</button>
    </form>
</header>

<div class="container">
    <!-- Election Management Section -->
    <h2>Election Management</h2>
    <a href="createElection.jsp">Create New Election</a>
    <a href="listElections.jsp">Edit Existing Election</a>
    <a href="electionOverview.jsp">View Election Overview</a>


    <!-- User Management Section -->
    <h2>User Management</h2>
    <a href="addUser.jsp">Add User</a>
    <a href="viewUsers.jsp">View Users</a>
</div>

<footer>
    <p>&copy; 2025 Staff Dashboard. All Rights Reserved.</p>
</footer>

</body>
</html>
