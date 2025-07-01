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

@WebServlet("/PasswordSetupServlet")
public class PasswordSetupServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!password.equals(confirmPassword)) {
            response.sendRedirect("passwordSetup.jsp?email=" + email + "&error=Passwords do not match");
            return;
        }

        // TODO: Add password strength validation here if needed

        try (Connection connection = DBConnection.getConnection()) {
            String sql = "UPDATE users SET password = ? WHERE email = ?";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, password);  // IMPORTANT: Ideally hash the password before saving!
                statement.setString(2, email);

                int rowsUpdated = statement.executeUpdate();
                if (rowsUpdated > 0) {
                    // Password updated successfully
                    response.sendRedirect("login.jsp?message=Password set successfully. Please login.");
                } else {
                    // Email not found or error
                    response.sendRedirect("passwordSetup.jsp?email=" + email + "&error=Error updating password");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("passwordSetup.jsp?email=" + email + "&error=Database error");
        }
    }
}
