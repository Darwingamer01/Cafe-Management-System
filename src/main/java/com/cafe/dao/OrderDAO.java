package com.cafe.dao;

import com.cafe.model.Order;
import com.cafe.model.OrderItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public boolean createOrder(Order order, List<OrderItem> items) {
        String insertOrderSQL = "INSERT INTO orders (order_date, total_amount, tax_amount, grand_total, status, created_by) VALUES (?, ?, ?, ?, ?, ?)";
        String insertOrderItemSQL = "INSERT INTO order_items (order_id, item_id, quantity, item_price, subtotal) VALUES (?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement orderStmt = null;
        PreparedStatement itemStmt = null;
        ResultSet generatedKeys = null;

        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // 1. Insert Order
            orderStmt = conn.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS);
            orderStmt.setTimestamp(1, order.getOrderDate());
            orderStmt.setDouble(2, order.getTotalAmount());
            orderStmt.setDouble(3, order.getTaxAmount());
            orderStmt.setDouble(4, order.getGrandTotal());
            orderStmt.setString(5, order.getStatus());
            orderStmt.setInt(6, order.getCreatedBy());

            int affectedRows = orderStmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating order failed, no rows affected.");
            }

            generatedKeys = orderStmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                order.setOrderId(generatedKeys.getInt(1));
            } else {
                throw new SQLException("Creating order failed, no ID obtained.");
            }

            // 2. Insert Order Items
            itemStmt = conn.prepareStatement(insertOrderItemSQL);
            for (OrderItem item : items) {
                itemStmt.setInt(1, order.getOrderId());
                itemStmt.setInt(2, item.getItemId());
                itemStmt.setInt(3, item.getQuantity());
                itemStmt.setDouble(4, item.getItemPrice());
                itemStmt.setDouble(5, item.getSubtotal());
                itemStmt.addBatch();
            }
            itemStmt.executeBatch();

            conn.commit(); // Commit transaction
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback on error
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            try {
                if (generatedKeys != null)
                    generatedKeys.close();
                if (orderStmt != null)
                    orderStmt.close();
                if (itemStmt != null)
                    itemStmt.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public Order getOrder(int orderId) {
        String sql = "SELECT * FROM orders WHERE order_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(rs.getInt("order_id"));
                    order.setOrderDate(rs.getTimestamp("order_date"));
                    order.setTotalAmount(rs.getDouble("total_amount"));
                    order.setTaxAmount(rs.getDouble("tax_amount"));
                    order.setGrandTotal(rs.getDouble("grand_total"));
                    order.setStatus(rs.getString("status"));
                    order.setCreatedBy(rs.getInt("created_by"));
                    return order;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, m.item_name FROM order_items oi JOIN menu_items m ON oi.item_id = m.item_id WHERE oi.order_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setOrderItemId(rs.getInt("order_item_id"));
                    item.setOrderId(rs.getInt("order_id"));
                    item.setItemId(rs.getInt("item_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setItemPrice(rs.getDouble("item_price"));
                    item.setSubtotal(rs.getDouble("subtotal"));
                    item.setItemName(rs.getString("item_name"));
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE created_by = ? ORDER BY order_date DESC LIMIT 10";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(rs.getInt("order_id"));
                    order.setOrderDate(rs.getTimestamp("order_date"));
                    order.setTotalAmount(rs.getDouble("total_amount"));
                    order.setTaxAmount(rs.getDouble("tax_amount"));
                    order.setGrandTotal(rs.getDouble("grand_total"));
                    order.setStatus(rs.getString("status"));
                    order.setCreatedBy(rs.getInt("created_by"));
                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public List<java.util.Map<String, Object>> getDailySales() {
        List<java.util.Map<String, Object>> salesData = new ArrayList<>();
        String sql = "SELECT DATE(order_date) as sale_date, SUM(grand_total) as total_sales, COUNT(*) as order_count FROM orders WHERE status = 'completed' GROUP BY DATE(order_date) ORDER BY sale_date DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                java.util.Map<String, Object> row = new java.util.HashMap<>();
                row.put("date", rs.getDate("sale_date"));
                row.put("total", rs.getDouble("total_sales"));
                row.put("count", rs.getInt("order_count"));
                salesData.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return salesData;
    }

    public List<Order> getAllRecentOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY order_date DESC LIMIT 10";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                order.setOrderDate(rs.getTimestamp("order_date"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setTaxAmount(rs.getDouble("tax_amount"));
                order.setGrandTotal(rs.getDouble("grand_total"));
                order.setStatus(rs.getString("status"));
                order.setCreatedBy(rs.getInt("created_by"));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, orderId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
