package com.login;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;

@WebListener
public class MongoContextListener implements ServletContextListener {
    private MongoClient mongoClient;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            Context initCtx = new InitialContext();
            // fetch value from context.xml
            String uri = (String) initCtx.lookup("java:comp/env/MONGODB_URI");
         // Create a connection to MongoDB using the connection string
            mongoClient = MongoClients.create(uri);
         // Store the connection in the application scope so all parts of the app can use it
            sce.getServletContext().setAttribute("MONGO_CLIENT", mongoClient);

            System.out.println("✅ Connected to MongoDB via context.xml");
        } catch (NamingException e) {
            throw new RuntimeException("❌ Failed to read MONGODB_URI from context.xml", e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (mongoClient != null) {
            mongoClient.close();
            System.out.println("✅ MongoDB connection closed");
        }
    }
}
