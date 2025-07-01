<%-- 
    Document   : studentProfile
    Created on : 10 Jun 2025, 7:30:24 pm
    Author     : efeys
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.svs.util.DBConnection" %>
<%
    Integer id = (Integer) session.getAttribute("id");
    String role = (String) session.getAttribute("role");

    if (id == null || role == null || !role.equals("Student")) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = "";
    String email = "";

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        String query = "SELECT username, email FROM users WHERE id = ?";
        ps = conn.prepareStatement(query);
        ps.setInt(1, id);
        rs = ps.executeQuery();
        if (rs.next()) {
            username = rs.getString("username");
            email = rs.getString("email");
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error loading profile: " + e.getMessage() + "</p>");
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
    <title>My Profile | Student Voting System</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f7f6;
            margin: 0;
            padding: 30px;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
        }
        .container {
            background: white;
            padding: 40px 35px;
            max-width: 480px;
            width: 100%;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        h2 {
            color: #6A4C9C;
            text-align: center;
            margin-bottom: 25px;
            font-weight: 700;
            letter-spacing: 1px;
            font-size: 2rem;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #6A4C9C;
            font-size: 0.95rem;
        }
        input[type="text"],
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 12px 14px;
            margin-bottom: 18px;
            border: 1.8px solid #ccc;
            border-radius: 6px;
            font-size: 1rem;
        }
        input[readonly] {
            background-color: #e9ecef;
            cursor: default;
            color: #555;
        }
        input:focus {
            border-color: #6A4C9C;
            outline: none;
            box-shadow: 0 0 6px rgba(106, 76, 156, 0.3);
        }
        .btn {
            background-color: #6A4C9C;
            color: white;
            padding: 14px 0;
            width: 100%;
            border: none;
            border-radius: 30px;
            font-size: 1.05rem;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
        }
        .btn:hover {
            background-color: #593d7b;
            transform: translateY(-2px);
        }
        .section-title {
            margin-top: 30px;
            margin-bottom: 10px;
            font-size: 1.1rem;
            color: #444;
            border-bottom: 1px solid #ddd;
            padding-bottom: 5px;
            font-weight: bold;
        }
        .info-text {
            font-size: 0.9rem;
            color: #777;
            margin-bottom: 15px;
        }
        .back {
            text-align: center;
            margin-top: 30px;
        }
        .back a {
            text-decoration: none;
            color: #6A4C9C;
            font-weight: 600;
            transition: color 0.3s ease;
        }
        .back a:hover {
            color: #593d7b;
            text-decoration: underline;
        }
        .message {
            text-align: center;
            margin-bottom: 20px;
            font-weight: 600;
            font-size: 0.95rem;
        }
        .message.success {
            color: #28a745;
        }
        .message.error {
            color: #d93025;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>My Profile</h2>

        <div class="section-title">Account Information</div>

        <label>Username:</label>
        <input type="text" value="<%= username %>" readonly />

        <label>Email:</label>
        <input type="email" value="<%= email %>" readonly />

        <div class="section-title">Change Password</div>
        <p class="info-text">Use a strong password with at least 8 characters, including letters and numbers.</p>

        <form action="UpdatePasswordServlet" method="post" autocomplete="off">
            <label for="currentPassword">Current Password:</label>
            <input type="password" id="currentPassword" name="currentPassword" placeholder="Enter current password" required />

            <label for="newPassword">New Password:</label>
            <input type="password" id="newPassword" name="newPassword" placeholder="Enter new password" required />

            <button type="submit" class="btn">Update Password</button>
        </form>

        <div class="back">
            <a href="studentDashboard.jsp">&larr; Back to Dashboard</a>
        </div>
    </div>
</body>
</html>
