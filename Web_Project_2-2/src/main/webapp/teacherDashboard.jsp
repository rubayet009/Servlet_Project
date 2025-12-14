<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.bson.Document, java.util.List" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Dashboard | EduManage</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="css/teacherDashboard.css">
</head>
<body>

    <header class="main-header">
        <div class="logo-area">
            <div class="logo-icon">
                <i class="fas fa-university"></i>
            </div>
            <span class="logo-text">SUST <span>Connect</span></span>
        </div>

        <div class="user-profile">
            <div class="profile-info">
                <span class="user-name"><%= request.getAttribute("username") != null ? request.getAttribute("username") : "Instructor" %></span>
                <span class="user-role">Faculty Member</span>
            </div>
            <img src="https://ui-avatars.com/api/?name=<%= request.getAttribute("username") != null ? request.getAttribute("username") : "Teacher" %>&background=d32f2f&color=ffffff&bold=true" alt="Profile">
            
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
                <i class="fas fa-exclamation-circle"></i> <span><%= error %></span>
            </div>
        <% } %>

        <% String success = request.getParameter("success"); if (success != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> <span><%= success %></span>
            </div>
        <% } %>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon warning">
                    <i class="fas fa-book-reader"></i>
                </div>
                <div class="stat-details">
                    <h3><%= request.getAttribute("totalCourses") != null ? request.getAttribute("totalCourses") : "0" %></h3>
                    <p>Active Courses</p>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon info">
                    <i class="fas fa-users"></i>
                </div>
                <div class="stat-details">
                    <h3><%= request.getAttribute("totalStudents") != null ? request.getAttribute("totalStudents") : "0" %></h3>
                    <p>Total Students</p>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon success">
                    <i class="fas fa-chalkboard-teacher"></i>
                </div>
                <div class="stat-details">
                    <h3>Faculty</h3>
                    <p>Current Role</p>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon primary">
                    <i class="fas fa-tools"></i>
                </div>
                <div class="stat-details">
                    <h3>Settings</h3>
                    <p>System Config</p>
                </div>
            </div>
        </div>

        <% 
            Document course = (Document) request.getAttribute("course");
            if (course != null) {
                // --- VIEW: SPECIFIC COURSE STUDENTS (Waterfall Table Animation) ---
                List<Document> enrolledStudents = (List<Document>) request.getAttribute("enrolledStudents");
        %>
            <div class="content-card">
                <div class="card-header">
                    <div class="header-title">
                        <h2><i class="fas fa-chalkboard"></i> <%= course.getString("title") %></h2>
                        <span class="badge">Code: <%= course.getString("courseId") %></span>
                    </div>
                    <a href="TeacherCourseServlet" class="btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Courses
                    </a>
                </div>

                <div class="tabs-wrapper">
                    <button class="tab-btn active">Student List</button>
                    <button class="tab-btn">Attendance Sheet</button>
                    <button class="tab-btn">Gradebook</button>
                </div>

                <% if (enrolledStudents == null || enrolledStudents.isEmpty()) { %>
                    <div class="empty-state">
                        <img src="https://cdn-icons-png.flaticon.com/512/7486/7486747.png" alt="No Students">
                        <h3>No Students Enrolled</h3>
                        <p>Students have not registered for this course yet.</p>
                    </div>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="styled-table">
                            <thead>
                                <tr>
                                    <th>Reg. ID</th>
                                    <th>Student Name</th>
                                    <th>Email Address</th>
                                    <th>Status</th>
                                    <th style="text-align: right;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Document student : enrolledStudents) { %>
                                    <tr>
                                        <td class="id-col">#<%= student.getString("username") %></td>
                                        <td style="font-weight: 600;"><%= student.getString("name") %></td>
                                        <td style="color: #6b7280;"><%= student.getString("email") %></td>
                                        <td><span class="status-badge active">Active</span></td>
                                        <td style="text-align: right;">
                                            <button class="action-btn" title="View Profile"><i class="fas fa-user"></i></button>
                                            <button class="action-btn" title="Email Student"><i class="fas fa-envelope"></i></button>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>

        <% } else { 
            // --- VIEW: ALL COURSES GRID (Staggered Card Animation) ---
            List<Document> teacherCourses = (List<Document>) request.getAttribute("teacherCourses");
        %>
            <div class="section-title">
                <h2>My Assigned Courses [Image of classroom teaching]</h2>
            </div>

            <% if (teacherCourses == null || teacherCourses.isEmpty()) { %>
                <div class="content-card empty-state">
                    <img src="https://cdn-icons-png.flaticon.com/512/4076/4076432.png" alt="Empty">
                    <h3>No Courses Assigned</h3>
                    <p>You currently have no active courses. Please contact the administrator.</p>
                </div>
            <% } else { %>
                <div class="courses-grid">
                    <% for (Document courseDoc : teacherCourses) { 
                        String desc = courseDoc.getString("description");
                        if(desc == null) desc = "No description provided.";
                    %>
                        <div class="course-card">
                            <div class="course-top">
                                <span class="credit-badge"><%= courseDoc.getInteger("credits", 0) %> Credits</span>
                                <div class="course-icon">
                                    <i class="fas fa-laptop-code"></i>
                                </div>
                            </div>
                            <div class="course-content">
                                <h3><%= courseDoc.getString("title") %></h3>
                                <p class="course-code"><%= courseDoc.getString("courseId") %></p>
                                <p class="course-desc">
                                    <%= desc.length() > 80 ? desc.substring(0, 80) + "..." : desc %>
                                </p>
                            </div>
                            <a href="CourseStudentServlet?courseId=<%= courseDoc.getString("courseId") %>" class="btn-primary">
                                Manage Class <i class="fas fa-arrow-right" style="margin-left:5px;"></i>
                            </a>
                        </div>
                    <% } %>
                </div>
            <% } %>
        <% } %>
    </div>

    <script>
        // Simple Logic for Tab Switching Visuals
        const tabs = document.querySelectorAll('.tab-btn');
        tabs.forEach(tab => {
            tab.addEventListener('click', () => {
                tabs.forEach(t => t.classList.remove('active'));
                tab.classList.add('active');
            });
        });
    </script>
</body>
</html>