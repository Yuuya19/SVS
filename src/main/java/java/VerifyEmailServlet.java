/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import com.svs.util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/VerifyEmailServlet")
public class VerifyEmailServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");

        try (Connection connection = DBConnection.getConnection()) {
            String sql = "SELECT * FROM users WHERE LOWER(username) = LOWER(?) AND LOWER(email) = LOWER(?)";

            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, username);
                statement.setString(2, email);
                ResultSet rs = statement.executeQuery();

                boolean found = rs.next();
                System.out.println("User match found: " + found);

                if (found) {
                    response.sendRedirect("passwordSetup.jsp?username=" + username + "&email=" + email);
                } else {
                    response.sendRedirect("verifyEmail.jsp?error=Username and email do not match");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("verifyEmail.jsp?error=Database error");
        }
    }
}

