<%-- 
    Document   : editElection
    Created on : 20 Apr 2025, 1:45:56 am
    Author     : efeys
--%>

<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.svs.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Election</title>
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

        form {
            display: flex;
            flex-direction: column;
        }

        label {
            font-size: 1.1em;
            margin-bottom: 8px;
        }

        input, textarea, select {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
            border: 1px solid #ccc;
            font-size: 1em;
            width: 100%;
        }

        input[type="submit"] {
            background-color: #6A4C9C;
            color: white;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #8e44ad;
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
        }

        .back-button:hover {
            background-color: #8e44ad;
        }

        .error {
            color: red;
            background-color: #f8d7da;
            padding: 10px;
            border-radius: 5px;
            margin-top: 20px;
        }

        .delete-button {
            background-color: red;
            color: white;
            padding: 12px 25px;
            border-radius: 25px;
            font-size: 1.1em;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .delete-button:hover {
            background-color: darkred;
        }

    </style>

    <script>
        function confirmDelete(electionID) {
            var confirmation = confirm("Are you sure you want to delete this election? This action cannot be undone.");
            if (confirmation) {
                window.location.href = "deleteElection.jsp?id=" + electionID;
            }
        }
    </script>

</head>
<body>

<header>
    <h1>Edit Election</h1>
    <form action="login.jsp" method="get" style="display:inline;">
        <button class="logout-button" type="submit">Logout</button>
    </form>
</header>

<div class="container">
    <h2>Update Election Details</h2>

    <%
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String electionID = request.getParameter("id");
        if (electionID != null && !electionID.isEmpty()) {
            try {
                conn = DBConnection.getConnection();
                String sql = "SELECT * FROM elections WHERE electionID = ?";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(electionID));
                rs = ps.executeQuery();

                if (rs.next()) {
                    String electionName = rs.getString("electionName");
                    java.sql.Date startDate = rs.getDate("startDate");
                    java.sql.Date endDate = rs.getDate("endDate");
                    String status = rs.getString("status");
                    String description = rs.getString("description");
    %>

    <form action="updateElection.jsp" method="post">
        <input type="hidden" name="electionID" value="<%= electionID %>">
        
        <label for="electionName">Election Name</label>
        <input type="text" id="electionName" name="electionName" value="<%= electionName %>" required>
        
        <label for="startDate">Start Date</label>
        <input type="date" id="startDate" name="startDate" value="<%= startDate != null ? startDate.toLocalDate().toString() : "" %>" required>
        
        <label for="endDate">End Date</label>
        <input type="date" id="endDate" name="endDate" value="<%= endDate != null ? endDate.toLocalDate().toString() : "" %>" required>
        
        <label>Election Status:</label><br/>
        <input type="text" value="<%= status %>" readonly /><br/><br/>
        
        <label for="description">Election Description</label>
        <textarea id="description" name="description" rows="4" required><%= description %></textarea>
        
        <input type="submit" value="Update Election">
    </form>

    <button onclick="confirmDelete('<%= electionID %>')" class="delete-button">
        Delete Election
    </button>

    <%
                } else {
                    out.println("<p class='error'>Election not found!</p>");
                }
            } catch (Exception e) {
                out.println("<p class='error'>Error retrieving election details: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) rs.close();
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
