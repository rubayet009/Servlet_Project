<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.bson.Document, java.util.List" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Dashboard - EduManage</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/teacherDashboard.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="logo">
                <i class="fas fa-chalkboard-teacher"></i>
                <span>EduManage Teacher</span>
            </div>
            <div class="user-info">
                <img src="https://ui-avatars.com/api/?name=<%= request.getAttribute("username") != null ? request.getAttribute("username") : "Teacher" %>&background=ffa726&color=1a1d21" alt="Teacher">
                <span><%= request.getAttribute("username") != null ? request.getAttribute("username") : "Teacher" %></span>
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
                    <%= request.getAttribute("totalCourses") != null ? request.getAttribute("totalCourses") : "0" %>
                </div>
                <div class="stat-label">Assigned Courses</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-user-graduate"></i>
                </div>
                <div class="stat-number">
                    <%= request.getAttribute("totalStudents") != null ? request.getAttribute("totalStudents") : "0" %>
                </div>
                <div class="stat-label">Total Students</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-chalkboard"></i>
                </div>
                <div class="stat-number">TEACHER</div>
                <div class="stat-label">Your Role</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-tasks"></i>
                </div>
                <div class="stat-number">2</div>
                <div class="stat-label">Management Tools</div>
            </div>
        </div>

        <% 
            Document course = (Document) request.getAttribute("course");
            if (course != null) {
                // Show students view
                List<Document> enrolledStudents = (List<Document>) request.getAttribute("enrolledStudents");
        %>
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">
                        <i class="fas fa-users"></i> Students in <%= course.getString("title") %>
                    </h2>
                    <a href="TeacherCourseServlet" class="back-btn">
                        <i class="fas fa-arrow-left"></i> Back to Courses
                    </a>
                </div>

                <div class="view-toggle">
                    <div class="toggle-btn active">Student List</div>
                    <div class="toggle-btn">Attendance</div>
                    <div class="toggle-btn">Grades</div>
                </div>

                <% if (enrolledStudents == null || enrolledStudents.isEmpty()) { %>
                    <div class="empty-state">
                        <i class="fas fa-user-graduate"></i>
                        <p>No students are enrolled in this course yet.</p>
                    </div>
                <% } else { %>
                    <div class="students-table-container">
                        <table class="students-table">
                            <thead>
                                <tr>
                                    <th>Student ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Document student : enrolledStudents) { 
                                    String studentUsername = student.getString("username");
                                    String studentName = student.getString("name");
                                    String studentEmail = student.getString("email");
                                %>
                                    <tr>
                                        <td><strong><%= studentUsername %></strong></td>
                                        <td><%= studentName %></td>
                                        <td><%= studentEmail %></td>
                                        <td>
                                            <button class="btn btn-primary">
                                                <i class="fas fa-eye"></i> View Profile
                                            </button>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        <% } else { 
            // Show courses view
            List<Document> teacherCourses = (List<Document>) request.getAttribute("teacherCourses");
        %>
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">
                        <i class="fas fa-book"></i> My Assigned Courses
                    </h2>
                </div>

                <% if (teacherCourses == null || teacherCourses.isEmpty()) { %>
                    <div class="empty-state">
                        <i class="fas fa-book-open"></i>
                        <p>You haven't been assigned to any courses yet.</p>
                        <p>Please contact administration to get assigned to courses.</p>
                    </div>
                <% } else { %>
                    <div class="courses-grid">
                        <% for (Document courseDoc : teacherCourses) { 
                            String courseId = courseDoc.getString("courseId");
                            String title = courseDoc.getString("title");
                            Integer credits = courseDoc.getInteger("credits");
                            String description = courseDoc.getString("description");
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
                                    </div>
                                    <a href="CourseStudentServlet?courseId=<%= courseId %>" class="btn btn-primary btn-block">
                                        <i class="fas fa-users"></i> View Students
                                    </a>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>

    <script>
    // Simple tab functionality for student view
    document.querySelectorAll('.toggle-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.toggle-btn').forEach(b => b.classList.remove('active'));
            this.classList.add('active');
        });
    });
    </script>
</body>
</html>