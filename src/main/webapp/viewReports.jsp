<%-- 
    Document   : viewReports
    Created on : 20 Apr 2025, 2:33:03 am
    Author     : efeys
--%>

<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.svs.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Election Reports</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f0f0f0;
            margin: 0;
        }
        header, footer {
            background-color: #6A4C9C;
            color: white;
            text-align: center;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 30px auto;
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        h2 {
            color: #6A4C9C;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
        }
        table, th, td {
            border: 1px solid #ccc;
        }
        th {
            background: #6A4C9C;
            color: white;
            padding: 10px;
            cursor: pointer;
        }
        td {
            padding: 10px;
            text-align: center;
        }
        .badge {
            padding: 5px 10px;
            border-radius: 20px;
            color: white;
            font-size: 0.9em;
        }
        .approved { background-color: #27ae60; }
        .rejected { background-color: #c0392b; }
        .pending  { background-color: #f39c12; }
        .search-box {
            margin-top: 10px;
            text-align: right;
        }
        .search-box input {
            padding: 8px 14px;
            border: 1px solid #ccc;
            border-radius: 25px;
            width: 250px;
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
    </style>
    <script>
        function searchElections() {
            const input = document.getElementById("searchInput").value.toLowerCase();
            const rows = document.querySelectorAll("#electionTable tbody tr");

            rows.forEach(row => {
                const name = row.querySelector("td").textContent.toLowerCase();
                row.style.display = name.includes(input) ? "" : "none";
            });
        }

        function sortTable(n) {
            const table = document.getElementById("electionTable");
            let switching = true, dir = "asc", switchcount = 0;

            while (switching) {
                switching = false;
                let rows = table.rows;

                for (let i = 1; i < rows.length - 1; i++) {
                    let shouldSwitch = false;
                    let x = rows[i].getElementsByTagName("TD")[n];
                    let y = rows[i + 1].getElementsByTagName("TD")[n];

                    let xContent = x.textContent || x.innerText;
                    let yContent = y.textContent || y.innerText;

                    if (n === 1 || n === 2) { // Dates
                        xContent = new Date(xContent);
                        yContent = new Date(yContent);
                    }

                    if ((dir === "asc" && xContent > yContent) || (dir === "desc" && xContent < yContent)) {
                        shouldSwitch = true;
                        break;
                    }
                }

                if (shouldSwitch) {
                    rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
                    switching = true;
                    switchcount++;
                } else {
                    if (switchcount === 0 && dir === "asc") {
                        dir = "desc";
                        switching = true;
                    }
                }
            }
        }
    </script>
</head>
<body>
<header>
    <h1>Election Reports</h1>
    <p>Detailed breakdown of past elections</p>
</header>

<div class="container">
    <div class="search-box">
        <input type="text" id="searchInput" onkeyup="searchElections()" placeholder="Search elections...">
    </div>

    <table id="electionTable">
        <thead>
            <tr>
                <th onclick="sortTable(0)">Election Name</th>
                <th onclick="sortTable(1)">Start Date</th>
                <th onclick="sortTable(2)">End Date</th>
                <th onclick="sortTable(3)">Status</th>
                <th>Total Voters</th>
                <th>Participation Rate (%)</th>
            </tr>
        </thead>
        <tbody>
        <%
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                conn = DBConnection.getConnection();
                String query = "SELECT e.electionName, e.startDate, e.endDate, e.status, " +
                        "(SELECT COUNT(*) FROM votes v WHERE v.electionID = e.electionID) AS totalVotes, " +
                        "(SELECT COUNT(*) FROM users WHERE role = 'Student') AS totalStudents " +
                        "FROM elections e ORDER BY e.startDate DESC";

                ps = conn.prepareStatement(query);
                rs = ps.executeQuery();

                while (rs.next()) {
                    String name = rs.getString("electionName");
                    String startDate = rs.getString("startDate");
                    String endDate = rs.getString("endDate");
                    String status = rs.getString("status");
                    int totalVotes = rs.getInt("totalVotes");
                    int totalStudents = rs.getInt("totalStudents");

                    int participationRate = totalStudents > 0 ? (totalVotes * 100 / totalStudents) : 0;
        %>
        <tr>
            <td><%= name %></td>
            <td><%= startDate %></td>
            <td><%= endDate %></td>
            <td>
                <span class="badge 
                    <%= status.equals("Approved") ? "approved" : 
                         status.equals("Rejected") ? "rejected" : "pending" %>">
                    <%= status %>
                </span>
            </td>
            <td><%= totalVotes %></td>
            <td><%= participationRate %></td>
        </tr>
        <%
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='6' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            }
        %>
        <a href="HEPADashboard.jsp" class="back-button">← Back to Dashboard</a>
        </tbody>
    </table>
</div>

<footer>
    <p>&copy; 2025 HEPA Dashboard | All rights reserved</p>
</footer>
</body>
</html>
