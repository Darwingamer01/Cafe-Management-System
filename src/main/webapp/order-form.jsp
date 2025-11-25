<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    if (request.getAttribute("menuItems") == null) {
        response.sendRedirect("order");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>New Order - Cafe System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <script>
        function calculateTotal() {
            let total = 0;
            const checkboxes = document.querySelectorAll('input[type="checkbox"]:checked');
            checkboxes.forEach((checkbox) => {
                const itemId = checkbox.value;
                const price = parseFloat(document.getElementById('price_' + itemId).value);
                const qty = parseInt(document.getElementById('qty_' + itemId).value);
                if (qty > 0) {
                    total += price * qty;
                }
            });
            document.getElementById('totalAmount').innerText = total.toFixed(2);
        }
    </script>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="dashboard">Cafe System</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item"><a class="nav-link" href="dashboard">Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link active" href="order">New Order</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <h2>Create New Order</h2>
        
        <% 
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) {
        %>
            <div class="alert alert-danger" role="alert">
                <%= errorMessage %>
            </div>
        <% } %>

        <form action="order" method="post">
            <div class="card shadow">
                <div class="card-body">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Select</th>
                                <th>Item</th>
                                <th>Category</th>
                                <th>Price</th>
                                <th>Quantity</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${menuItems}">
                                <c:if test="${item.available}">
                                    <tr>
                                        <td>
                                            <input type="checkbox" name="itemId" value="${item.itemId}" onchange="calculateTotal()">
                                            <input type="hidden" id="price_${item.itemId}" value="${item.price}">
                                        </td>
                                        <td>${item.itemName}</td>
                                        <td>${item.category}</td>
                                        <td>$${item.price}</td>
                                        <td>
                                            <input type="number" name="qty_${item.itemId}" id="qty_${item.itemId}" class="form-control form-control-sm" style="width: 80px;" value="1" min="1" onchange="calculateTotal()">
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div class="card-footer d-flex justify-content-between align-items-center">
                    <h4>Total: $<span id="totalAmount">0.00</span></h4>
                    <button type="submit" class="btn btn-success btn-lg">Place Order</button>
                </div>
            </div>
        </form>
    </div>

    <div class="container mt-5 mb-5">
        <div class="row">
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
                                                            <input type="hidden" name="source" value="order">
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
