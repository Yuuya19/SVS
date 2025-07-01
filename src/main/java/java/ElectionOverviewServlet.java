/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */



import com.svs.util.DBConnection;
import java.io.IOException;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ElectionOverview")
public class ElectionOverviewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Set current date (using java.util.Date explicitly)
        java.util.Date utilCurrentDate = new java.util.Date();
        String currentDateStr = new SimpleDateFormat("MMMM d, yyyy").format(utilCurrentDate);
        request.setAttribute("currentDate", currentDateStr);
        
        // 2. Get elections from database
        List<Map<String, Object>> elections = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            // Verify connection
            if (conn == null) {
                throw new SQLException("Failed to get database connection");
            }
            
            // 3. Query with proper joins for your schema
            String sql = "SELECT e.*, COUNT(v.voteID) as voteCount, " +
                       "u.username as approvedByName " +
                       "FROM elections e " +
                       "LEFT JOIN votes v ON e.electionID = v.electionID " +
                       "LEFT JOIN users u ON e.approvedBy = u.id " +
                       "GROUP BY e.electionID " +
                       "ORDER BY e.endDate DESC";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                ResultSet rs = stmt.executeQuery();
                
                // 4. Process results with null checks
                while (rs.next()) {
                    Map<String, Object> election = new HashMap<>();
                    
                    // Required fields
                    election.put("electionID", rs.getInt("electionID"));
                    election.put("electionName", rs.getString("electionName"));
                    
                    // Nullable fields
                    election.put("description", rs.getString("description"));
                    election.put("status", rs.getString("status"));
                    election.put("approvedByName", rs.getString("approvedByName"));
                    election.put("voteCount", rs.getInt("voteCount"));
                    
                    // Date handling with explicit types
                    java.sql.Date sqlStartDate = rs.getDate("startDate");
                    java.sql.Date sqlEndDate = rs.getDate("endDate");
                    election.put("startDate", sqlStartDate);
                    election.put("endDate", sqlEndDate);
                    
                    // Calculate if ongoing (using java.util.Date for comparison)
                    boolean isOngoing = false;
                    if (sqlStartDate != null && sqlEndDate != null) {
                        java.util.Date startDate = new java.util.Date(sqlStartDate.getTime());
                        java.util.Date endDate = new java.util.Date(sqlEndDate.getTime());
                        isOngoing = !utilCurrentDate.before(startDate) && !utilCurrentDate.after(endDate);
                    }
                    election.put("isOngoing", isOngoing);
                    
                    elections.add(election);
                }
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error loading elections: " + e.getMessage());
            request.getRequestDispatcher("errorPage.jsp").forward(request, response);
            return;
        }
        
        // 5. Set attributes and forward
        request.setAttribute("elections", elections);
        request.getRequestDispatcher("electionOverview.jsp").forward(request, response);
    }
}