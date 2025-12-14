package com.login;

import java.io.IOException;
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

@WebServlet("/AddCourseServlet")
public class AddCourseServlet extends HttpServlet {
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
        String courseId = request.getParameter("courseId");
        String title = request.getParameter("title");
        String credits = request.getParameter("credits");
        String description = request.getParameter("description");
        
        if (courseId == null || title == null || courseId.trim().isEmpty() || title.trim().isEmpty()) {
            response.sendRedirect("AdminDashboardServlet?error=Course ID and Title are required");
            return;
        }
        
        try {
            // Get MongoDB connection
            MongoClient mongoClient = (MongoClient) request.getServletContext().getAttribute("MONGO_CLIENT");
            MongoDatabase database = mongoClient.getDatabase("university");
            
            // Check if course already exists
            MongoCollection<Document> coursesCollection = database.getCollection("courses");
            Document existingCourse = coursesCollection.find(
                new Document("courseId", courseId)
            ).first();
            
            if (existingCourse != null) {
                response.sendRedirect("AdminDashboardServlet?error=Course ID already exists");
                return;
            }
            
            // Create new course document
            Document newCourse = new Document();
            newCourse.put("courseId", courseId);
            newCourse.put("title", title);
            
            if (credits != null && !credits.trim().isEmpty()) {
                newCourse.put("credits", Integer.parseInt(credits));
            }
            
            if (description != null && !description.trim().isEmpty()) {
                newCourse.put("description", description);
            }
            
            // Insert the new course
            coursesCollection.insertOne(newCourse);
            
            response.sendRedirect("AdminDashboardServlet?success=Course added successfully");
            
        } catch (NumberFormatException e) {
            response.sendRedirect("AdminDashboardServlet?error=Credits must be a number");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AdminDashboardServlet?error=Failed to add course: " + e.getMessage());
        }
    }
}