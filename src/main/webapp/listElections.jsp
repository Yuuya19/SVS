<%-- 
    Document   : listElections
    Created on : 17 Apr 2025, 2:16:51 am
    Author     : efeys
--%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.svs.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Election List</title>
    <style>
        /* Reset */
        * {
            box-sizing: border-box;
        }
        body {
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            color: #333;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        header {
            background-color: #6A4C9C; /* Your purple */
            color: white;
            padding: 30px 20px;
            position: relative;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        header h1 {
            margin: 0;
            font-weight: 600;
            font-size: 2rem;
            letter-spacing: 1px;
        }

        .logout-button {
            position: absolute;
            top: 20px;
            right: 20px;
            background-color: white;
            color: #6A4C9C;
            border: none;
            padding: 10px 18px;
            border-radius: 25px;
            font-weight: 700;
            cursor: pointer;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .logout-button:hover {
            background-color: #5a3f87;
            color: white;
        }

        main.container {
            flex-grow: 1;
            max-width: 1000px;
            margin: 40px auto;
            padding: 30px 25px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(106, 76, 156, 0.15);
        }

        main.container h2 {
            margin-top: 0;
            margin-bottom: 25px;
            color: #6A4C9C;
            font-weight: 600;
            font-size: 1.8rem;
            text-align: center;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 1rem;
        }

        thead tr {
            background-color: #6A4C9C;
            color: white;
            text-align: center;
        }

        thead th {
            padding: 12px 15px;
            font-weight: 600;
            letter-spacing: 0.7px;
        }

        tbody tr {
            border-bottom: 1px solid #e1e4e8;
            transition: background-color 0.2s ease;
        }

        tbody tr:hover {
            background-color: #f0e9fc;
        }

        tbody td {
            padding: 12px 15px;
            text-align: center;
            vertical-align: middle;
            color: #444;
        }

        tbody td:first-child {
            font-weight: 600;
            color: #6A4C9C;
        }

        .action-link, .delete-button {
            font-size: 0.9rem;
            padding: 8px 18px;
            border-radius: 25px;
            cursor: pointer;
            border: none;
            user-select: none;
            transition: background-color 0.3s ease;
            display: inline-block;
            text-decoration: none;
            text-align: center;
        }

        .action-link {
            background-color: #6A4C9C;
            color: white;
            font-weight: 600;
            margin-right: 10px;
        }

        .action-link:hover {
            background-color: #7d5dbb;
        }

        .delete-button {
            background-color: #e74c3c;
            color: white;
            font-weight: 600;
        }

        .delete-button:hover {
            background-color: #c0392b;
        }

        .actions-container {
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .back-button {
            display: inline-block;
            margin-top: 35px;
            background-color: #6A4C9C;
            color: white;
            padding: 12px 30px;
            font-weight: 600;
            border-radius: 25px;
            text-decoration: none;
            transition: background-color 0.3s ease;
        }

        .back-button:hover {
            background-color: #7d5dbb;
        }

        footer {
            background-color: #6A4C9C;
            color: white;
            text-align: center;
            padding: 15px 20px;
            font-size: 0.9rem;
            user-select: none;
        }

        /* Responsive */
        @media (max-width: 700px) {
            main.container {
                margin: 20px 10px;
                padding: 20px 15px;
                overflow-x: auto;
            }

            table {
                min-width: 600px;
            }
        }
    </style>
</head>
<body>

<header>
    <h1>Election List</h1>
    <form action="login.jsp" method="get" style="display:inline;">
        <button class="logout-button" type="submit">Logout</button>
    </form>
</header>

<main class="container">
    <h2>All Registered Elections</h2>

    <%
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT electionID, electionName, startDate, endDate, status, description FROM elections";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
    %>

    <table>
        <thead>
            <tr>
                <th>Election ID</th>
                <th>Election Name</th>
                <th>Description</th>
                <th>Start Date</th>
                <th>End Date</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <%
                while (rs.next()) {
                    int electionID = rs.getInt("electionID");
            %>
            <tr>
                <td><%= electionID %></td>
                <td><%= rs.getString("electionName") %></td>
                <td><%= rs.getString("description") %></td>
                <td><%= new java.text.SimpleDateFormat("dd MMM yyyy").format(rs.getDate("startDate")) %></td>
                <td><%= new java.text.SimpleDateFormat("dd MMM yyyy").format(rs.getDate("endDate")) %></td>
                <td><%= rs.getString("status") %></td>
                <td>
                    <div class="actions-container">
                        <a href="editElection.jsp?id=<%= electionID %>" class="action-link">Edit</a>
                        <form action="DeleteElectionServlet" method="post" onsubmit="return confirmDelete();" style="margin:0;">
                            <input type="hidden" name="electionID" value="<%= electionID %>" />
                            <button type="submit" class="delete-button">Delete</button>
                        </form>
                    </div>
                </td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>

    <%
        } catch (Exception e) {
            out.println("<p style='color:red; text-align:center; margin-top:20px;'>Error loading elections: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    %>

    <a href="StaffDashboard.jsp" class="back-button">⬅ Back to Dashboard</a>
</main>

<footer>
    <p>&copy; 2025 Staff Portal. All rights reserved.</p>
</footer>

<script>
    function confirmDelete() {
        return confirm("Are you sure you want to delete this election?");
    }
</script>

</body>
</html>
