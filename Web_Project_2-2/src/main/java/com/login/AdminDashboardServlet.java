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

@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        
        if (username == null || !username.startsWith("admin")) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            // Get MongoDB connection
            MongoClient mongoClient = (MongoClient) request.getServletContext().getAttribute("MONGO_CLIENT");
            MongoDatabase database = mongoClient.getDatabase("university");
            
            // Get all courses
            MongoCollection<Document> coursesCollection = database.getCollection("courses");
            List<Document> allCourses = new ArrayList<>();
            MongoCursor<Document> coursesCursor = coursesCollection.find().iterator();
            
            try {
                while (coursesCursor.hasNext()) {
                    allCourses.add(coursesCursor.next());
                }
            } finally {
                coursesCursor.close();
            }
            
            // Get all teachers
            MongoCollection<Document> usersCollection = database.getCollection("users");
            List<Document> allTeachers = new ArrayList<>();
            MongoCursor<Document> teachersCursor = usersCollection.find(
                Filters.eq("role", "TEACHER")
            ).iterator();
            
            try {
                while (teachersCursor.hasNext()) {
                    allTeachers.add(teachersCursor.next());
                }
            } finally {
                teachersCursor.close();
            }
            
            // Get enrollment stats
            MongoCollection<Document> enrollCollection = database.getCollection("enrollments");
            long totalStudents = enrollCollection.countDocuments(Filters.eq("role", "STUDENT"));
            long totalTeachers = enrollCollection.countDocuments(Filters.eq("role", "TEACHER"));
            
            // Set attributes for JSP
            request.setAttribute("username", username);
            request.setAttribute("allCourses", allCourses);
            request.setAttribute("allTeachers", allTeachers);
            request.setAttribute("totalStudents", totalStudents);
            request.setAttribute("totalTeachers", totalTeachers);
            
            // Forward to admin dashboard
            request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=Database error: " + e.getMessage());
        }
    }
}