package com.login;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import org.mindrot.jbcrypt.BCrypt;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/Login")
public class Login extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        MongoClient mongoClient = (MongoClient) getServletContext().getAttribute("MONGO_CLIENT");
        MongoDatabase db = mongoClient.getDatabase("university"); // 👉 replace with your DB name
        MongoCollection<Document> users = db.getCollection("users");

        // find user by username
        Document user = users.find(new Document("username", username)).first();
        
       
        response.setContentType("text/plain");
     
        if (user != null) {
        	String storedPassword = user.getString("password");
        	System.out.print(storedPassword+" " +password);
        	if (storedPassword.equals(password)){
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            //request.getRequestDispatcher("videos.jsp").forward(request, response);
            String role=user.getString("role");
            switch (role) {
            case "ADMIN":
                response.sendRedirect("AdminDashboardServlet");
                break;
            case "TEACHER":
                response.sendRedirect("TeacherCourseServlet");
                break;
            case "STUDENT":
                response.sendRedirect("StudentDashboardServlet");
                break;
            default:
                response.sendRedirect("login.jsp");
                break;
        }  
        	}else {
        		response.getWriter().println( username+"'s PASSWORD IS WRONG");
        	}
        	
        } else {
            request.setAttribute("errorMessage", "Invalid username or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }


    }
}
