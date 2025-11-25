<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><c:if test="${menuItem != null}">Edit Item</c:if><c:if test="${menuItem == null}">New Item</c:if> - Cafe System</title>
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
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h3>
                            <c:if test="${menuItem != null}">Edit Menu Item</c:if>
                            <c:if test="${menuItem == null}">Add New Menu Item</c:if>
                        </h3>
                    </div>
                    <div class="card-body">
                        <% 
                            String errorMessage = (String) request.getAttribute("errorMessage");
                            if (errorMessage != null) {
                        %>
                            <div class="alert alert-danger" role="alert">
                                <%= errorMessage %>
                            </div>
                        <% } %>
                        <form action="menu" method="post">
                            <c:if test="${menuItem != null}">
                                <input type="hidden" name="action" value="update" />
                                <input type="hidden" name="id" value="<c:out value='${menuItem.itemId}' />" />
                            </c:if>
                            <c:if test="${menuItem == null}">
                                <input type="hidden" name="action" value="insert" />
                            </c:if>

                            <div class="mb-3">
                                <label for="name" class="form-label">Item Name</label>
                                <input type="text" class="form-control" id="name" name="name" value="<c:out value='${menuItem.itemName}' />" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="category" class="form-label">Category</label>
                                <select class="form-select" id="category" name="category" required>
                                    <option value="Beverage" <c:if test="${menuItem.category == 'Beverage'}">selected</c:if>>Beverage</option>
                                    <option value="Food" <c:if test="${menuItem.category == 'Food'}">selected</c:if>>Food</option>
                                    <option value="Dessert" <c:if test="${menuItem.category == 'Dessert'}">selected</c:if>>Dessert</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="description" class="form-label">Description</label>
                                <textarea class="form-control" id="description" name="description" rows="3"><c:out value='${menuItem.description}' /></textarea>
                            </div>

                            <div class="mb-3">
                                <label for="price" class="form-label">Price ($)</label>
                                <input type="number" step="0.01" class="form-control" id="price" name="price" value="<c:out value='${menuItem.price}' />" required>
                            </div>

                            <div class="mb-3 form-check">
                                <input type="checkbox" class="form-check-input" id="available" name="available" <c:if test="${menuItem == null || menuItem.available}">checked</c:if>>
                                <label class="form-check-label" for="available">Available</label>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-success">Save Item</button>
                                <a href="menu" class="btn btn-secondary">Cancel</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
