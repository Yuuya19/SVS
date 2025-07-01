/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */



import com.svs.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/UpdatePasswordServlet")
public class UpdatePasswordServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer id = (Integer) session.getAttribute("id");
        String newPassword = request.getParameter("newPassword");

        if (id == null || newPassword == null || newPassword.trim().isEmpty()) {
            response.sendRedirect("studentProfile.jsp");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE users SET password = ? WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, newPassword);
            ps.setInt(2, id);
            int updated = ps.executeUpdate();

            if (updated > 0) {
                request.setAttribute("message", "Password updated successfully.");
            } else {
                request.setAttribute("message", "Password update failed.");
            }
        } catch (SQLException e) {
            request.setAttribute("message", "Error: " + e.getMessage());
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignore) {}
            try { if (conn != null) conn.close(); } catch (Exception ignore) {}
        }

        request.getRequestDispatcher("studentProfile.jsp").forward(request, response);
    }
}
