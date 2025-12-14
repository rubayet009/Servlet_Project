<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <link rel="stylesheet" href="css/login.css">
</head>
<body>
    
    <div class="login-wrapper">
        <div class="login-content">
            <h1 class="title">
                <span class="highlight">ENTER YOUR USERNAME AND PASSWORD TO LOGIN</span>
            </h1>
            <p class="subtitle" id="sub">ONLY TEACHER,STUDENT AND ADMIN OF SUST CAN LOGIN !</p>

            <form action="Login" method="post" class="login-form">
                <input type="text" name="username" placeholder="Username" required>
                <input type="password" name="password" placeholder="Password" required>

                <input type="hidden" name="role" id="role" value="student">
                
                <button type="submit" class="submit-btn">Login</button>
            </form>
        </div>
    </div>

    <script>
        function setRole(role) {
            document.getElementById('role').value = role;
            document.querySelectorAll('.role-btn').forEach(btn => btn.classList.remove('active'));
            document.querySelector(`.role-btn.${role}`).classList.add('active');
        }
    </script>
</body>
</html>
