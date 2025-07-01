<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>

    <style>
        /* Global Styles */
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
            color: #333;
        }

        h2, h3 {
            color: white;
            margin: 0;
        }

        p {
            font-size: 1em;
            color: #ddd;
            margin: 10px 0;
        }

        /* Header */
        header {
            background-color: #6A4C9C; 
            color: white;
            padding: 40px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            position: relative;
        }

        header h2 {
            font-size: 3em;
            font-weight: bold;
            letter-spacing: 2px;
        }

        .logout-button {
            position: absolute;
            top: 20px;
            right: 20px;
            background-color: #fff;
            color: #6A4C9C;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .logout-button:hover {
            background-color: #6A4C9C;
            color: #fff;
        }

        /* Main content */
        .content {
            margin: 40px auto;
            width: 80%;
            background-color: #f4f4f9;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            color: #333;
        }

        .content h3 {
            color: #6A4C9C;
        }

        .content p {
            color: #333;
        }

        .content a {
            background-color: #6A4C9C;
            color: white;
            padding: 12px 20px;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
            margin: 10px 0;
            display: inline-block;
            transition: background-color 0.3s ease;
        }

        .content a:hover {
            background-color: #4A2A6A;
        }

        /* Footer */
        footer {
            background-color: #6A4C9C;
            color: white;
            text-align: center;
            padding: 15px;
            position: fixed;
            bottom: 0;
            width: 100%;
            box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .content {
                width: 90%;
                padding: 20px;
            }
        }
    </style>
</head>
<body>

<header>
    <h2>Admin Dashboard</h2>
    <p>Manage elections and users</p>
    <!-- Logout Button -->
    <form action="login.jsp" method="get" style="display: inline;">
        <button type="submit" class="logout-button">Logout</button>
    </form>
</header>

<div class="content">
    <h3>Election Management</h3>
    <p>Choose an action to manage elections:</p>
    <a href="#">Create New Election</a>
    <a href="#">Edit Existing Election</a>
    <a href="#">Delete Election</a>
</div>

<footer>
    <p>&copy; 2025 Admin Dashboard. All Rights Reserved.</p>
</footer>

</body>
</html>
