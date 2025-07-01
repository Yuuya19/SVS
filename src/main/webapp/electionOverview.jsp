<%-- 
    Document   : electionOverview
    Created on : 24 Apr 2025, 3:39:42 am
    Author     : efeys
--%>
<%@ page import="java.sql.*, java.time.*, com.svs.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Election Overview</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f3f9;
            color: #333;
        }

        /* Header */
        header {
            background-color: #6A4C9C;
            color: white;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        header h1 {
            margin: 0;
            font-size: 26px;
        }

        .btn-back {
            background-color: white;
            color: #6A4C9C;
            padding: 10px 18px;
            text-decoration: none;
            font-weight: bold;
            border-radius: 6px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }

        .btn-back:hover {
            background-color: #f2eaff;
            color: #5a3e85;
        }

        .section {
            width: 85%;
            max-width: 1000px;
            margin: 30px auto;
            background-color: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.07);
        }

        h2 {
            color: #6A4C9C;
            border-bottom: 2px solid #e1d9f2;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        th, td {
            text-align: left;
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
        }

        th {
            background-color: #6A4C9C;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f8f4fc;
        }

        .button {
            background-color: #6A4C9C;
            color: white;
            padding: 8px 16px;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        .button:hover {
            background-color: #5a3e85;
        }

        p {
            color: #555;
        }

        /* Footer */
        footer {
            background-color: #6A4C9C;
            color: white;
            text-align: center;
            padding: 15px;
            margin-top: 40px;
            font-size: 14px;
        }
    </style>
</head>
<body>

<header>
    <h1>Election Overview</h1>
    <a class="btn-back" href="StaffDashboard.jsp">← Back to Dashboard</a>
</header>

<div class="section">
    <h2>Ongoing Elections</h2>
    <%
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            String currentDate = LocalDate.now().toString();

            String ongoingQuery = "SELECT * FROM elections WHERE startDate <= ? AND endDate >= ?";
            stmt = conn.prepareStatement(ongoingQuery);
            stmt.setString(1, currentDate);
            stmt.setString(2, currentDate);
            rs = stmt.executeQuery();

            if (!rs.isBeforeFirst()) {
                out.println("<p>No ongoing elections at the moment.</p>");
            } else {
    %>
    <table>
        <tr>
            <th>Election Name</th>
            <th>Start Date</th>
            <th>End Date</th>
        </tr>
        <%
            while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("electionName") %></td>
            <td><%= rs.getString("startDate") %></td>
            <td><%= rs.getString("endDate") %></td>
        </tr>
        <%
            }
        %>
    </table>
    <%
            }
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
        }
    %>
</div>

<div class="section">
    <h2>Ended Elections</h2>
    <%
        stmt = null;
        rs = null;
        try {
            String endedQuery = "SELECT * FROM elections WHERE endDate < ?";
            stmt = conn.prepareStatement(endedQuery);
            stmt.setString(1, LocalDate.now().toString());
            rs = stmt.executeQuery();

            if (!rs.isBeforeFirst()) {
                out.println("<p>No elections have ended yet.</p>");
            } else {
    %>
    <table>
        <tr>
            <th>Election Name</th>
            <th>Start Date</th>
            <th>End Date</th>
            <th>Action</th>
        </tr>
        <%
            while (rs.next()) {
                int electionID = rs.getInt("electionID");
        %>
        <tr>
            <td><%= rs.getString("electionName") %></td>
            <td><%= rs.getString("startDate") %></td>
            <td><%= rs.getString("endDate") %></td>
            <td><a class="button" href="electionResults.jsp?electionID=<%= electionID %>">View Result</a></td>
        </tr>
        <%
            }
        %>
    </table>
    <%
            }
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    %>
</div>

<footer>
    &copy; 2025 Student Voting System | University of Malaysia Terengganu | All Rights Reserved
</footer>

</body>
</html>
