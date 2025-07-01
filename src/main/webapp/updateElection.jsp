<%-- 
    Document   : updateElection
    Created on : 20 Apr 2025, 3:31:18 am
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
    <title>Update Election</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            text-align: center;
            padding: 50px;
        }

        .message {
            display: inline-block;
            padding: 20px 30px;
            border-radius: 8px;
            font-size: 1.2em;
            font-weight: bold;
        }

        .success {
            background-color: #d4edda;
            color: #155724;
        }

        .error {
            background-color: #f8d7da;
            color: #721c24;
        }

        a {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #6A4C9C;
            font-weight: bold;
        }

        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<%
    Connection conn = null;
    PreparedStatement ps = null;

    try {
        String electionID = request.getParameter("electionID");
        String electionName = request.getParameter("electionName");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String description = request.getParameter("description");

        if (electionID != null && electionName != null && startDate != null && endDate != null && description != null) {
            conn = DBConnection.getConnection();

            String sql = "UPDATE elections SET electionName = ?, startDate = ?, endDate = ?, description = ? WHERE electionID = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, electionName);
            ps.setDate(2, java.sql.Date.valueOf(startDate));
            ps.setDate(3, java.sql.Date.valueOf(endDate));
            ps.setString(4, description);
            ps.setInt(5, Integer.parseInt(electionID));

            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated > 0) {
%>
                <div class="message success">
                    ✅ Election updated successfully!
                </div>
<%
            } else {
%>
                <div class="message error">
                    ⚠️ Failed to update election. Please try again.
                </div>
<%
            }
        } else {
%>
            <div class="message error">
                ❌ Missing or invalid form data!
            </div>
<%
        }
    } catch (Exception e) {
%>
        <div class="message error">
            ⚠️ Error: <%= e.getMessage() %>
        </div>
<%
    } finally {
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>

<br>
<a href="listElections.jsp">⬅ Back to Election List</a>

</body>
</html>
