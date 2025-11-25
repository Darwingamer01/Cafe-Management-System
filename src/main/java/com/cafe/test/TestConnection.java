package com.cafe.test;

import com.cafe.dao.DatabaseConnection;
import java.sql.Connection;
import java.sql.SQLException;

public class TestConnection {
    public static void main(String[] args) {
        System.out.println("Testing Database Connection...");
        try (Connection conn = DatabaseConnection.getConnection()) {
            if (conn != null) {
                System.out.println("SUCCESS: Connected to the database!");
            } else {
                System.out.println("FAILURE: Connection is null.");
            }
        } catch (SQLException e) {
            System.out.println("FAILURE: Could not connect to database.");
            System.out.println("Error: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("FAILURE: Unexpected error.");
            e.printStackTrace();
        }
    }
}
