<%-- 
    Document   : studentDashboard
    Created on : 20 Jan 2025, 10:38:49 am
    Author     : efeys
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<%@ page session="true" %>
<%@ page import="com.svs.util.DBConnection" %>
<%
    Integer id = (Integer) session.getAttribute("id");
    String role = (String) session.getAttribute("role");
    if (id == null || role == null || !role.equals("Student")) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Map<String, Object>> elections = new ArrayList<>();
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        String query = "SELECT * FROM elections WHERE status = 'Approved'";
        ps = conn.prepareStatement(query);
        rs = ps.executeQuery();
        java.util.Date currentDate = new java.util.Date();

        while (rs.next()) {
            int electionID = rs.getInt("electionID");
            String name = rs.getString("electionName");
            String description = rs.getString("description");
            java.sql.Date startDate = rs.getDate("startDate");
            java.sql.Date endDate = rs.getDate("endDate");

            PreparedStatement voteCheckStmt = conn.prepareStatement(
                "SELECT * FROM votes WHERE electionID = ? AND userID = ?"
            );
            voteCheckStmt.setInt(1, electionID);
            voteCheckStmt.setInt(2, id);
            ResultSet voteRs = voteCheckStmt.executeQuery();
            boolean alreadyVoted = voteRs.next();
            voteRs.close();
            voteCheckStmt.close();

            Calendar cal = Calendar.getInstance();
            cal.setTime(endDate);
            cal.add(Calendar.DATE, 2);
            java.util.Date endPlusTwoDays = cal.getTime();

            if (currentDate.before(startDate)) continue;
            if (currentDate.after(endPlusTwoDays)) continue;

            boolean isOngoing = !currentDate.after(endDate);
            boolean isEnded = currentDate.after(endDate) && currentDate.before(endPlusTwoDays);

            Map<String, Object> election = new HashMap<>();
            election.put("electionID", electionID);
            election.put("name", name);
            election.put("description", description);
            election.put("isOngoing", isOngoing);
            election.put("isEnded", isEnded);
            election.put("alreadyVoted", alreadyVoted);
            elections.add(election);
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error loading data: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Student Dashboard - Elections</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
        /* Reset & base styles */
        * {
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            background: #f8f9fa;
            color: #333;
        }
        header {
            background-color: #6A4C9C;
            color: #fff;
            padding: 20px;
            text-align: center;
            position: relative;
        }
        header h1 {
            margin: 0;
            font-weight: 600;
            font-size: 1.8rem;
        }
        header p {
            margin: 5px 0 0 0;
            font-size: 1rem;
            font-weight: 400;
        }
        .logout-button, .profile-button {
            position: absolute;
            top: 20px;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            font-weight: 600;
            cursor: pointer;
            color: #fff;
            transition: background-color 0.3s ease;
        }
        .logout-button {
            right: 20px;
            background-color: #e74c3c;
        }
        .logout-button:hover {
            background-color: #c0392b;
        }
        .profile-button {
            left: 20px;
            background-color: #27ae60;
        }
        .profile-button:hover {
            background-color: #1e8449;
        }

        #clock {
            margin: 20px auto;
            width: 260px;
            background: #e0d7f1;
            border-radius: 10px;
            text-align: center;
            font-size: 28px;
            font-weight: bold;
            color: #6A4C9C;
            letter-spacing: 2px;
            padding: 10px 0;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        .container {
            max-width: 1100px;
            background: #fff;
            margin: 30px auto;
            border-radius: 10px;
            padding: 30px 40px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        h2 {
            color: #6A4C9C;
            font-size: 1.8rem;
            margin-bottom: 25px;
        }
        .election-list {
            display: flex;
            gap: 20px;
            overflow-x: auto;
            padding-bottom: 10px;
            scrollbar-width: thin;
            scrollbar-color: #6A4C9C #e0d7f1;
        }
        /* Webkit scrollbar */
        .election-list::-webkit-scrollbar {
            height: 8px;
        }
        .election-list::-webkit-scrollbar-track {
            background: #e0d7f1;
            border-radius: 8px;
        }
        .election-list::-webkit-scrollbar-thumb {
            background-color: #6A4C9C;
            border-radius: 8px;
        }

        .election-item {
            min-width: 280px;
            background: #fff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
            flex-shrink: 0;
        }
        .election-item:hover {
            transform: translateY(-7px);
        }
        .election-item h3 {
            margin-top: 0;
            margin-bottom: 15px;
            font-size: 1.3rem;
            color: #4a2a6a;
        }
        .election-item p {
            color: #555;
            font-size: 0.95rem;
            min-height: 80px;
        }
        .election-item a {
            display: inline-block;
            margin-top: 15px;
            padding: 12px 25px;
            background-color: #6A4C9C;
            color: #fff;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 600;
            transition: background-color 0.3s ease;
        }
        .election-item a:hover {
            background-color: #4e3475;
        }
        .election-item a[style*="grey"] {
            background-color: grey !important;
            cursor: default;
            pointer-events: none;
        }

        .reminder-banner {
            margin-top: 40px;
            background: #f1f1f1;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            text-align: center;
        }
        .reminder-banner img {
            max-width: 100%;
            height: auto;
            border-radius: 10px;
        }
        .reminder-banner p {
            font-size: 1.1rem;
            margin-top: 20px;
            color: #333;
            font-weight: 600;
        }

        footer {
            background-color: #6A4C9C;
            text-align: center;
            padding: 15px 10px;
            color: white;
            font-size: 0.9rem;
            margin-top: 50px;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .container {
                padding: 20px 25px;
                margin: 20px 15px;
            }
            .election-list {
                gap: 15px;
            }
            .election-item {
                min-width: 240px;
            }
        }
        @media (max-width: 480px) {
            header h1 {
                font-size: 1.4rem;
            }
            header p {
                font-size: 0.85rem;
            }
            #clock {
                width: 100%;
                font-size: 24px;
            }
            .election-item {
                min-width: 200px;
            }
            .logout-button, .profile-button {
                padding: 8px 14px;
                font-size: 0.85rem;
            }
        }
    </style>
</head>
<body>

<header>
    <h1>Welcome, Student</h1>
    <p>Here you can view available and ongoing elections.</p>
    <form action="logout.jsp" method="post" style="display:inline;">
        <button type="submit" class="logout-button">Logout</button>
    </form>
    <form action="studentProfile.jsp" method="get" style="display:inline;">
        <button type="submit" class="profile-button">View My Profile</button>
    </form>
</header>

<div id="clock">00:00:00</div>

<div class="container">
    <h2>Available Elections</h2>

    <div class="election-list">
        <%
            for (Map<String, Object> election : elections) {
                int electionID = (Integer) election.get("electionID");
                String name = (String) election.get("name");
                String description = (String) election.get("description");
                boolean isOngoing = (Boolean) election.get("isOngoing");
                boolean isEnded = (Boolean) election.get("isEnded");
                boolean alreadyVoted = (Boolean) election.get("alreadyVoted");
        %>
        <div class="election-item">
            <h3><%= name %></h3>
            <p><%= description %></p>
            <%
                if (isEnded) {
            %>
                <a style="background-color: grey; pointer-events: none;">Election Ended</a>
            <%
                } else if (alreadyVoted) {
            %>
                <a style="background-color: grey; pointer-events: none;">Voted</a>
            <%
                } else {
            %>
                <a href="electionDetails.jsp?electionId=<%= electionID %>">View Details</a>
            <%
                }
            %>
        </div>
        <%
            }
            if (elections.isEmpty()) {
        %>
        <p>No available or recent elections at this time. Please check back soon.</p>
        <%
            }
        %>
    </div>

    <div class="reminder-banner">
        <img src="picture/your_vote.jpg" alt="University Reminder" />
        <p>Remember, integrity matters! Vote responsibly and follow the rules.</p>
    </div>
</div>

<footer>
    <p>&copy; 2025 Student Dashboard. All Rights Reserved.</p>
</footer>

<script>
    function updateClock() {
        const now = new Date();
        const hours = now.getHours().toString().padStart(2, '0');
        const minutes = now.getMinutes().toString().padStart(2, '0');
        const seconds = now.getSeconds().toString().padStart(2, '0');
        const timeString = hours + ':' + minutes + ':' + seconds;
        document.getElementById('clock').textContent = timeString;
    }

    setInterval(updateClock, 1000);
    updateClock();
</script>

</body>
</html>
