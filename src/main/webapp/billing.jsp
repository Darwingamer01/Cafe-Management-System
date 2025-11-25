<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bill - Order #${order.orderId}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .bill-container {
            background-color: white;
            max-width: 600px;
            margin: 50px auto;
            padding: 40px;
            border: 1px solid #ddd;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        .bill-header {
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #333;
            padding-bottom: 20px;
        }
        .bill-footer {
            text-align: center;
            margin-top: 40px;
            border-top: 1px solid #ddd;
            padding-top: 20px;
            font-size: 0.9em;
            color: #666;
        }
        @media print {
            body {
                background-color: white;
            }
            .bill-container {
                box-shadow: none;
                border: none;
                margin: 0;
                padding: 0;
            }
            .no-print {
                display: none !important;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="bill-container">
            <div class="bill-header">
                <h1>CAFE SYSTEM</h1>
                <p>123 Coffee Street, Java City</p>
                <p>Tel: (555) 123-4567</p>
            </div>

            <div class="row mb-4">
                <div class="col-6">
                    <strong>Order #:</strong> ${order.orderId}<br>
                    <strong>Date:</strong> <fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm"/>
                </div>
                <div class="col-6 text-end">
                    <strong>Status:</strong> ${order.status}
                </div>
            </div>

            <table class="table table-sm">
                <thead>
                    <tr>
                        <th>Item</th>
                        <th class="text-center">Qty</th>
                        <th class="text-end">Price</th>
                        <th class="text-end">Total</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${orderItems}">
                        <tr>
                            <td>${item.itemName}</td>
                            <td class="text-center">${item.quantity}</td>
                            <td class="text-end">$<fmt:formatNumber value="${item.itemPrice}" minFractionDigits="2"/></td>
                            <td class="text-end">$<fmt:formatNumber value="${item.subtotal}" minFractionDigits="2"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="3" class="text-end border-0 pt-3"><strong>Subtotal:</strong></td>
                        <td class="text-end border-0 pt-3">$<fmt:formatNumber value="${order.totalAmount}" minFractionDigits="2"/></td>
                    </tr>
                    <tr>
                        <td colspan="3" class="text-end border-0"><strong>Tax (10%):</strong></td>
                        <td class="text-end border-0">$<fmt:formatNumber value="${order.taxAmount}" minFractionDigits="2"/></td>
                    </tr>
                    <tr>
                        <td colspan="3" class="text-end border-0"><h4>Grand Total:</h4></td>
                        <td class="text-end border-0"><h4>$<fmt:formatNumber value="${order.grandTotal}" minFractionDigits="2"/></h4></td>
                    </tr>
                </tfoot>
            </table>

            <div class="bill-footer">
                <p>Thank you for your visit!</p>
                <p>Please come again.</p>
            </div>

            <div class="text-center mt-4 no-print">
                <button onclick="window.print()" class="btn btn-primary me-2">Print Bill</button>
                <a href="dashboard" class="btn btn-secondary">Back to Dashboard</a>
            </div>
        </div>
    </div>
</body>
</html>
