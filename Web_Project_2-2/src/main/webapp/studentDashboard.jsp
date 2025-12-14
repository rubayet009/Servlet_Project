<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.bson.Document, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - EduManage</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/studentDashboard.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="logo">
                <i class="fas fa-graduation-cap"></i>
                <span>EduManage Student</span>
            </div>
            <div class="user-info">
                <img src="https://ui-avatars.com/api/?name=<%= request.getAttribute("username") != null ? request.getAttribute("username") : "Student" %>&background=ffa726&color=1a1d21" alt="Student">
                <span><%= request.getAttribute("username") != null ? request.getAttribute("username") : "Student" %></span>
                <form action="Logout" method="post" class="logout-form">
                    <button type="submit" class="logout-btn">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </button>
                </form>
            </div>
        </div>

        <% 
            String error = request.getParameter("error");
            if (error != null) {
        %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> <%= error %>
            </div>
        <% } %>

        <% 
            String success = request.getParameter("success");
            if (success != null) {
        %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> <%= success %>
            </div>
        <% } %>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-book"></i>
                </div>
                <div class="stat-number">
                    <%= request.getAttribute("totalEnrolled") != null ? request.getAttribute("totalEnrolled") : "0" %>
                </div>
                <div class="stat-label">Enrolled Courses</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-tasks"></i>
                </div>
                <div class="stat-number">
                    <%= request.getAttribute("allCourses") != null ? ((List<?>) request.getAttribute("allCourses")).size() : "0" %>
                </div>
                <div class="stat-label">Available Courses</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-user-graduate"></i>
                </div>
                <div class="stat-number">STUDENT</div>
                <div class="stat-label">Your Role</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-rocket"></i>
                </div>
                <div class="stat-number">2</div>
                <div class="stat-label">Quick Actions</div>
            </div>
        </div>

        <div class="tabs">
            <div class="tab active" onclick="showTab('my-courses')">My Courses</div>
            <div class="tab" onclick="showTab('register-courses')">Register New Course</div>
        </div>

        <div id="my-courses" class="tab-content active">
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">My Enrolled Courses</h2>
                </div>
                
                <% 
                    List<Document> enrolledCourses = (List<Document>) request.getAttribute("enrolledCourses");
                    if (enrolledCourses == null || enrolledCourses.isEmpty()) { 
                %>
                    <div class="empty-state">
                        <i class="fas fa-book-open"></i>
                        <p>You haven't enrolled in any courses yet.</p>
                        <button class="btn btn-primary" onclick="showTab('register-courses')">
                            <i class="fas fa-plus"></i> Browse Courses
                        </button>
                    </div>
                <% } else { %>
                    <div class="courses-grid">
                        <% for (Document course : enrolledCourses) { 
                            String courseId = course.getString("courseId");
                            String title = course.getString("title");
                            Integer credits = course.getInteger("credits");
                            String description = course.getString("description");
                            if (credits == null) credits = 0;
                            if (description == null) description = "No description available";
                        %>
                            <div class="course-card">
                                <div class="course-header">
                                    <h3><%= title %></h3>
                                    <div class="course-id"><%= courseId %></div>
                                </div>
                                <div class="course-body">
                                    <div class="course-info">
                                        <div>
                                            <i class="fas fa-graduation-cap"></i>
                                            <span><strong>Credits:</strong> <%= credits %></span>
                                        </div>
                                        <div>
                                            <i class="fas fa-align-left"></i>
                                            <span><%= description.length() > 100 ? description.substring(0, 100) + "..." : description %></span>
                                        </div>
                                        <div>
                                            <i class="fas fa-check-circle"></i>
                                            <span>Enrollment Status: <strong>Registered</strong></span>
                                        </div>
                                    </div>
                                    <button class="btn btn-success btn-block" disabled>
                                        <i class="fas fa-check"></i> Already Enrolled
                                    </button>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
        </div>

        <div id="register-courses" class="tab-content">
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Available Courses</h2>
                    <span class="card-action" onclick="showTab('my-courses')">
                        <i class="fas fa-arrow-left"></i> Back to My Courses
                    </span>
                </div>
                
                <% 
                    List<Document> allCourses = (List<Document>) request.getAttribute("allCourses");
                    if (allCourses == null || allCourses.isEmpty()) { 
                %>
                    <div class="empty-state">
                        <i class="fas fa-exclamation-circle"></i>
                        <p>No courses available for registration at this time.</p>
                    </div>
                <% } else { %>
                    <div class="courses-grid">
                        <% for (Document course : allCourses) { 
                            String courseId = course.getString("courseId");
                            String title = course.getString("title");
                            Integer credits = course.getInteger("credits");
                            String description = course.getString("description");
                            if (credits == null) credits = 0;
                            if (description == null) description = "No description available";
                            
                            // Check if already enrolled
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
                                <div class="course-header">
                                    <h3><%= title %></h3>
                                    <div class="course-id"><%= courseId %></div>
                                </div>
                                <div class="course-body">
                                    <div class="course-info">
                                        <div>
                                            <i class="fas fa-graduation-cap"></i>
                                            <span><strong>Credits:</strong> <%= credits %></span>
                                        </div>
                                        <div>
                                            <i class="fas fa-align-left"></i>
                                            <span><%= description.length() > 100 ? description.substring(0, 100) + "..." : description %></span>
                                        </div>
                                    </div>
                                    <% if (isEnrolled) { %>
                                        <button class="btn btn-disabled btn-block" disabled>
                                            <i class="fas fa-check"></i> Already Enrolled
                                        </button>
                                    <% } else { %>
                                        <form action="RegisterCourseServlet" method="post">
                                            <input type="hidden" name="courseId" value="<%= courseId %>">
                                            <button type="submit" class="btn btn-primary btn-block">
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
    </div>

    <script>
    function showTab(tabId) {
        // Hide all tab contents
        document.querySelectorAll('.tab-content').forEach(tab => {
            tab.classList.remove('active');
        });
        
        // Show selected tab content
        document.getElementById(tabId).classList.add('active');
        
        // Update tab navigation
        document.querySelectorAll('.tab').forEach(tab => {
            tab.classList.remove('active');
        });
        
        // Find and activate the clicked tab
        const tabs = document.querySelectorAll('.tab');
        for (let tab of tabs) {
            if (tab.textContent.includes(tabId.replace('-', ' '))) {
                tab.classList.add('active');
                break;
            }
        }
    }
    </script>
</body>
</html>