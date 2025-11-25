package com.cafe.controller;

import com.cafe.dao.OrderDAO;
import com.cafe.model.Order;
import com.cafe.model.OrderItem;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/billing")
public class BillingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;

    public void init() {
        orderDAO = new OrderDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr != null && !orderIdStr.isEmpty()) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                Order order = orderDAO.getOrder(orderId);

                if (order != null) {
                    List<OrderItem> orderItems = orderDAO.getOrderItems(orderId);
                    request.setAttribute("order", order);
                    request.setAttribute("orderItems", orderItems);
                    request.getRequestDispatcher("billing.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Order not found.");
                    request.getRequestDispatcher("dashboard.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid Order ID.");
                request.getRequestDispatcher("dashboard.jsp").forward(request, response);
            }
        } else {
            // If no order ID provided, maybe show a list of recent orders or redirect
            response.sendRedirect("dashboard.jsp");
        }
    }
}
