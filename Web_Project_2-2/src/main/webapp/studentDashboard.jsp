<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.bson.Document, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard | EduManage</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="css/studentDashboard.css">
</head>
<body>

    <header class="main-header">
        <div class="logo-area">
            <div class="logo-icon">
                <i class="fas fa-graduation-cap"></i>
            </div>
            <span class="logo-text">EduManage <span>Student</span></span>
        </div>
        <div class="user-profile">
            <div class="profile-info">
                <span class="user-name"><%= request.getAttribute("username") != null ? request.getAttribute("username") : "Student" %></span>
                <span class="user-role">Undergraduate</span>
            </div>
            <img src="https://ui-avatars.com/api/?name=<%= request.getAttribute("username") != null ? request.getAttribute("username") : "Student" %>&background=d32f2f&color=ffffff&bold=true" alt="Student">
            
            <form action="Logout" method="post" style="margin-left: 10px;">
                <button type="submit" class="logout-icon-btn" title="Logout">
                    <i class="fas fa-power-off"></i>
                </button>
            </form>
        </div>
    </header>

    <div class="dashboard-container">

        <% String error = request.getParameter("error"); if (error != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> <%= error %>
            </div>
        <% } %>

        <% String success = request.getParameter("success"); if (success != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> <%= success %>
            </div>
        <% } %>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon primary">
                    <i class="fas fa-book-reader"></i>
                </div>
                <div class="stat-details">
                    <h3><%= request.getAttribute("totalEnrolled") != null ? request.getAttribute("totalEnrolled") : "0" %></h3>
                    <p>Enrolled Courses</p>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon info">
                    <i class="fas fa-layer-group"></i>
                </div>
                <div class="stat-details">
                    <h3><%= request.getAttribute("allCourses") != null ? ((List<?>) request.getAttribute("allCourses")).size() : "0" %></h3>
                    <p>Available Courses</p>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon success">
                    <i class="fas fa-id-card"></i>
                </div>
                <div class="stat-details">
                    <h3>Active</h3>
                    <p>Student Status</p>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon warning">
                    <i class="fas fa-bolt"></i>
                </div>
                <div class="stat-details">
                    <h3>Quick</h3>
                    <p>Actions</p>
                </div>
            </div>
        </div>

        <div class="nav-tabs-container">
            <button class="nav-tab active" onclick="switchTab('my-courses', this)">
                <i class="fas fa-book"></i> My Courses
            </button>
            <button class="nav-tab" onclick="switchTab('register-courses', this)">
                <i class="fas fa-plus-circle"></i> Register New Course
            </button>
        </div>

        <div id="my-courses" class="tab-content active fade-in-up">
            <div class="section-header">
                <h2>My Enrolled Courses</h2>
                <div class="divider"></div>
            </div>
            
            <% 
                List<Document> enrolledCourses = (List<Document>) request.getAttribute("enrolledCourses");
                if (enrolledCourses == null || enrolledCourses.isEmpty()) { 
            %>
                <div class="empty-state">
                    <img src="https://cdn-icons-png.flaticon.com/512/7486/7486747.png" alt="Empty">
                    <h3>No Enrollments Yet</h3>
                    <p>You haven't enrolled in any courses. Check the "Register New Course" tab.</p>
                    <button class="btn-primary" onclick="triggerRegisterTab()" style="max-width: 200px; margin: 20px auto;">
                        Browse Courses
                    </button>
                </div>
            <% } else { %>
                <div class="courses-grid">
                    <% for (Document course : enrolledCourses) { 
                        String desc = course.getString("description");
                        if(desc == null) desc = "No description available";
                    %>
                        <div class="course-card">
                            <div class="course-top">
                                <span class="credit-badge"><%= course.getInteger("credits", 0) %> Credits</span>
                                <div class="course-icon">
                                    <i class="fas fa-check-circle" style="color: var(--success);"></i>
                                </div>
                            </div>
                            <div class="course-content">
                                <h3><%= course.getString("title") %></h3>
                                <p class="course-code"><%= course.getString("courseId") %></p>
                                <p class="course-desc">
                                    <%= desc.length() > 80 ? desc.substring(0, 80) + "..." : desc %>
                                </p>
                            </div>
                            <div class="card-footer">
                                <button class="btn-disabled full-width">
                                    <i class="fas fa-check"></i> Enrolled
                                </button>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>

        <div id="register-courses" class="tab-content fade-in-up">
            <div class="section-header">
                <h2>Available for Registration</h2>
                <div class="divider"></div>
            </div>
            
            <% 
                List<Document> allCourses = (List<Document>) request.getAttribute("allCourses");
                if (allCourses == null || allCourses.isEmpty()) { 
            %>
                <div class="empty-state">
                    <i class="fas fa-folder-open fa-3x" style="color:#ccc;"></i>
                    <p>No courses available for registration at this time.</p>
                </div>
            <% } else { %>
                <div class="courses-grid">
                    <% for (Document course : allCourses) { 
                        String courseId = course.getString("courseId");
                        String desc = course.getString("description");
                        if(desc == null) desc = "No description available";
                        
                        // Check enrollment logic
                        boolean isEnrolled = false;
                        if (enrolledCourses != null) {
                            for (Document enrolled : enrolledCourses) {
                                if (enrolled.getString("courseId").equals(courseId)) {
                                    isEnrolled = true;
                                    break;
                                }
                            }
                        }
                    %>
                        <div class="course-card">
                            <div class="course-top">
                                <span class="credit-badge"><%= course.getInteger("credits", 0) %> Credits</span>
                                <div class="course-icon">
                                    <i class="fas fa-laptop-code"></i>
                                </div>
                            </div>
                            <div class="course-content">
                                <h3><%= course.getString("title") %></h3>
                                <p class="course-code"><%= courseId %></p>
                                <p class="course-desc">
                                    <%= desc.length() > 80 ? desc.substring(0, 80) + "..." : desc %>
                                </p>
                            </div>
                            <div class="card-footer">
                                <% if (isEnrolled) { %>
                                    <button class="btn-disabled full-width">
                                        <i class="fas fa-check"></i> Already Enrolled
                                    </button>
                                <% } else { %>
                                    <form action="RegisterCourseServlet" method="post">
                                        <input type="hidden" name="courseId" value="<%= courseId %>">
                                        <button type="submit" class="btn-primary full-width">
                                            <i class="fas fa-plus-circle"></i> Register Now
                                        </button>
                                    </form>
                                <% } %>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>

    </div>

    <script>
        function switchTab(tabId, btnElement) {
            // 1. Hide all contents
            document.querySelectorAll('.tab-content').forEach(content => {
                content.classList.remove('active');
                // Optional: Reset animation
                content.style.animation = 'none';
                content.offsetHeight; /* trigger reflow */
                content.style.animation = null; 
            });

            // 2. Deactivate all buttons
            document.querySelectorAll('.nav-tab').forEach(btn => {
                btn.classList.remove('active');
            });

            // 3. Show selected content & activate button
            document.getElementById(tabId).classList.add('active');
            if(btnElement) {
                btnElement.classList.add('active');
            }
        }

        function triggerRegisterTab() {
            const registerBtn = document.querySelectorAll('.nav-tab')[1]; // Select the second tab button
            switchTab('register-courses', registerBtn);
        }
    </script>
</body>
</html>