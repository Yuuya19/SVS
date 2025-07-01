<%-- 
    Document   : createElection
    Created on : 17 Apr 2025, 2:04:56 am
    Author     : efeys
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Election</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 600px;
            margin: 50px auto;
            background-color: #ffffff;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: #6A4C9C;
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }

        input[type="text"],
        input[type="date"],
        input[type="file"],
        textarea {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        textarea {
            resize: vertical;
        }

        .candidate-block {
            margin-top: 15px;
            border-top: 1px solid #ddd;
            padding-top: 10px;
        }

        button.add-btn {
            margin-top: 15px;
            background-color: #6A4C9C;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
        }

        button.add-btn:hover {
            background-color: #5a3c8d;
        }

        input[type="submit"] {
            margin-top: 25px;
            background-color: #6A4C9C;
            color: white;
            border: none;
            padding: 12px;
            width: 100%;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #5a3c8d;
        }

        .back-link {
            margin-top: 20px;
            display: block;
            text-align: center;
            text-decoration: none;
            color: #6A4C9C;
        }

        .back-link:hover {
            text-decoration: underline;
        }
        
        .remove-btn {
    margin-top: 10px;
    background-color: #e74c3c;
    color: white;
    border: none;
    padding: 8px 12px;
    border-radius: 6px;
    cursor: pointer;
    font-size: 14px;
}

.remove-btn:hover {
    background-color: #c0392b;
}

    </style>

    <script>
    function addCandidate() {
        const container = document.getElementById("candidates");

        const div = document.createElement("div");
        div.classList.add("candidate-block");

        div.innerHTML = `
            <label>Candidate Name:</label>
            <input type="text" name="candidateName" required />

            <label>Party:</label>
            <input type="text" name="candidateParty" required />

            <label>Photo:</label>
            <input type="file" name="candidatePhoto" accept="image/*" required />

            <label>Background Description:</label>
            <textarea name="candidateBackground" rows="3" placeholder="Brief background of the candidate..." required></textarea>

            <label>Manifesto:</label>
            <textarea name="candidateManifesto" rows="3" placeholder="Candidate's manifesto..." required></textarea>

            <button type="button" class="remove-btn" onclick="removeCandidate(this)">Remove</button>
        `;

        container.appendChild(div);
    }

    function removeCandidate(button) {
        const candidateBlock = button.parentElement;
        candidateBlock.remove();
    }
</script>


</head>
<body>
<div class="container">
    <h2>Create Election</h2>

    <form action="CreateElectionServlet" method="post" enctype="multipart/form-data">
        <label>Election Name:</label>
        <input type="text" name="electionName" required />

        <label>Start Date:</label>
        <input type="date" name="startDate" required />

        <label>End Date:</label>
        <input type="date" name="endDate" required />

        <label>Description:</label>
        <textarea name="description" rows="4" placeholder="Enter a short description for this election..." required></textarea>

        <h3 style="margin-top: 25px;">Candidates</h3>
        <div id="candidates"></div>
        <button type="button" class="add-btn" onclick="addCandidate()">Add Candidate</button>

        <input type="submit" value="Create Election" />
    </form>

    <a class="back-link" href="StaffDashboard.jsp">&larr; Back to Dashboard</a>
</div>
</body>
</html>
