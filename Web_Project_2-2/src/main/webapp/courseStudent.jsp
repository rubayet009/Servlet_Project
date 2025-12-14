<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.bson.Document, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Students Enrolled in Course</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/teacherDashboard.css">
    <style>
        .back-btn {
            display: inline-flex;
            align-items: center;
            margin-bottom: 20px;
            padding: 10px 15px;
            background: linear-gradient(90deg, #FFA000, #FF6F00);
            color: white;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s;
        }

        .back-btn:hover {
            background: black;
            color: white;
        }

        .back-btn i {
            margin-right: 8px;
        }

        .students-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            margin-top: 20px;
        }

        .students-table th, .students-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .students-table th {
            background: linear-gradient(90deg, #FFA000, #FF6F00);
            color: white;
        }

        .students-table tr:hover {
            background: #f9f9f9;
        }
        
        .course-info-box {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        
        .course-info-box h3 {
            color: #6a11cb;
            margin-bottom: 15px;
        }
        
        .course-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        
        .course-detail-item {
            display: flex;
            flex-direction: column;
        }
        
        .course-detail-label {
            font-weight: bold;
            color: #666;
            font-size: 0.9em;
            margin-bottom: 5px;
        }
        
        .course-detail-value {
            font-size: 1.1em;
            color: #333;
        }
        
        .nav-item a {
            color: inherit;
            text-decoration: none;
            display: flex;
            align-items: center;
            width: 100%;
        }
        
        .nav-item a i {
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="logo">SUST COURSE DETAILS FOR TEACHERS</div>
            <div class="user-info">
                <img src="https://ui-avatars.com/api/?name=<%= session.getAttribute("username") != null ? session.getAttribute("username") : "Teacher" %>&background=random" alt="Teacher">
                <span id="teacher-name">
                    <% if (session.getAttribute("username") != null) { %>
                        <%= session.getAttribute("username") %>
                    <% } else { %>
                        Teacher
                    <% } %>
                </span>
            </div>
        </div>
        
        <div class="main-content">
            <div class="sidebar">
                <div class="welcome-box">
                    <h3>Welcome Back!</h3>
                    <p id="course-count">
                        <% 
                            List<Document> teacherCourses = (List<Document>) session.getAttribute("teacherCourses");
                            if (teacherCourses != null) {
                        %>
                            You have <%= teacherCourses.size() %> active courses this semester
                        <% } else { %>
                            Loading your courses...
                        <% } %>
                    </p>
                </div>
                
                <div class="nav-item">
                    <i class="fas fa-home"></i>
                    <a href="teacherDashboard.jsp">Dashboard</a>
                </div>
                <div class="nav-item active">
                    <i class="fas fa-book"></i>
                    <span>My Courses</span>
                </div>
                <div class="nav-item">
                    <i class="fas fa-calendar"></i>
                    <span>Schedule</span>
                </div>
                <div class="nav-item">
                    <i class="fas fa-envelope"></i>
                    <span>Messages</span>
                </div>
                <div class="nav-item">
                    <i class="fas fa-cog"></i>
                    <span>Settings</span>
                </div>
                <form action="Logout" method="post">
                    <button type="submit" class="nav-item logout-btn">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Logout</span>
                    </button>
                 </form>
            </div>
            
            <div class="content">
                <a href="teacherDashboard.jsp" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
                
                <% 
                    Document course = (Document) request.getAttribute("course");
                    // Declare enrolledStudents variable here so it's accessible throughout the page
                    List<Document> enrolledStudents = (List<Document>) request.getAttribute("enrolledStudents");
                    int studentCount = (enrolledStudents != null) ? enrolledStudents.size() : 0;
                    
                    if (course != null) {
                %>
                    <div class="course-info-box">
                        <h3>Course Information</h3>
                        <div class="course-details">
                            <div class="course-detail-item">
                                <span class="course-detail-label">Course ID</span>
                                <span class="course-detail-value"><%= course.getString("courseId") %></span>
                            </div>
                            <div class="course-detail-item">
                                <span class="course-detail-label">Course Title</span>
                                <span class="course-detail-value"><%= course.getString("title") %></span>
                            </div>
                            <div class="course-detail-item">
                                <span class="course-detail-label">Credits</span>
                                <span class="course-detail-value"><%= course.getInteger("credits", 0) %></span>
                            </div>
                            <div class="course-detail-item">
                                <span class="course-detail-label">Enrolled Students</span>
                                <span class="course-detail-value"><%= studentCount %></span>
                            </div>
                        </div>
                    </div>
                <% } %>
                
                <h2 class="page-title">Enrolled Students</h2>
                
                <% 
                    String error = request.getParameter("error");
                    if (error != null) {
                %>
                    <div class="error">
                        <i class="fas fa-exclamation-circle"></i> <%= error %>
                    </div>
                <% } %>
                
                <div class="db-info">
                    <i class="fas fa-database"></i> Connected to MongoDB Atlas
                </div>
                
                <% 
                    // Now we can use the enrolledStudents variable that was declared earlier
                    if (enrolledStudents == null || enrolledStudents.isEmpty()) { 
                %>
                    <div class="info">
                        <i class="fas fa-info-circle"></i> No students are enrolled in this course yet.
                    </div>
                <% } else { %>
                    <table class="students-table">
                        <thead>
                            <tr>
                                <th>Student ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Department</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Document student : enrolledStudents) { 
                                String username = student.getString("username");
                                String name = student.getString("name");
                                String email = student.getString("email");
                                String department = student.getString("department");
                                
                                if (name == null) name = username;
                                if (email == null) email = "N/A";
                                if (department == null) department = "N/A";
                            %>
                                <tr>
                                    <td><%= username %></td>
                                    <td><%= name %></td>
                                    <td><%= email %></td>
                                    <td><%= department %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } %>
            </div>
        </div>
        
        <div class="footer">
            <p>© 2023 EduManage - Teacher Portal. All rights reserved.</p>
        </div>
    </div>
</body>
</html>