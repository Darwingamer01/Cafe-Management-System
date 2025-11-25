<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cafe.model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
                        <a class="nav-link active" href="dashboard">Dashboard</a>
                    </li>
                    <% if ("admin".equals(user.getRole())) { %>
                    <li class="nav-item">
                        <a class="nav-link" href="menu">Menu Management</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="reports">Reports</a>
                    </li>
                    <% } %>
                    <li class="nav-item">
                        <a class="nav-link" href="order">New Order</a>
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
                        <a href="order" class="btn btn-light">Go to Orders</a>
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
                        <a href="menu" class="btn btn-light">Manage Menu</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-white bg-info mb-3">
                    <div class="card-header">Insights</div>
                    <div class="card-body">
                        <h5 class="card-title">Sales Reports</h5>
                        <p class="card-text">View daily sales and analytics.</p>
                        <a href="reports" class="btn btn-light">View Reports</a>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
        <div class="row mt-4">
        <div class="col-12">
            <div class="card shadow">
                <div class="card-header bg-secondary text-white">
                    <h3>Recent Orders</h3>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty recentOrders}">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Order ID</th>
                                        <th>Date</th>
                                        <th>Total</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="order" items="${recentOrders}">
                                        <tr>
                                            <td>#<c:out value="${order.orderId}"/></td>
                                            <td><c:out value="${order.orderDate}"/></td>
                                            <td>$<c:out value="${order.grandTotal}"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${order.status == 'pending'}">
                                                        <span class="badge badge-pending">Pending</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 'completed'}">
                                                        <span class="badge badge-completed">Completed</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary"><c:out value="${order.status}"/></span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="billing?orderId=<c:out value='${order.orderId}'/>" class="btn btn-sm btn-outline-primary">View Bill</a>
                                                <c:if test="${order.status != 'completed'}">
                                                    <form action="order" method="post" style="display:inline;">
                                                        <input type="hidden" name="action" value="updateStatus">
                                                        <input type="hidden" name="source" value="dashboard">
                                                        <input type="hidden" name="orderId" value="<c:out value='${order.orderId}'/>">
                                                        <input type="hidden" name="status" value="completed">
                                                        <button type="submit" class="btn btn-sm btn-success">Mark Completed</button>
                                                    </form>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted">No recent orders found.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
