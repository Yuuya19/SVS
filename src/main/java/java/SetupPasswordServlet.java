/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import com.svs.util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/SetupPasswordServlet")
public class SetupPasswordServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            response.sendRedirect("login.jsp?error=Session expired, please login again.");
            return;
        }

        int userId = (Integer) session.getAttribute("id");
        String newPassword = request.getParameter("password");

        try (Connection connection = DBConnection.getConnection()) {
            String sql = "UPDATE users SET password = ? WHERE id = ?";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, newPassword);
                statement.setInt(2, userId);
                int rowsUpdated = statement.executeUpdate();

                if (rowsUpdated > 0) {
                    // Password set successfully, redirect to login
                    session.invalidate(); // Log out user
                    response.sendRedirect("login.jsp?message=Password set successfully. Please login.");
                } else {
                    response.sendRedirect("first-time-setup.jsp?error=Failed to update password. Try again.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("first-time-setup.jsp?error=Database error.");
        }
    }
}
