/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import com.svs.util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.*;
import javax.servlet.http.*;

public class ApproveElectionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String electionID = request.getParameter("electionID");
        String approvedBy = request.getParameter("approvedBy");

        Connection connection = null;
        PreparedStatement ps = null;

        try {
            // Establish database connection
            connection = DBConnection.getConnection();

            // Prepare the update statement
            String query = "UPDATE elections SET status = 'Approved', approvedBy = ? WHERE electionID = ?";
            ps = connection.prepareStatement(query);
            ps.setString(1, approvedBy);
            ps.setString(2, electionID);

            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated > 0) {
                // Redirect on success
                response.sendRedirect("HEPADashboard.jsp");
            } else {
                // Forward to error page if update fails
                request.setAttribute("errorMessage", "Failed to approve election.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("approveElection.jsp");
                dispatcher.forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("approveElection.jsp");
            dispatcher.forward(request, response);
        } finally {
            try {
                if (ps != null) ps.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
