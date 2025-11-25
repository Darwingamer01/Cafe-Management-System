<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    if (request.getAttribute("dailySales") == null) {
        response.sendRedirect("reports");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sales Reports - Cafe System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="dashboard">Cafe System</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item"><a class="nav-link" href="dashboard">Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link" href="menu">Menu Management</a></li>
                    <li class="nav-item"><a class="nav-link active" href="reports">Reports</a></li>
                </ul>
                <a href="login?action=logout" class="btn btn-outline-light btn-sm">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <h2>Sales Reports</h2>
        <hr>

        <div class="row mb-4">
            <div class="col-md-4">
                <div class="card text-white bg-success mb-3">
                    <div class="card-header">Total Revenue</div>
                    <div class="card-body">
                        <h3 class="card-title">$<fmt:formatNumber value="${totalRevenue}" minFractionDigits="2"/></h3>
                        <p class="card-text">Lifetime earnings.</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="card shadow">
            <div class="card-header bg-secondary text-white">
                <h3>Daily Sales</h3>
            </div>
            <div class="card-body">
                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Orders Count</th>
                            <th>Total Sales</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="day" items="${dailySales}">
                            <tr>
                                <td><fmt:formatDate value="${day.date}" pattern="yyyy-MM-dd"/></td>
                                <td>${day.count}</td>
                                <td>$<fmt:formatNumber value="${day.total}" minFractionDigits="2"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
