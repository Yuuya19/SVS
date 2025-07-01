<%-- 
    Document   : editUser
    Created on : 20 Jan 2025, 12:22:53 pm
    Author     : efeys
--%>

<%@ page import="com.svs.util.DBConnection" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    String userId = request.getParameter("id");
    Connection connection = DBConnection.getConnection();
    PreparedStatement ps = connection.prepareStatement("SELECT * FROM users WHERE id = ?");
    ps.setInt(1, Integer.parseInt(userId));
    ResultSet rs = ps.executeQuery();
    String username = "";
    String email = "";
    String role = "";
    if (rs.next()) {
        username = rs.getString("username");
        email = rs.getString("email");
        role = rs.getString("role");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit User</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f3f4f6;
            color: #333;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 60%;
            margin: 50px auto;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        h1 {
            color: #6a4c9c;
            text-align: center;
        }

        label {
            font-size: 16px;
            margin: 10px 0 5px;
            display: block;
        }

        input[type="text"],
        input[type="email"],
        select {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        input[type="submit"] {
            background-color: #6a4c9c;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
        }

        input[type="submit"]:hover {
            background-color: #5a3d8d;
        }

        .form-footer {
            margin-top: 20px;
            text-align: center;
        }

        .form-footer a {
            color: #6a4c9c;
            text-decoration: none;
            font-size: 16px;
        }

        .form-footer a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Edit User</h1>

    <form action="editUserServlet" method="post">
        <input type="hidden" name="userId" value="<%= userId %>" />

        <label for="username">Username:</label>
        <input type="text" id="username" name="username" value="<%= username %>" required />

        <label for="email">Email:</label>
        <input type="email" id="email" name="email" value="<%= email %>" required />

        <label for="role">Role:</label>
        <select id="role" name="role">
            <option value="Staff" <%= role.equals("Staff") ? "selected" : "" %>>Staff</option>
            <option value="HEPA" <%= role.equals("HEPA") ? "selected" : "" %>>HEPA</option>
        </select>

        <input type="submit" value="Update User" />
    </form>

    <div class="form-footer">
        <a href="viewUsers.jsp">Back to Users</a>
    </div>
</div>

</body>
</html>
