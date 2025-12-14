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

@WebServlet("/StudentDashboardServlet")
public class StudentDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        
        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            // Get MongoDB connection
            MongoClient mongoClient = (MongoClient) request.getServletContext().getAttribute("MONGO_CLIENT");
            MongoDatabase database = mongoClient.getDatabase("university");
            
            // Get student's enrolled courses from enrollments collection
            MongoCollection<Document> enrollCollection = database.getCollection("enrollments");
            Document studentEnrollment = enrollCollection.find(Filters.eq("username", username)).first();
            
            List<String> enrolledCourseIds = new ArrayList<>();
            if (studentEnrollment != null) {
                enrolledCourseIds = (List<String>) studentEnrollment.get("courses");
            }
            
            // Get all available courses
            MongoCollection<Document> coursesCollection = database.getCollection("courses");
            List<Document> allCourses = new ArrayList<>();
            MongoCursor<Document> cursor = coursesCollection.find().iterator();
            
            try {
                while (cursor.hasNext()) {
                    allCourses.add(cursor.next());
                }
            } finally {
                cursor.close();
            }
            
            // Get details of enrolled courses
            List<Document> enrolledCourses = new ArrayList<>();
            for (String courseId : enrolledCourseIds) {
                Document course = coursesCollection.find(Filters.eq("courseId", courseId)).first();
                if (course != null) {
                    enrolledCourses.add(course);
                }
            }
            
            // Set attributes for JSP
            request.setAttribute("username", username);
            request.setAttribute("enrolledCourses", enrolledCourses);
            request.setAttribute("allCourses", allCourses);
            request.setAttribute("totalEnrolled", enrolledCourses.size());
            
            // Forward to student dashboard
            request.getRequestDispatcher("studentDashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=Database error: " + e.getMessage());
        }
    }
}