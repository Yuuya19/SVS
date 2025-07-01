<%-- 
    Document   : HEPADashboard
    Created on : 20 Jan 2025, 1:29:32 pm
    Author     : efeys
--%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="com.svs.util.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>HEPA Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f4; }
        header, footer { background: #6A4C9C; color: #fff; text-align: center; padding: 20px; }
        .logout-btn { position: absolute; right: 20px; top: 20px; padding: 10px 20px; background: #fff; color: #333; border-radius: 25px; text-decoration: none; }
        .container { max-width: 1000px; margin: auto; background: #fff; padding: 30px; border-radius: 10px; margin-top: 30px; }
        h2 { color: #6A4C9C; margin-bottom: 20px; }
        .election-approval {
            display: flex;
            flex-wrap: nowrap;
            gap: 20px;
            overflow-x: auto;
            padding-bottom: 10px;
        }
        .election-item {
            background: #eee;
            padding: 20px;
            border-radius: 8px;
            width: 300px;
            flex: 0 0 auto;
        }
        .election-item h3 {
            margin-bottom: 10px;
            color: #333;
        }
        .election-item p {
            color: #555;
            margin: 5px 0 15px 0;
        }

        .action-btn {
            padding: 10px 20px;
            margin: 5px 5px 0 0;
            border: none;
            border-radius: 30px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.2s ease-in-out;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .approve-btn {
            background-color: #2ecc71;
            color: white;
        }

        .approve-btn:hover {
            background-color: #27ae60;
            transform: translateY(-2px);
        }

        .reject-btn {
            background-color: #e74c3c;
            color: white;
        }

        .reject-btn:hover {
            background-color: #c0392b;
            transform: translateY(-2px);
        }

        .voting-rate-section { margin-top: 40px; }
        .poll-graph {
            display: flex;
            justify-content: space-around;
            align-items: flex-end;
            height: 300px;
            border-left: 2px solid #333;
            border-bottom: 2px solid #333;
            padding-left: 20px;
        }

        .poll-bar {
            width: 60px;
            background-color: #6A4C9C;
            text-align: center;
            color: white;
            margin-top: auto;
            border-radius: 5px 5px 0 0;
            transition: transform 0.3s ease;
        }

        .poll-bar:hover {
            transform: scale(1.1);
        }

        .poll-bar span {
            display: block;
            padding: 10px 0;
        }

        .poll-year {
            margin-top: 10px;
            text-align: center;
            font-size: 1.1em;
            color: #333;
        }
        
        .view-report {
    text-align: center;
}

.report-card {
    background-color: #f9f9f9;
    padding: 25px;
    border-radius: 10px;
    border: 1px solid #ccc;
    display: inline-block;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}

.view-report-btn {
    display: inline-block;
    margin-top: 15px;
    background: #6A4C9C;
    color: white;
    text-decoration: none;
    padding: 10px 20px;
    border-radius: 25px;
    transition: background 0.3s ease;
}

.view-report-btn:hover {
    background: #4e3475;
}

    </style>
</head>
<body>

<header>
    <h1>Welcome, HEPA</h1>
    <p>Manage elections, view reports, and track voting rates.</p>
    <a href="LogoutServlet" class="logout-btn">Logout</a>
</header>

<div class="container">
    <div class="section">
        <h2>Pending Election Approvals</h2>
        <div class="election-approval">
            <%
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                try {
                    conn = DBConnection.getConnection();
                    String sql = "SELECT * FROM elections WHERE status = 'Pending'";
                    ps = conn.prepareStatement(sql);
                    rs = ps.executeQuery();
                    boolean hasData = false;
                    while (rs.next()) {
                        hasData = true;
            %>
            <div class="election-item">
                <h3><%= rs.getString("electionName") %></h3>
                <p><strong>Description:</strong> <%= rs.getString("description") != null ? rs.getString("description") : "No description provided." %></p>
                <form action="ApproveElectionServlet" method="post" onsubmit="return confirmApprove();">
                    <input type="hidden" name="electionID" value="<%= rs.getInt("electionID") %>" />
                    <button type="submit" class="action-btn approve-btn">✅ Approve</button>
                </form>
                <form action="RejectElectionServlet" method="post" onsubmit="return confirmReject();">
                    <input type="hidden" name="electionID" value="<%= rs.getInt("electionID") %>" />
                    <button type="submit" class="action-btn reject-btn">❌ Reject</button>
                </form>
            </div>
            <%
                    }
                    if (!hasData) {
            %>
            <p>No pending elections at the moment.</p>
            <%
                    }
                } catch (Exception e) {
                    out.println("<p style='color:red;'>Error loading elections: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                }
            %>
        </div>
    </div>

    <!-- Voting Chart Section -->
    <div class="voting-rate-section">
        <h2>Voting Rate</h2>
        <div class="poll-graph">
            <%
                List<Integer> years = new ArrayList<>();
                List<Integer> votingRates = new ArrayList<>();
                try {
                    conn = DBConnection.getConnection();
                    String sql = "SELECT YEAR(voteDate) AS year, COUNT(voteID) * 100 / (SELECT COUNT(*) FROM users) AS votingRate FROM votes GROUP BY YEAR(voteDate) ORDER BY year DESC";
                    ps = conn.prepareStatement(sql);
                    rs = ps.executeQuery();
                    while (rs.next()) {
                        years.add(rs.getInt("year"));
                        votingRates.add(rs.getInt("votingRate"));
                    }
                } catch (Exception e) {
                    out.println("<p style='color:red;'>Error loading voting rates: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                }
                for (int i = 0; i < years.size(); i++) {
                    int votingRate = votingRates.get(i);
            %>
            <div class="poll-bar" style="height:<%= votingRate %>%; ">
                <span><%= votingRate %>%</span>
                <div class="poll-year"><%= years.get(i) %></div>
            </div>
            <%
                }
            %>
        </div>
    </div>

    <!-- View Reports Section -->
<div class="view-report" style="margin-top: 40px;">
    <h2>View Reports</h2>
    <div class="report-card">
        <p>You can view detailed reports including approved elections, voting statistics, and more.</p>
        <a href="viewReports.jsp" class="view-report-btn">📊 View Reports</a>
    </div>
</div>

<footer>
    <p>&copy; 2025 HEPA Dashboard. All Rights Reserved.</p>
</footer>

<!-- Confirmation Dialogs -->
<script>
    function confirmApprove() {
        return confirm("Are you sure you want to APPROVE this election?");
    }
    function confirmReject() {
        return confirm("Are you sure you want to REJECT this election?");
    }
</script>

</body>
</html>
