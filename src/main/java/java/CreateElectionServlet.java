/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */



import com.svs.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.Paths;
import java.sql.*;
import java.util.*;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,       // 1MB
    maxFileSize = 5 * 1024 * 1024,         // 5MB
    maxRequestSize = 20 * 1024 * 1024      // 20MB
)
@WebServlet("/CreateElectionServlet")
public class CreateElectionServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "C:/Project/SVS/web/picture/candidates/";


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String electionName = request.getParameter("electionName");
        String description = request.getParameter("description");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        int electionId = -1;
        Connection conn = null;

        try {
            conn = DBConnection.getConnection();

            // Insert election data
            PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO elections (electionName, description, startDate, endDate, status) VALUES (?, ?, ?, ?, ?)",
                Statement.RETURN_GENERATED_KEYS
            );
            stmt.setString(1, electionName);
            stmt.setString(2, description);
            stmt.setString(3, startDate);
            stmt.setString(4, endDate);
            stmt.setString(5, "pending");
            stmt.executeUpdate();

            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                electionId = rs.getInt(1);
            }

            // ✅ Ensure upload directory exists
            File uploadDir = new File(UPLOAD_DIR);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            // Get candidates info
            Collection<Part> parts = request.getParts();
            List<String> names = Arrays.asList(request.getParameterValues("candidateName"));
            List<String> parties = Arrays.asList(request.getParameterValues("candidateParty"));
            List<String> backgrounds = Arrays.asList(request.getParameterValues("candidateBackground"));
            List<String> manifestos = Arrays.asList(request.getParameterValues("candidateManifesto"));
            List<Part> photos = new ArrayList<>();

            // Extract photos
            for (Part part : parts) {
                if ("candidatePhoto".equals(part.getName()) && part.getSize() > 0) {
                    photos.add(part);
                }
            }

            // Loop through candidates
            for (int i = 0; i < names.size(); i++) {
                String candidateName = names.get(i);
                String candidateParty = parties.get(i);
                String candidateBackground = backgrounds.get(i);
                String candidateManifesto = manifestos.get(i);
                Part photoPart = photos.get(i);

                // Get photo file name
                String fileName = Paths.get(photoPart.getSubmittedFileName()).getFileName().toString();

                // Save the photo
                File photoFile = new File(UPLOAD_DIR, fileName);
                photoPart.write(photoFile.getAbsolutePath());

                // Insert candidate info to DB
                PreparedStatement candStmt = conn.prepareStatement(
                    "INSERT INTO candidates (electionID, candidateName, party, photo, background, manifesto) VALUES (?, ?, ?, ?, ?, ?)"
                );
                candStmt.setInt(1, electionId);
                candStmt.setString(2, candidateName);
                candStmt.setString(3, candidateParty);
                candStmt.setString(4, fileName);
                candStmt.setString(5, candidateBackground);
                candStmt.setString(6, candidateManifesto);
                candStmt.executeUpdate();
            }

            response.sendRedirect("StaffDashboard.jsp?success=Election created successfully");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("createElection.jsp?error=Database error");
        } catch (IOException | ServletException e) {
            e.printStackTrace();
            response.sendRedirect("createElection.jsp?error=File upload error");
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
