<%-- 
    Document   : deleteUser
    Created on : 20 Jan 2025, 12:01:40 pm
    Author     : efeys
--%>

<%@ page import="com.svs.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete User</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f9f9f9; /* Light gray background */
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .container {
            background-color: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 400px;
            text-align: center;
        }

        h1 {
            color: #d32f2f; /* Red color for danger */
            margin-bottom: 30px;
        }

        p {
            font-size: 16px;
            color: #333;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group input[type="submit"] {
            background-color: #d32f2f; /* Red for delete */
            color: white;
            border: none;
            padding: 12px 20px;
            font-size: 18px;
            border-radius: 8px;
            cursor: pointer;
            width: 100%;
        }

        .form-group input[type="submit"]:hover {
            background-color: #c62828; /* Darker red for hover */
        }

        .form-group a {
            display: inline-block;
            margin-top: 10px;
            color: #1976d2; /* Blue color for cancel */
            text-decoration: none;
        }

        .form-group a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="container">
        <h1>Delete User</h1>

        <%
            String userId = request.getParameter("id");

            if (userId != null) {
        %>

        <form action="deleteUserServlet" method="post">
            <input type="hidden" name="id" value="<%= userId %>">
            <p>Are you sure you want to delete this user?</p>
            <div class="form-group">
                <input type="submit" value="Yes, Delete">
            </div>
            <div class="form-group">
                <a href="viewUsers.jsp">Cancel</a>
            </div>
        </form>

        <%
            }
        %>
    </div>

</body>
</html>
