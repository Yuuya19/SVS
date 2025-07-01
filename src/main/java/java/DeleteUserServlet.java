/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import com.svs.util.DBConnection;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import javax.servlet.annotation.WebServlet;
/**
 *
 * @author efeys
 */
@WebServlet("/deleteUserServlet")
public class DeleteUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve the id parameter from the form
        String userIdStr = request.getParameter("id");

        // Ensure the id parameter is not null and not empty
        if (userIdStr != null && !userIdStr.isEmpty()) {
            try {
                // Parse the id parameter to an integer
                int userId = Integer.parseInt(userIdStr);

                // Create a connection to the database
                Connection connection = DBConnection.getConnection();
                String query = "DELETE FROM users WHERE id = ?";
                PreparedStatement ps = connection.prepareStatement(query);
                ps.setInt(1, userId);

                // Execute the delete query
                int result = ps.executeUpdate();

                if (result > 0) {
                    // Redirect to success page or back to user management page
                    response.sendRedirect("viewUsers.jsp");
                } else {
                    // Handle case where the user could not be deleted
                    response.sendRedirect("error.jsp");
                }
            } catch (NumberFormatException e) {
                // Handle the case where id is not a valid integer
                e.printStackTrace();
                response.sendRedirect("error.jsp");
            } catch (SQLException e) {
                // Handle database errors
                e.printStackTrace();
                response.sendRedirect("error.jsp");
            }
        } else {
            // Handle case where id is null or empty
            response.sendRedirect("error.jsp");
        }
    }
}
