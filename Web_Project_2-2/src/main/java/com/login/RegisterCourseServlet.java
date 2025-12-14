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

@WebServlet("/RegisterCourseServlet")
public class RegisterCourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        String courseId = request.getParameter("courseId");
        
        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        if (courseId == null || courseId.trim().isEmpty()) {
            response.sendRedirect("StudentDashboardServlet?error=Course ID is required");
            return;
        }
        
        try {
            // Get MongoDB connection
            MongoClient mongoClient = (MongoClient) request.getServletContext().getAttribute("MONGO_CLIENT");
            MongoDatabase database = mongoClient.getDatabase("university");
            
            // Check if course exists
            MongoCollection<Document> coursesCollection = database.getCollection("courses");
            Document course = coursesCollection.find(Filters.eq("courseId", courseId)).first();
            
            if (course == null) {
                response.sendRedirect("StudentDashboardServlet?error=Course not found");
                return;
            }
            
            // Update student's enrollment
            MongoCollection<Document> enrollCollection = database.getCollection("enrollments");
            Document studentEnrollment = enrollCollection.find(Filters.eq("username", username)).first();
            
            if (studentEnrollment != null) {
                // Get current courses
                List<String> currentCourses = (List<String>) studentEnrollment.get("courses");
                if (currentCourses == null) {
                    currentCourses = new ArrayList<>();
                }
                
                // Check if already enrolled
                if (currentCourses.contains(courseId)) {
                    response.sendRedirect("StudentDashboardServlet?error=Already enrolled in this course");
                    return;
                }
                
                // Add new course
                currentCourses.add(courseId);
                enrollCollection.updateOne(
                    Filters.eq("username", username),
                    Updates.set("courses", currentCourses)
                );
            } else {
                // Create new enrollment document
                Document newEnrollment = new Document();
                newEnrollment.put("username", username);
                newEnrollment.put("role", "STUDENT");
                
                List<String> courses = new ArrayList<>();
                courses.add(courseId);
                newEnrollment.put("courses", courses);
                
                enrollCollection.insertOne(newEnrollment);
            }
            
            response.sendRedirect("StudentDashboardServlet?success=Successfully enrolled in " + courseId);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("StudentDashboardServlet?error=Registration failed: " + e.getMessage());
        }
    }
}