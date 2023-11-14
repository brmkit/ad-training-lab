<%@ Page Language="C#" %>
<%@ Import Namespace="System.Security.Principal" %>
<!DOCTYPE html>
<html>
<head>
    <title>Just a basic web auth</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #e5e5e5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .profile-card {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            text-align: center;
            padding: 20px;
            width: 300px;
        }
        .profile-card img {
            border-radius: 50%;
            width: 100px;
            height: 100px;
            object-fit: cover;
            border: 3px solid #ddd;
            margin-bottom: 20px;
        }
        .profile-card h1 {
            margin: 0;
            font-size: 24px;
            color: #333;
        }
        .profile-card p {
            color: #666;
            margin-bottom: 20px;
        }
        .profile-card .stats {
            margin-bottom: 20px;
        }
        .profile-card .stats span {
            font-size: 14px;
            color: #666;
            margin-right: 10px;
        }
        .profile-card button {
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            background-color: #007bff;
            color: white;
            cursor: pointer;
            margin-right: 5px;
        }
        .profile-card button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="profile-card">
        <img src="profile.jpg" alt="Profile Picture" />
        <h1>Hey, you!</h1>
        <p><asp:Label ID="usernameLabel" runat="server"></asp:Label></p>
        <div class="stats">
            <span>Damage: 41</span>
            <span>Vulns: >9k</span>
            <span>Rating: 8.5</span>
        </div>
        <button>File Hosting</button>
        <button>Change Password</button>
    </div>

    <script runat="server">
        protected void Page_Load(object sender, EventArgs e)
        {
            WindowsIdentity user = (WindowsIdentity)User.Identity;
            string username = user.Name;
            Response.AddHeader("X-Windows-Username", username);
            usernameLabel.Text = username;
        }
    </script>
</body>
</html>
