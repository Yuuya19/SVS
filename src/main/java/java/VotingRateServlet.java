/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.svs.util.DBConnection;

@WebServlet("/voting-rate")
public class VotingRateServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        List<Integer> years = new ArrayList<>();
        List<Integer> votingRates = new ArrayList<>();

        try {
            // Establish connection to the database using DBConnection utility class
            connection = DBConnection.getConnection();

            // SQL query to get the voting rate by year
            String sql = "SELECT YEAR(voteDate) AS year, "
                       + "COUNT(voteID) * 100 / (SELECT COUNT(*) FROM students) AS votingRate "
                       + "FROM votes "
                       + "GROUP BY YEAR(voteDate) "
                       + "ORDER BY year DESC";

            // Prepare the statement and execute the query
            ps = connection.prepareStatement(sql);
            rs = ps.executeQuery();

            // Process the result set
            while (rs.next()) {
                years.add(rs.getInt("year"));
                votingRates.add(rs.getInt("votingRate"));
            }

            // Set the data in the request scope to pass it to the JSP
            request.setAttribute("years", years);
            request.setAttribute("votingRates", votingRates);

            // Forward the request to the HEPADashboard.jsp to display the chart
            request.getRequestDispatcher("/HEPADashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred.");
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
