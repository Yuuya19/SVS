<%-- 
    Document   : viewUsers
    Created on : 20 Jan 2025, 12:00:41 pm
    Author     : efeys
--%>

<%@ page import="com.svs.util.DBConnection" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Users</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f3f4f6;
            margin: 0;
            padding: 0;
        }

        header {
            background-color: #6a4c9c;
            color: white;
            padding: 20px;
            text-align: center;
        }

        h1 {
            margin: 0;
        }

        h2 {
            text-align: center;
            margin-top: 40px;
            color: #6a4c9c;
        }

        table {
            width: 85%;
            margin: 20px auto 40px auto;
            border-collapse: collapse;
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 0 10px rgba(0,0,0,0.05);
        }

        th, td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #6a4c9c;
            color: white;
        }

        tr:hover {
            background-color: #f1e6f7;
        }

        a {
            color: #6a4c9c;
            text-decoration: none;
            font-weight: bold;
        }

        a:hover {
            text-decoration: underline;
        }

        .back-link {
            text-align: center;
            margin: 30px 0;
        }

        .back-link a {
            color: #6a4c9c;
            font-size: 16px;
        }
    </style>
</head>
<body>

<header>
    <h1>User Management</h1>
</header>

<div class="back-link">
    <a href="StaffDashboard.jsp">&larr; Back to Dashboard</a>
</div>

<%
    Connection connection = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        connection = DBConnection.getConnection();
        String[] roles = { "Student", "Staff", "HEPA" };

        for (String role : roles) {
%>
        <h2><%= role %>s</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <%
                ps = connection.prepareStatement("SELECT * FROM users WHERE role = ?");
                ps.setString(1, role);
                rs = ps.executeQuery();
                boolean hasData = false;

                while (rs.next()) {
                    hasData = true;
                    String id = rs.getString("id");
                    String username = rs.getString("username");
                    String email = rs.getString("email");
            %>
                <tr>
                    <td><%= id %></td>
                    <td><%= username %></td>
                    <td><%= email %></td>
                    <td><%= role %></td>
                    <td>
                        <a href="editUser.jsp?id=<%= id %>">Edit</a> |
                        <a href="deleteUser.jsp?id=<%= id %>">Delete</a>
                    </td>
                </tr>
            <%
                }

                if (!hasData) {
            %>
                <tr>
                    <td colspan="5">No <%= role %> users found.</td>
                </tr>
            <%
                }

                rs.close();
                ps.close();
            %>
            </tbody>
        </table>
<%
        }
    } catch (Exception e) {
%>
        <p style="text-align: center; color: red;">Error loading users: <%= e.getMessage() %></p>
<%
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
        if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
    }
%>

</body>
</html>
