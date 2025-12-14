<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.bson.Document, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - EduManage</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/adminDashboard.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="logo">
                <i class="fas fa-graduation-cap"></i>
                <span>EduManage Admin</span>
            </div>
            <div class="user-info">
                <img src="https://ui-avatars.com/api/?name=<%= request.getAttribute("username") != null ? request.getAttribute("username") : "Admin" %>&background=ffa726&color=1a1d21" alt="Admin">
                <span><%= request.getAttribute("username") != null ? request.getAttribute("username") : "Admin" %></span>
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
                    <%= request.getAttribute("allCourses") != null ? ((List<?>) request.getAttribute("allCourses")).size() : "0" %>
                </div>
                <div class="stat-label">Total Courses</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-chalkboard-teacher"></i>
                </div>
                <div class="stat-number">
                    <%= request.getAttribute("totalTeachers") != null ? request.getAttribute("totalTeachers") : "0" %>
                </div>
                <div class="stat-label">Teachers</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-user-graduate"></i>
                </div>
                <div class="stat-number">
                    <%= request.getAttribute("totalStudents") != null ? request.getAttribute("totalStudents") : "0" %>
                </div>
                <div class="stat-label">Students</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-tasks"></i>
                </div>
                <div class="stat-number">3</div>
                <div class="stat-label">Management Tools</div>
            </div>
        </div>

        <div class="tabs">
            <div class="tab active" onclick="showTab('courses-tab')">Courses Management</div>
            <div class="tab" onclick="showTab('teachers-tab')">Teacher Assignment</div>
        </div>

        <div class="dashboard-grid">
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Add New Course</h2>
                </div>
                <form action="AddCourseServlet" method="post">
                    <div class="form-group">
                        <label class="form-label">Course ID</label>
                        <input type="text" name="courseId" class="form-input" required placeholder="e.g., CSE101">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Course Title</label>
                        <input type="text" name="title" class="form-input" required placeholder="e.g., Introduction to Programming">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Credits</label>
                        <input type="number" name="credits" class="form-input" placeholder="e.g., 3">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Description</label>
                        <textarea name="description" class="form-input" rows="3" placeholder="Course description..."></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block">
                        <i class="fas fa-plus-circle"></i> Add Course
                    </button>
                </form>
            </div>

            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Assign Teacher to Course</h2>
                </div>
                <form action="AssignTeacherServlet" method="post">
                    <div class="form-group">
                        <label class="form-label">Select Teacher</label>
                        <select name="teacherUsername" class="form-input" required>
                            <option value="">Choose a teacher...</option>
                            <% 
                                List<Document> allTeachers = (List<Document>) request.getAttribute("allTeachers");
                                if (allTeachers != null) {
                                    for (Document teacher : allTeachers) {
                                        String teacherUsername = teacher.getString("username");
                                        String teacherName = teacher.getString("name");
                                        if (teacherName == null) teacherName = teacherUsername;
                            %>
                                <option value="<%= teacherUsername %>"><%= teacherName %> (<%= teacherUsername %>)</option>
                            <% 
                                    }
                                } 
                            %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Select Course</label>
                        <select name="courseId" class="form-input" required>
                            <option value="">Choose a course...</option>
                            <% 
                                List<Document> allCourses = (List<Document>) request.getAttribute("allCourses");
                                if (allCourses != null) {
                                    for (Document course : allCourses) {
                                        String courseId = course.getString("courseId");
                                        String title = course.getString("title");
                            %>
                                <option value="<%= courseId %>"><%= courseId %> - <%= title %></option>
                            <% 
                                    }
                                } 
                            %>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block">
                        <i class="fas fa-link"></i> Assign Teacher
                    </button>
                </form>
            </div>
        </div>

        <div class="card" style="margin-top: 30px;">
            <div class="card-header">
                <h2 class="card-title">All Courses</h2>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Course ID</th>
                            <th>Title</th>
                            <th>Credits</th>
                            <th>Description</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            if (allCourses != null && !allCourses.isEmpty()) {
                                for (Document course : allCourses) {
                                    String courseId = course.getString("courseId");
                                    String title = course.getString("title");
                                    Integer credits = course.getInteger("credits");
                                    String description = course.getString("description");
                                    if (description == null) description = "No description";
                        %>
                        <tr>
                            <td><strong><%= courseId %></strong></td>
                            <td><%= title %></td>
                            <td><%= credits != null ? credits : "N/A" %></td>
                            <td><%= description.length() > 50 ? description.substring(0, 50) + "..." : description %></td>
                            <td><span class="status-badge status-active">Active</span></td>
                        </tr>
                        <% 
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="5" style="text-align: center; color: var(--text-secondary);">
                                No courses found. Add your first course above.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
    function showTab(tabId) {
        // For future tab functionality
        console.log('Switching to tab:', tabId);
    }
    </script>
</body>
</html>