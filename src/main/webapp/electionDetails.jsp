<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<%@ page import="com.svs.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String electionId = request.getParameter("electionId");
    String electionName = "Election Not Found";
    String description = "No description available";
    String startDate = "Not specified";
    String endDate = "Not specified";
    List<Map<String, String>> candidates = new ArrayList<>();

    if (electionId != null && !electionId.isEmpty()) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM elections WHERE electionID = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, Integer.parseInt(electionId));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        electionName = rs.getString("electionName");
                        description = rs.getString("description");
                        startDate = new SimpleDateFormat("dd MMM yyyy").format(rs.getDate("startDate"));
                        endDate = new SimpleDateFormat("dd MMM yyyy").format(rs.getDate("endDate"));
                    }
                }
            }

            sql = "SELECT candidateID, candidateName, party, photo, manifesto, background FROM candidates WHERE electionID = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, Integer.parseInt(electionId));
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> candidate = new HashMap<>();
                        candidate.put("candidateID", rs.getString("candidateID"));
                        candidate.put("candidateName", rs.getString("candidateName"));
                        candidate.put("party", rs.getString("party"));
                        candidate.put("photo", rs.getString("photo"));
                        candidate.put("manifesto", rs.getString("manifesto"));
                        candidate.put("background", rs.getString("background"));
                        candidates.add(candidate);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    int modalCounter = 0;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= electionName %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f8f9fa;
        }

        header {
            background-color: #5A3E8C;
            color: white;
            padding: 40px 20px;
            text-align: center;
        }

        header h1 {
            font-size: 2.5rem;
            margin-bottom: 10px;
        }

        header p {
            margin: 0;
            font-size: 1.1rem;
        }

        .container {
            padding: 40px 20px;
        }

        .candidates-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 30px;
        }

        .candidate-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
            text-align: center;
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

        .read-more-link {
            font-size: 0.85rem;
            color: #5A3E8C;
            font-weight: 500;
            cursor: pointer;
            margin-left: 5px;
        }

        .vote-button {
            background-color: #5A3E8C;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 25px;
            margin-top: 15px;
            font-size: 0.95rem;
            transition: background-color 0.3s;
        }

        .vote-button:hover {
            background-color: #432f6c;
        }

        .back-link {
            display: inline-block;
            margin-top: 40px;
            color: #5A3E8C;
            text-decoration: none;
            font-weight: bold;
        }

        .modal-content {
            border-radius: 10px;
        }

        .modal-header {
            background-color: #5A3E8C;
            color: white;
        }

        .modal-title {
            font-weight: 600;
        }

        .modal-body p {
            white-space: pre-wrap;
            color: #333;
            font-size: 1rem;
        }
        
        #voteToast {
            position: fixed;
            bottom: 20px;
            right: 20px;
            z-index: 1100;
        }
    </style>
</head>
<body>

<header>
    <h1><%= electionName %></h1>
    <p><strong>Period:</strong> <%= startDate %> - <%= endDate %></p>
    <p><%= description %></p>
</header>

<div class="container">
    <h2 class="mb-4">Candidates</h2>

    <% if (candidates.isEmpty()) { %>
        <p class="text-danger">No candidates available for this election.</p>
    <% } else { %>
        <div class="candidates-grid">
            <% for (Map<String, String> candidate : candidates) {
                String candidateID = candidate.get("candidateID");
                String candidateName = candidate.get("candidateName");
                String party = candidate.get("party") != null ? candidate.get("party") : "Independent";
                String photo = candidate.get("photo") != null ? candidate.get("photo") : "default.jpg";
                String manifesto = candidate.get("manifesto") != null ? candidate.get("manifesto") : "Not provided";
                String background = candidate.get("background") != null ? candidate.get("background") : "Not available";

                String manifestoPreview = manifesto.length() > 100 ? manifesto.substring(0, 100) + "..." : manifesto;
                String backgroundPreview = background.length() > 100 ? background.substring(0, 100) + "..." : background;
                String modalIdManifesto = "manifestoModal" + modalCounter;
                String modalIdBackground = "backgroundModal" + modalCounter;
            %>
            <div class="candidate-card">
                <img src="picture/candidates/<%= candidate.get("photo") %>" alt="Candidate Photo">
                <h3><%= candidateName %></h3>
                <p><strong>Party:</strong> <%= party %></p>
                <p><strong>Manifesto:</strong> <%= manifestoPreview %>
                    <% if (manifesto.length() > 100) { %>
                        <span class="read-more-link" data-bs-toggle="modal" data-bs-target="#<%= modalIdManifesto %>">Read more</span>
                    <% } %>
                </p>
                <p><strong>Background:</strong> <%= backgroundPreview %>
                    <% if (background.length() > 100) { %>
                        <span class="read-more-link" data-bs-toggle="modal" data-bs-target="#<%= modalIdBackground %>">Read more</span>
                    <% } %>
                </p>
                <form action="VoteServlet" method="post" onsubmit="return confirmVote(this)">
                    <input type="hidden" name="candidateID" value="<%= candidateID %>">
                    <input type="hidden" name="electionID" value="<%= electionId %>">
                    <button type="submit" class="vote-button">Vote</button>
                </form>
            </div>

            <!-- Manifesto Modal -->
            <div class="modal fade" id="<%= modalIdManifesto %>" tabindex="-1" aria-labelledby="<%= modalIdManifesto %>Label" aria-hidden="true">
              <div class="modal-dialog modal-lg">
                <div class="modal-content">
                  <div class="modal-header">
                    <h5 class="modal-title" id="<%= modalIdManifesto %>Label"><%= candidateName %> - Manifesto</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                    <p><%= manifesto %></p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Background Modal -->
            <div class="modal fade" id="<%= modalIdBackground %>" tabindex="-1" aria-labelledby="<%= modalIdBackground %>Label" aria-hidden="true">
              <div class="modal-dialog modal-lg">
                <div class="modal-content">
                  <div class="modal-header">
                    <h5 class="modal-title" id="<%= modalIdBackground %>Label"><%= candidateName %> - Background</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                    <p><%= background %></p>
                  </div>
                </div>
              </div>
            </div>

            <%
                modalCounter++;
            } %>
        </div>
    <% } %>

    <a href="studentDashboard.jsp" class="back-link">← Back to Elections</a>
</div>

<div id="voteToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
    <div class="toast-header">
        <strong class="me-auto">Voting System</strong>
        <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
    </div>
    <div class="toast-body"></div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
// Enhanced vote confirmation and handling
function confirmVote(form) {
    const candidateName = form.closest('.candidate-card').querySelector('h3').textContent;
    const toast = new bootstrap.Toast(document.getElementById('voteToast'));
    const toastBody = document.querySelector('#voteToast .toast-body');
    
    if (!confirm(`Are you sure you want to vote for ${candidateName}?`)) {
        toastBody.textContent = 'Vote cancelled';
        toast.show();
        return false;
    }
    
    // Show loading state
    const button = form.querySelector('.vote-button');
    button.innerHTML = `
        <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
        Processing...
    `;
    button.disabled = true;
    
    // Show success message
    toastBody.textContent = `Voting for ${candidateName}...`;
    toast.show();
    
    return true;
}

// Debug: Log form submissions
document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('form').forEach(form => {
        form.addEventListener('submit', function() {
            console.log('Submitting vote for candidate:', 
                this.querySelector('input[name="candidateID"]').value);
        });
    });
});
</script>
</body>
</html>