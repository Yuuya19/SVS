<%-- 
    Document   : electionResults
    Created on : 24 Apr 2025, 3:25:47 am
    Author     : efeys
--%>
<%@ page import="java.sql.*, java.util.*, java.text.DecimalFormat" %>
<%@ page import="com.svs.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String electionId = request.getParameter("electionID");
    String electionName = "Election Results";
    int totalVotes = 0;
    int maxVotes = 0;

    List<Map<String, Object>> candidates = new ArrayList<>();

    if (electionId != null && !electionId.isEmpty()) {
        try (Connection conn = DBConnection.getConnection()) {
            // Get election name
            String electionQuery = "SELECT electionName FROM elections WHERE electionID = ?";
            try (PreparedStatement ps = conn.prepareStatement(electionQuery)) {
                ps.setInt(1, Integer.parseInt(electionId));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        electionName = rs.getString("electionName");
                    }
                }
            }

            // Get candidates and vote counts
            String query = "SELECT c.candidateID, c.candidateName, c.party, c.photo, COUNT(v.voteChoice) AS voteCount " +
                           "FROM candidates c " +
                           "LEFT JOIN votes v ON c.candidateID = v.voteChoice " +
                           "WHERE c.electionID = ? " +
                           "GROUP BY c.candidateID";
            try (PreparedStatement ps = conn.prepareStatement(query, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY)) {
                ps.setInt(1, Integer.parseInt(electionId));
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        int voteCount = rs.getInt("voteCount");
                        totalVotes += voteCount;
                        if (voteCount > maxVotes) maxVotes = voteCount;

                        Map<String, Object> candidate = new HashMap<>();
                        candidate.put("name", rs.getString("candidateName"));
                        candidate.put("party", rs.getString("party"));
                        candidate.put("photo", rs.getString("photo"));
                        candidate.put("votes", voteCount);
                        candidates.add(candidate);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><%= electionName %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        html, body {
            height: 100%;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f3f9;
            color: #333;
            display: flex;
            flex-direction: column;
            min-height: 100vh; /* Use viewport height */
        }

        /* Header (keep your existing header styles) */
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

        /* Updated card styles to match the second JSP */
        .candidates-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 30px;
            padding: 20px;
        }

        .candidate-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
            text-align: center;
            transition: transform 0.3s ease;
        }

        .candidate-card:hover {
            transform: translateY(-5px);
        }

        .candidate-card img {
            width: 100%;
            height: 300px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 15px;
        }

        .candidate-card h3 {
            font-size: 1.4rem;
            margin-bottom: 10px;
            color: #333;
        }

        .candidate-card p {
            font-size: 0.95rem;
            color: #555;
            line-height: 1.5;
        }

        /* Keep your existing winner and progress bar styles */
        .winner {
            border: 3px solid gold;
            box-shadow: 0 0 10px rgba(255,215,0,0.6);
        }

        .progress-bar {
            background-color: #4A3C7D;
        }

        /* Keep your existing footer */
        footer {
            background-color: #6A4C9C;
            color: white;
            text-align: center;
            padding: 15px;
            margin-top: auto;
            font-size: 14px;
        }
    </style>
</head>
<body>

<header>
    <h1><%= electionName %></h1>
    <a class="btn-back" href="electionOverview.jsp">← Back to Election Overview</a>
</header>

<div class="container">
    <div class="candidates-grid">
        <%
            DecimalFormat df = new DecimalFormat("0.00");
            for (Map<String, Object> candidate : candidates) {
                int voteCount = (int) candidate.get("votes");
                double percentage = totalVotes > 0 ? (voteCount * 100.0 / totalVotes) : 0;
                boolean isWinner = voteCount == maxVotes;
        %>
        <div class="candidate-card <%= isWinner ? "winner" : "" %>">
            <img src="picture/candidates/<%= candidate.get("photo") %>" alt="Candidate Photo">
            <h3><%= candidate.get("name") %></h3>
            <p><strong>Party:</strong> <%= candidate.get("party") %></p>
            <p><strong>Votes:</strong> <%= voteCount %></p>
            <div class="progress mb-2">
                <div class="progress-bar" role="progressbar" style="width: <%= df.format(percentage) %>%;">
                    <%= df.format(percentage) %>%
                </div>
            </div>
        </div>
        <% } %>
    </div>
</div>

<footer>
    <p>&copy; 2025 Student Voting System</p>
</footer>

</body>
</html>