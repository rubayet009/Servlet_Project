package com.login;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.bson.Document;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;

@WebServlet("/CourseStudentServlet")
public class CourseStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        String courseId = request.getParameter("courseId");
        
        if (username == null || !username.startsWith("teacher")) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        if (courseId == null || courseId.trim().isEmpty()) {
            response.sendRedirect("TeacherCourseServlet?error=Course ID is required");
            return;
        }
        
        try {
            // Get MongoDB connection
            MongoClient mongoClient = (MongoClient) request.getServletContext().getAttribute("MONGO_CLIENT");
            MongoDatabase database = mongoClient.getDatabase("university");
            
            // Get course details
            MongoCollection<Document> coursesCollection = database.getCollection("courses");
            Document course = coursesCollection.find(Filters.eq("courseId", courseId)).first();
            
            if (course == null) {
                response.sendRedirect("TeacherCourseServlet?error=Course not found");
                return;
            }
            
            // Verify teacher is assigned to this course
            MongoCollection<Document> enrollCollection = database.getCollection("enrollments");
            Document teacherEnrollment = enrollCollection.find(Filters.eq("username", username)).first();
            
            if (teacherEnrollment == null) {
                response.sendRedirect("TeacherCourseServlet?error=You are not assigned to any courses");
                return;
            }
            
            List<String> teacherCourses = (List<String>) teacherEnrollment.get("courses");
            if (teacherCourses == null || !teacherCourses.contains(courseId)) {
                response.sendRedirect("TeacherCourseServlet?error=You are not assigned to this course");
                return;
            }
            
            // Get students enrolled in this course
            List<Document> enrolledStudents = new ArrayList<>();
            MongoCursor<Document> cursor = enrollCollection.find(
                Filters.and(
                    Filters.eq("role", "STUDENT"),
                    Filters.in("courses", courseId)
                )
            ).iterator();
            
            try {
                while (cursor.hasNext()) {
                    Document student = cursor.next();
                    
                    // Create a student info document
                    Document studentInfo = new Document();
                    studentInfo.put("username", student.getString("username"));
                    
                    // Generate display name from username
                    String usernameStr = student.getString("username");
                    if (usernameStr.startsWith("student")) {
                        String number = usernameStr.replace("student", "");
                        studentInfo.put("name", "Student " + number);
                    } else {
                        studentInfo.put("name", usernameStr);
                    }
                    
                    studentInfo.put("email", usernameStr + "@university.edu");
                    enrolledStudents.add(studentInfo);
                }
            } finally {
                cursor.close();
            }
            
            // Set attributes for JSP
            request.setAttribute("course", course);
            request.setAttribute("enrolledStudents", enrolledStudents);
            request.setAttribute("totalStudents", enrolledStudents.size());
            
            // Forward to teacher dashboard (will show students view)
            request.getRequestDispatcher("teacherDashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("TeacherCourseServlet?error=Database error: " + e.getMessage());
        }
    }
}