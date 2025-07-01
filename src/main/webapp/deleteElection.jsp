<%-- 
    Document   : deleteElection
    Created on : 20 Apr 2025, 2:07:38 am
    Author     : efeys
--%>
<%@ page import="java.sql.*, com.svs.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Delete Election</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            color: #333;
        }

        header {
            background-color: #6A4C9C;
            color: white;
            padding: 40px 20px;
            text-align: center;
            position: relative;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        header h1 {
            margin: 0;
            font-size: 2.5em;
        }

        .logout-button {
            position: absolute;
            top: 20px;
            right: 20px;
            background-color: white;
            color: #6A4C9C;
            padding: 10px 20px;
            border: none;
            border-radius: 25px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .logout-button:hover {
            background-color: #6A4C9C;
            color: white;
        }

        .container {
            max-width: 700px;
            margin: 40px auto;
            padding: 30px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        h2 {
            color: #6A4C9C;
            font-size: 2em;
            margin-bottom: 20px;
            text-align: center;
        }

        .message {
            font-size: 1.2em;
            color: green;
            text-align: center;
            margin-bottom: 20px;
        }

        .error {
            font-size: 1.2em;
            color: red;
            text-align: center;
            margin-bottom: 20px;
        }

        .back-button {
            margin-top: 20px;
            display: inline-block;
            background-color: #6A4C9C;
            color: white;
            padding: 12px 25px;
            border-radius: 25px;
            text-decoration: none;
            font-size: 1.1em;
            text-align: center;
        }

        .back-button:hover {
            background-color: #8e44ad;
        }

    </style>
</head>
<body>

<header>
    <h1>Delete Election</h1>
    <form action="login.jsp" method="get" style="display:inline;">
        <button class="logout-button" type="submit">Logout</button>
    </form>
</header>

<div class="container">
    <%
        Connection conn = null;
        PreparedStatement ps = null;
        String electionID = request.getParameter("id");
        if (electionID != null && !electionID.isEmpty()) {
            try {
                conn = DBConnection.getConnection();

                // Delete election from the database
                String sql = "DELETE FROM elections WHERE electionID = ?";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(electionID));
                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    out.println("<p class='message'>Election successfully deleted!</p>");
                } else {
                    out.println("<p class='error'>Error deleting election. It may have been already deleted.</p>");
                }

            } catch (Exception e) {
                out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
            } finally {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            }
        } else {
            out.println("<p class='error'>Invalid Election ID!</p>");
        }
    %>

    <a href="listElections.jsp" class="back-button">⬅ Back to Election List</a>
</div>

</body>
</html>
