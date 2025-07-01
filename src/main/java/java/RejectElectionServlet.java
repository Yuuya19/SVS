/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.svs.util.DBConnection;

/**
 *
 * @author efeys
 */
import javax.servlet.*;
import java.sql.*;

public class RejectElectionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int electionID = Integer.parseInt(request.getParameter("electionID"));
        
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            // Establish database connection
            conn = DBConnection.getConnection();
            
            // SQL query to update the status of the election to 'Rejected'
            String sql = "UPDATE elections SET status = 'Rejected' WHERE electionID = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, electionID);

            // Execute update
            int rowsAffected = ps.executeUpdate();
            
            // If update was successful, redirect to the HEPA dashboard
            if (rowsAffected > 0) {
                response.sendRedirect("HEPADashboard.jsp"); // Redirect back to dashboard after rejection
            } else {
                // If no rows were updated, show an error
                request.setAttribute("errorMessage", "Error rejecting the election.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("hepaDashboard.jsp");
                dispatcher.forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("hepaDashboard.jsp");
            dispatcher.forward(request, response);
        } finally {
            // Close resources
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
