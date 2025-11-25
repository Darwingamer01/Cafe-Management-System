<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cafe.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Cafe Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">Cafe System</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="dashboard.jsp">Dashboard</a>
                    </li>
                    <% if ("admin".equals(user.getRole())) { %>
                    <li class="nav-item">
                        <a class="nav-link" href="menu-list.jsp">Menu Management</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="reports.jsp">Reports</a>
                    </li>
                    <% } %>
                    <li class="nav-item">
                        <a class="nav-link" href="order-form.jsp">New Order</a>
                    </li>
                </ul>
                <div class="d-flex align-items-center">
                    <span class="text-white me-3">Welcome, <%= user.getUsername() %> (<%= user.getRole() %>)</span>
                    <a href="login?action=logout" class="btn btn-outline-light btn-sm">Logout</a>
                </div>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <div class="col-md-12">
                <h2>Dashboard</h2>
                <hr>
            </div>
        </div>
        
        <div class="row mt-3">
            <div class="col-md-4">
                <div class="card text-white bg-success mb-3">
                    <div class="card-header">Quick Actions</div>
                    <div class="card-body">
                        <h5 class="card-title">New Order</h5>
                        <p class="card-text">Create a new customer order.</p>
                        <a href="order-form.jsp" class="btn btn-light">Go to Orders</a>
                    </div>
                </div>
            </div>
            
            <% if ("admin".equals(user.getRole())) { %>
            <div class="col-md-4">
                <div class="card text-white bg-primary mb-3">
                    <div class="card-header">Admin Actions</div>
                    <div class="card-body">
                        <h5 class="card-title">Manage Menu</h5>
                        <p class="card-text">Add, update or remove menu items.</p>
                        <a href="menu-list.jsp" class="btn btn-light">Manage Menu</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-white bg-info mb-3">
                    <div class="card-header">Insights</div>
                    <div class="card-body">
                        <h5 class="card-title">Sales Reports</h5>
                        <p class="card-text">View daily sales and analytics.</p>
                        <a href="reports.jsp" class="btn btn-light">View Reports</a>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
    </div>
</body>
</html>
