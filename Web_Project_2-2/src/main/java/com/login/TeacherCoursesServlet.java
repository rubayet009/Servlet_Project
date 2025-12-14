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

@WebServlet("/TeacherCourseServlet")
public class TeacherCoursesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        
        if (username == null || !username.startsWith("teacher")) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            // Get MongoDB connection
            MongoClient mongoClient = (MongoClient) request.getServletContext().getAttribute("MONGO_CLIENT");
            MongoDatabase database = mongoClient.getDatabase("university");
            
            // Get teacher's courses from enrollments collection
            MongoCollection<Document> enrollCollection = database.getCollection("enrollments");
            Document teacherEnrollment = enrollCollection.find(Filters.eq("username", username)).first();
            
            List<String> teacherCourseIds = new ArrayList<>();
            if (teacherEnrollment != null) {
                teacherCourseIds = (List<String>) teacherEnrollment.get("courses");
            }
            
            // Get course details for each course ID
            MongoCollection<Document> coursesCollection = database.getCollection("courses");
            List<Document> teacherCourses = new ArrayList<>();
            
            for (String courseId : teacherCourseIds) {
                Document course = coursesCollection.find(Filters.eq("courseId", courseId)).first();
                if (course != null) {
                    teacherCourses.add(course);
                }
            }
            
            // Set attributes for JSP
            request.setAttribute("username", username);
            request.setAttribute("teacherCourses", teacherCourses);
            request.setAttribute("totalCourses", teacherCourses.size());
            
            // Forward to teacher dashboard
            request.getRequestDispatcher("teacherDashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=Database error: " + e.getMessage());
        }
    }
}