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
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection connection = DBConnection.getConnection()) {
            String sql = "SELECT * FROM users WHERE username = ?";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, username);

                ResultSet resultSet = statement.executeQuery();
                if (resultSet.next()) {
                    String dbPassword = resultSet.getString("password");

                    if (dbPassword == null || dbPassword.isEmpty()) {
                        // First-time login: redirect to password setup page
                        int id = resultSet.getInt("id");
                        HttpSession session = request.getSession();
                        session.setAttribute("id", id);
                        session.setAttribute("username", username);
                        session.setAttribute("role", resultSet.getString("role"));

                        response.sendRedirect("verifyEmail.jsp");
                        return;
                    }

                    if (dbPassword.equals(password)) {
                        // Successful login
                        String role = resultSet.getString("role");
                        int id = resultSet.getInt("id");

                        HttpSession session = request.getSession();
                        session.setAttribute("id", id);
                        session.setAttribute("username", username);
                        session.setAttribute("role", role);

                        // Redirect based on role
                        switch (role) {
                            case "Student":
                                response.sendRedirect("studentDashboard.jsp");
                                break;
                            case "HEPA":
                                response.sendRedirect("HEPADashboard.jsp");
                                break;
                            case "Staff":
                                response.sendRedirect("StaffDashboard.jsp");
                                break;
                            default:
                                response.sendRedirect("login.jsp?error=Invalid role");
                                break;
                        }
                    } else {
                        response.sendRedirect("login.jsp?error=Invalid credentials");
                    }
                } else {
                    response.sendRedirect("login.jsp?error=Invalid credentials");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=Database error");
        }
    }
}
