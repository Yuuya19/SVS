/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import com.svs.util.DBConnection;
import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class AddUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username").trim();
        String password = request.getParameter("password").trim();
        String email = request.getParameter("email").trim().toLowerCase();  // standardize
        String role = request.getParameter("role");

        Connection connection = null;
        PreparedStatement psCheck = null;
        PreparedStatement psInsert = null;
        ResultSet rs = null;

        try {
            connection = DBConnection.getConnection();

            // Check if username or email already exists
            String checkQuery = "SELECT id FROM users WHERE username = ? OR email = ?";
            psCheck = connection.prepareStatement(checkQuery);
            psCheck.setString(1, username);
            psCheck.setString(2, email);
            rs = psCheck.executeQuery();

            if (rs.next()) {
                // User already exists
                request.setAttribute("errorMessage", "This user already exists.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("addUser.jsp");
                dispatcher.forward(request, response);
            } else {
                // Insert the new user
                String insertQuery = "INSERT INTO users (username, password, email, role) VALUES (?, ?, ?, ?)";
                psInsert = connection.prepareStatement(insertQuery);
                psInsert.setString(1, username);
                psInsert.setString(2, password);  // You may hash this
                psInsert.setString(3, email);
                psInsert.setString(4, role);

                int rowsAffected = psInsert.executeUpdate();

                if (rowsAffected > 0) {
                    response.sendRedirect("StaffDashboard.jsp");
                } else {
                    request.setAttribute("errorMessage", "Error adding user.");
                    RequestDispatcher dispatcher = request.getRequestDispatcher("addUser.jsp");
                    dispatcher.forward(request, response);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("addUser.jsp");
            dispatcher.forward(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
                if (psCheck != null) psCheck.close();
                if (psInsert != null) psInsert.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
