package db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnector {
    private static final String URL = "jdbc:mysql://localhost:3306/test";
    private static final String USER = "root";
    private static final String PASSWORD = "950205jmy";

    private static Connection connection;

    public static Connection getConnection(){

        try {
            // Incorporate mySQL driver
            Class.forName("com.mysql.jdbc.Driver").newInstance();

            connection = DriverManager.getConnection(URL, USER, PASSWORD);

            return connection;

        } catch (Exception e) {
            System.out.println("can't load mysql driver");
            System.out.println(e.toString());
            return null;
        }
    }
}
