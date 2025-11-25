<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    if (request.getAttribute("listMenuItems") == null) {
        response.sendRedirect("menu");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Menu Management - Cafe System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="dashboard.jsp">Cafe System</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item"><a class="nav-link" href="dashboard">Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link active" href="menu">Menu Management</a></li>
                    <li class="nav-item"><a class="nav-link" href="reports">Reports</a></li>
                </ul>
                <a href="login?action=logout" class="btn btn-outline-light btn-sm">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2>Menu Items</h2>
            <a href="menu?action=new" class="btn btn-primary">Add New Item</a>
        </div>
        
        <div class="card shadow">
            <div class="card-body">
                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Available</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${listMenuItems}">
                            <tr>
                                <td><c:out value="${item.itemId}" /></td>
                                <td><c:out value="${item.itemName}" /></td>
                                <td><c:out value="${item.category}" /></td>
                                <td>$<c:out value="${item.price}" /></td>
                                <td>
                                    <c:if test="${item.available}">
                                        <span class="badge bg-success">Yes</span>
                                    </c:if>
                                    <c:if test="${!item.available}">
                                        <span class="badge bg-danger">No</span>
                                    </c:if>
                                </td>
                                <td>
                                    <a href="menu?action=edit&id=<c:out value='${item.itemId}' />" class="btn btn-sm btn-warning">Edit</a>
                                    <a href="menu?action=delete&id=<c:out value='${item.itemId}' />" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to delete this item?');">Delete</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
