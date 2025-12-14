<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SUST Connect | Secure Login</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/login.css">
</head>
<body>

    <div class="main-wrapper">
        <div class="login-card">
            
            <div class="brand-side">
                <div class="overlay"></div>
                <div class="brand-content">
                    <div class="logo-area">
                        <i class="fas fa-university fa-3x"></i>
                    </div>
                    <h2>SUST Connect</h2>
                    <p>Empowering the future of Shahjalal University of Science and Technology.</p>
                </div>
            </div>

            <div class="form-side">
                <div class="form-header">
                    <h3>Welcome Back</h3>
                    <p class="sub-text">Please enter your details to sign in.</p>
                </div>

                <div class="role-selector">
                    <button type="button" class="role-tab active" onclick="selectRole('student', this)">
                        <i class="fas fa-user-graduate"></i> Student
                    </button>
                    <button type="button" class="role-tab" onclick="selectRole('teacher', this)">
                        <i class="fas fa-chalkboard-teacher"></i> Teacher
                    </button>
                    <button type="button" class="role-tab" onclick="selectRole('admin', this)">
                        <i class="fas fa-shield-alt"></i> Admin
                    </button>
                </div>

                <form action="Login" method="post" class="login-form">
                    
                    <div class="input-group">
                        <label>Username</label>
                        <div class="input-wrapper">
                            <i class="fas fa-user input-icon"></i>
                            <input type="text" name="username" placeholder="e.g. 2018331009" required autocomplete="username">
                        </div>
                    </div>

                    <div class="input-group">
                        <label>Password</label>
                        <div class="input-wrapper">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password" name="password" placeholder="••••••••" required>
                        </div>
                        <div class="forgot-pass">
                            <a href="forgot-password.jsp">Forgot Password?</a>
                        </div>
                    </div>

                    <input type="hidden" name="role" id="role-input" value="student">

                    <button type="submit" class="btn-primary">
                        Sign In <i class="fas fa-arrow-right"></i>
                    </button>

                    <div class="form-footer">
                        <p>Don't have an account? <a href="register.jsp">Request Access</a></p>
                        <p class="faded-link"><a href="support.jsp">Report Issue / Close Account</a></p>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function selectRole(roleValue, element) {
            // 1. Set the hidden input value
            document.getElementById('role-input').value = roleValue;
            
            // 2. Remove 'active' class from all tabs
            const tabs = document.querySelectorAll('.role-tab');
            tabs.forEach(tab => tab.classList.remove('active'));
            
            // 3. Add 'active' class to clicked tab
            element.classList.add('active');
        }
    </script>
</body>
</html>