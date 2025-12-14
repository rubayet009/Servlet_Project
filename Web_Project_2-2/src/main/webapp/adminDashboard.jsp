<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.bson.Document, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | EduManage</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" href="css/adminDashboard.css">
</head>
<body>

    <header class="main-header">
        <div class="logo-area">
            <div class="logo-icon">
                <i class="fas fa-shield-alt"></i>
            </div>
            <span class="logo-text">EduManage <span>Admin</span></span>
        </div>
        <div class="user-profile">
            <div class="profile-info">
                <span class="user-name"><%= request.getAttribute("username") != null ? request.getAttribute("username") : "Administrator" %></span>
                <span class="user-role">System Admin</span>
            </div>
            <img src="https://ui-avatars.com/api/?name=<%= request.getAttribute("username") != null ? request.getAttribute("username") : "Admin" %>&background=d32f2f&color=ffffff&bold=true" alt="Admin">
            
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
                    <i class="fas fa-book"></i>
                </div>
                <div class="stat-details">
                    <h3><%= request.getAttribute("allCourses") != null ? ((List<?>) request.getAttribute("allCourses")).size() : "0" %></h3>
                    <p>Total Courses</p>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon info">
                    <i class="fas fa-chalkboard-teacher"></i>
                </div>
                <div class="stat-details">
                    <h3><%= request.getAttribute("totalTeachers") != null ? request.getAttribute("totalTeachers") : "0" %></h3>
                    <p>Total Teachers</p>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon success">
                    <i class="fas fa-user-graduate"></i>
                </div>
                <div class="stat-details">
                    <h3><%= request.getAttribute("totalStudents") != null ? request.getAttribute("totalStudents") : "0" %></h3>
                    <p>Active Students</p>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon warning">
                    <i class="fas fa-cogs"></i>
                </div>
                <div class="stat-details">
                    <h3>Admin</h3>
                    <p>Control Panel</p>
                </div>
            </div>
        </div>

        <div class="nav-tabs-container">
            <button class="nav-tab active" onclick="switchTab('courses-manage', this)">
                <i class="fas fa-layer-group"></i> Course Management
            </button>
            <button class="nav-tab" onclick="switchTab('teacher-assign', this)">
                <i class="fas fa-user-tag"></i> Teacher Assignments
            </button>
        </div>

        <div id="courses-manage" class="tab-content active fade-in-up">
            <div class="split-layout">
                <div class="content-card form-card">
                    <div class="card-header">
                        <h2>Add New Course</h2>
                    </div>
                    <form action="AddCourseServlet" method="post">
                        <div class="form-group">
                            <label class="form-label">Course ID</label>
                            <div class="input-wrapper">
                                <i class="fas fa-fingerprint"></i>
                                <input type="text" name="courseId" class="form-input" required placeholder="e.g., CSE101">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Course Title</label>
                            <div class="input-wrapper">
                                <i class="fas fa-heading"></i>
                                <input type="text" name="title" class="form-input" required placeholder="e.g., Intro to Java">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Credits</label>
                            <div class="input-wrapper">
                                <i class="fas fa-star"></i>
                                <input type="number" name="credits" class="form-input" placeholder="e.g., 3.0" step="0.5">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Description</label>
                            <textarea name="description" class="form-input textarea" rows="3" placeholder="Brief course overview..."></textarea>
                        </div>
                        <button type="submit" class="btn-primary full-width">
                            <i class="fas fa-plus-circle"></i> Create Course
                        </button>
                    </form>
                </div>

                <div class="content-card table-card">
                    <div class="card-header">
                        <h2>Existing Courses</h2>
                    </div>
                    <div class="table-responsive">
                        <table class="styled-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Title</th>
                                    <th>Credits</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    List<Document> courseList = (List<Document>) request.getAttribute("allCourses");
                                    if (courseList != null && !courseList.isEmpty()) {
                                        for (Document course : courseList) {
                                            String desc = course.getString("description");
                                            if (desc == null) desc = "";
                                %>
                                <tr>
                                    <td class="id-col"><%= course.getString("courseId") %></td>
                                    <td style="font-weight:600;"><%= course.getString("title") %></td>
                                    <td><%= course.getInteger("credits") %></td>
                                    <td><span class="status-badge active">Active</span></td>
                                </tr>
                                <% 
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="4" style="text-align:center; padding: 20px;">No courses found.</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div id="teacher-assign" class="tab-content fade-in-up">
            <div class="content-card small-width">
                <div class="card-header">
                    <h2>Assign Instructor</h2>
                    <p style="color:var(--text-secondary); font-size:0.9rem;">Link a faculty member to a specific course.</p>
                </div>
                
                <form action="AssignTeacherServlet" method="post">
                    <div class="form-group">
                        <label class="form-label">Select Faculty</label>
                        <div class="select-wrapper">
                            <select name="teacherUsername" class="form-input" required>
                                <option value="" disabled selected>Choose a teacher...</option>
                                <% 
                                    List<Document> allTeachers = (List<Document>) request.getAttribute("allTeachers");
                                    if (allTeachers != null) {
                                        for (Document teacher : allTeachers) {
                                            String tName = teacher.getString("name");
                                            if (tName == null) tName = teacher.getString("username");
                                %>
                                    <option value="<%= teacher.getString("username") %>"><%= tName %></option>
                                <% 
                                        }
                                    } 
                                %>
                            </select>
                            <i class="fas fa-chevron-down select-arrow"></i>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Select Course</label>
                        <div class="select-wrapper">
                            <select name="courseId" class="form-input" required>
                                <option value="" disabled selected>Choose a course...</option>
                                <% 
                                    if (courseList != null) {
                                        for (Document course : courseList) {
                                %>
                                    <option value="<%= course.getString("courseId") %>">
                                        [<%= course.getString("courseId") %>] <%= course.getString("title") %>
                                    </option>
                                <% 
                                        }
                                    } 
                                %>
                            </select>
                            <i class="fas fa-chevron-down select-arrow"></i>
                        </div>
                    </div>

                    <button type="submit" class="btn-primary full-width">
                        <i class="fas fa-link"></i> Confirm Assignment
                    </button>
                </form>
            </div>
        </div>

    </div>

    <script>
        function switchTab(tabId, btnElement) {
            // Hide all tabs
            document.querySelectorAll('.tab-content').forEach(content => {
                content.classList.remove('active');
            });
            // Reset buttons
            document.querySelectorAll('.nav-tab').forEach(btn => {
                btn.classList.remove('active');
            });
            // Activate selected
            document.getElementById(tabId).classList.add('active');
            btnElement.classList.add('active');
        }
    </script>
</body>
</html>