<%-- 
    Document   : logout
    Created on : 20 Apr 2025, 4:05:12 am
    Author     : efeys
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    // Invalidate the session to log the user out
    session.invalidate();

    // Redirect to the login page
    response.sendRedirect("login.jsp");
%>
