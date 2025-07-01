/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import com.svs.util.DBConnection;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ElectionResults")
public class ElectionResultsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String electionId = request.getParameter("electionId");
        
        // If no electionId parameter, redirect to elections page
        if (electionId == null || electionId.trim().isEmpty()) {
            response.sendRedirect("elections.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            // Get election details
            String electionName = "Election Results";
            String description = "";
            String sql = "SELECT electionName, description FROM elections WHERE electionID = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, Integer.parseInt(electionId));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        electionName = rs.getString("electionName");
                        description = rs.getString("description");
                    }
                }
            }

            // Get candidates and their vote counts
            List<Map<String, Object>> results = new ArrayList<>();
            sql = "SELECT c.candidateID, c.candidateName, c.party, c.photo, COUNT(v.voteID) as voteCount " +
                  "FROM candidates c LEFT JOIN votes v ON c.candidateID = v.voteChoice " +
                  "WHERE c.electionID = ? " +
                  "GROUP BY c.candidateID, c.candidateName, c.party, c.photo " +
                  "ORDER BY voteCount DESC";
            
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, Integer.parseInt(electionId));
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> candidate = new HashMap<>();
                        candidate.put("candidateID", rs.getInt("candidateID"));
                        candidate.put("candidateName", rs.getString("candidateName"));
                        candidate.put("party", rs.getString("party"));
                        candidate.put("photo", rs.getString("photo"));
                        candidate.put("voteCount", rs.getInt("voteCount"));
                        results.add(candidate);
                    }
                }
            }

            // Get total votes cast
            int totalVotes = 0;
            sql = "SELECT COUNT(*) as total FROM votes WHERE electionID = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, Integer.parseInt(electionId));
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        totalVotes = rs.getInt("total");
                    }
                }
            }

            // Set attributes for JSP
            request.setAttribute("electionName", electionName);
            request.setAttribute("description", description);
            request.setAttribute("results", results);
            request.setAttribute("totalVotes", totalVotes);
            request.setAttribute("electionId", electionId);
            
            // Forward to JSP
            request.getRequestDispatcher("electionResults.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid election ID format");
            request.getRequestDispatcher("errorPage.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("errorPage.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("errorPage.jsp").forward(request, response);
        }
    }
}