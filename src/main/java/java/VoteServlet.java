/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import com.svs.util.DBConnection;
import java.io.IOException;
import java.sql.*;
import java.util.Arrays;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/VoteServlet")
public class VoteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Debug: Print all received parameters
        System.out.println("=== Received Parameters ===");
        request.getParameterMap().forEach((k, v) -> 
            System.out.println(k + " = " + Arrays.toString(v)));

        try {
            // Get parameters - using correct case (candidateID)
            String candidateIDParam = request.getParameter("candidateID");
            String electionIDParam = request.getParameter("electionID");

            // Validate parameters
            if (candidateIDParam == null || electionIDParam == null || 
                candidateIDParam.trim().isEmpty() || electionIDParam.trim().isEmpty()) {
                throw new ServletException("Invalid vote submission - missing parameters");
            }

            int candidateID = Integer.parseInt(candidateIDParam);
            int electionID = Integer.parseInt(electionIDParam);

            // Retrieve user ID from session
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("id") == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            int userID = (int) session.getAttribute("id");
            
            System.out.println("Processing vote: UserID=" + userID + 
                             ", ElectionID=" + electionID + 
                             ", CandidateID=" + candidateID);

            try (Connection conn = DBConnection.getConnection()) {
                conn.setAutoCommit(false);  // Start transaction

                try {
                    // Check for existing vote
                    String checkSql = "SELECT 1 FROM votes WHERE userID = ? AND electionID = ?";
                    try (PreparedStatement pCheck = conn.prepareStatement(checkSql)) {
                        pCheck.setInt(1, userID);
                        pCheck.setInt(2, electionID);
                        try (ResultSet rs = pCheck.executeQuery()) {
                            if (rs.next()) {
                                conn.rollback();
                                request.setAttribute("errorMessage", "You have already voted in this election!");
                                request.getRequestDispatcher("electionDetails.jsp").forward(request, response);
                                return;
                            }
                        }
                    }

                    // Record the vote using correct column names
                    String insertSql = "INSERT INTO votes (userID, electionID, voteChoice, voteDate) " +
                                      "VALUES (?, ?, ?, CURRENT_TIMESTAMP)";
                    
                    try (PreparedStatement pVote = conn.prepareStatement(insertSql)) {
                        pVote.setInt(1, userID);
                        pVote.setInt(2, electionID);
                        pVote.setInt(3, candidateID);  // Stored in voteChoice column
                        
                        int rowsAffected = pVote.executeUpdate();
                        if (rowsAffected != 1) {
                            conn.rollback();
                            throw new ServletException("Failed to record vote (no rows affected)");
                        }
                        
                        conn.commit();
                        System.out.println("Vote recorded successfully");
                        response.sendRedirect("thankYou.jsp");
                        return;
                    }
                } catch (SQLException e) {
                    conn.rollback();
                    System.err.println("SQL Error during voting: " + e.getMessage());
                    request.setAttribute("errorMessage", "Database error: " + e.getMessage());
                    request.getRequestDispatcher("errorPage.jsp").forward(request, response);
                }
            }
        } catch (NumberFormatException e) {
            System.err.println("Invalid ID format: " + e.getMessage());
            request.setAttribute("errorMessage", "Invalid candidate or election ID format");
            request.getRequestDispatcher("electionDetails.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Unexpected error: " + e.getMessage());
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("errorPage.jsp").forward(request, response);
        }
    }
}