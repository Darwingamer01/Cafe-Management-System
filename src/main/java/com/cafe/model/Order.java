package com.cafe.model;

import java.sql.Timestamp;

public class Order {
    private int orderId;
    private Timestamp orderDate;
    private double totalAmount;
    private double taxAmount;
    private double grandTotal;
    private String status;
    private int createdBy;

    public Order() {
    }

    public Order(int orderId, Timestamp orderDate, double totalAmount, double taxAmount, double grandTotal,
            String status, int createdBy) {
        this.orderId = orderId;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.taxAmount = taxAmount;
        this.grandTotal = grandTotal;
        this.status = status;
        this.createdBy = createdBy;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public double getTaxAmount() {
        return taxAmount;
    }

    public void setTaxAmount(double taxAmount) {
        this.taxAmount = taxAmount;
    }

    public double getGrandTotal() {
        return grandTotal;
    }

    public void setGrandTotal(double grandTotal) {
        this.grandTotal = grandTotal;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }
}
