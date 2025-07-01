<%-- 
    Document   : thankYou
    Created on : 24 Apr 2025, 3:05:53 am
    Author     : efeys
--%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thank You for Voting</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f0f8ff, #e6f2ff);
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
        }

        .container {
            background-color: #ffffff;
            border-radius: 16px;
            padding: 40px;
            text-align: center;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            max-width: 600px;
        }

        h1 {
            color: #007bff;
            font-size: 2em;
            margin-bottom: 20px;
        }

        p {
            color: #333;
            font-size: 1.1em;
            margin-bottom: 15px;
        }

        a {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 25px;
            background-color: #007bff;
            color: white;
            border-radius: 8px;
            text-decoration: none;
            transition: background-color 0.3s ease;
        }

        a:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Thank You for Your Vote!</h1>
        <p>Your vote has been successfully submitted.</p>
        <p>Your participation is important to us. Thank you for contributing to the election process!</p>

        <p>You will be redirected to the Student Dashboard shortly...</p>

        <a href="studentDashboard.jsp">Go to Student Dashboard Now</a>
    </div>

    <script>
        setTimeout(function() {
            window.location.href = "studentDashboard.jsp";
        }, 3000); // Redirect after 3 seconds
    </script>
</body>
</html>
