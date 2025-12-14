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
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;

@WebServlet("/AssignTeacherServlet")
public class AssignTeacherServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        
        if (username == null || !username.startsWith("admin")) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Get form parameters
        String teacherUsername = request.getParameter("teacherUsername");
        String courseId = request.getParameter("courseId");
        
        if (teacherUsername == null || courseId == null || 
            teacherUsername.trim().isEmpty() || courseId.trim().isEmpty()) {
            response.sendRedirect("AdminDashboardServlet?error=Teacher and Course are required");
            return;
        }
        
        try {
            // Get MongoDB connection
            MongoClient mongoClient = (MongoClient) request.getServletContext().getAttribute("MONGO_CLIENT");
            MongoDatabase database = mongoClient.getDatabase("university");
            
            // Check if teacher exists
            MongoCollection<Document> usersCollection = database.getCollection("users");
            Document teacher = usersCollection.find(
                Filters.and(
                    Filters.eq("username", teacherUsername),
                    Filters.eq("role", "TEACHER")
                )
            ).first();
            
            if (teacher == null) {
                response.sendRedirect("AdminDashboardServlet?error=Teacher not found");
                return;
            }
            
            // Check if course exists
            MongoCollection<Document> coursesCollection = database.getCollection("courses");
            Document course = coursesCollection.find(
                Filters.eq("courseId", courseId)
            ).first();
            
            if (course == null) {
                response.sendRedirect("AdminDashboardServlet?error=Course not found");
                return;
            }
            
            // Update teacher's enrollment
            MongoCollection<Document> enrollCollection = database.getCollection("enrollments");
            Document teacherEnrollment = enrollCollection.find(
                Filters.eq("username", teacherUsername)
            ).first();
            
            if (teacherEnrollment != null) {
                // Get current courses
                List<String> currentCourses = (List<String>) teacherEnrollment.get("courses");
                if (currentCourses == null) {
                    currentCourses = new ArrayList<>();
                }
                
                // Check if already assigned
                if (currentCourses.contains(courseId)) {
                    response.sendRedirect("AdminDashboardServlet?error=Teacher is already assigned to this course");
                    return;
                }
                
                // Add new course
                currentCourses.add(courseId);
                enrollCollection.updateOne(
                    Filters.eq("username", teacherUsername),
                    Updates.set("courses", currentCourses)
                );
            } else {
                // Create new enrollment document
                Document newEnrollment = new Document();
                newEnrollment.put("username", teacherUsername);
                newEnrollment.put("role", "TEACHER");
                
                List<String> courses = new ArrayList<>();
                courses.add(courseId);
                newEnrollment.put("courses", courses);
                
                enrollCollection.insertOne(newEnrollment);
            }
            
            response.sendRedirect("AdminDashboardServlet?success=Teacher assigned successfully");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AdminDashboardServlet?error=Failed to assign teacher: " + e.getMessage());
        }
    }
}