package com.cafe.controller;

import com.cafe.dao.MenuDAO;
import com.cafe.dao.OrderDAO;
import com.cafe.model.MenuItem;
import com.cafe.model.Order;
import com.cafe.model.OrderItem;
import com.cafe.model.User;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MenuDAO menuDAO;
    private OrderDAO orderDAO;

    public void init() {
        menuDAO = new MenuDAO();
        orderDAO = new OrderDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Fetch menu items for the order form
        List<MenuItem> menuItems = menuDAO.getAllMenuItems();
        request.setAttribute("menuItems", menuItems);

        // Fetch recent orders for the user
        User user = (User) session.getAttribute("user");
        List<Order> recentOrders = orderDAO.getAllRecentOrders();
        request.setAttribute("recentOrders", recentOrders);

        request.getRequestDispatcher("order-form.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String status = request.getParameter("status");
            String source = request.getParameter("source");
            String redirectUrl = "dashboard";
            if ("order".equals(source)) {
                redirectUrl = "order";
            }

            if (orderDAO.updateOrderStatus(orderId, status)) {
                response.sendRedirect(redirectUrl + "?message=Order Status Updated");
            } else {
                response.sendRedirect(redirectUrl + "?error=Failed to Update Status");
            }
            return;
        }

        String[] itemIds = request.getParameterValues("itemId");

        if (itemIds == null || itemIds.length == 0) {
            request.setAttribute("errorMessage", "Please select at least one item.");
            doGet(request, response);
            return;
        }

        List<OrderItem> orderItems = new ArrayList<>();
        double totalAmount = 0;

        for (String itemIdStr : itemIds) {
            int itemId = Integer.parseInt(itemIdStr);
            int quantity = Integer.parseInt(request.getParameter("qty_" + itemId));

            if (quantity > 0) {
                MenuItem menuItem = menuDAO.getMenuItem(itemId); // Ideally cache this or fetch in bulk
                if (menuItem != null) {
                    OrderItem orderItem = new OrderItem();
                    orderItem.setItemId(itemId);
                    orderItem.setQuantity(quantity);
                    orderItem.setItemPrice(menuItem.getPrice());
                    double subtotal = menuItem.getPrice() * quantity;
                    orderItem.setSubtotal(subtotal);

                    orderItems.add(orderItem);
                    totalAmount += subtotal;
                }
            }
        }

        if (orderItems.isEmpty()) {
            request.setAttribute("errorMessage", "Please select at least one item with quantity > 0.");
            doGet(request, response);
            return;
        }

        double taxRate = 0.10; // 10% tax
        double taxAmount = totalAmount * taxRate;
        double grandTotal = totalAmount + taxAmount;

        Order order = new Order();
        order.setOrderDate(new Timestamp(System.currentTimeMillis()));
        order.setTotalAmount(totalAmount);
        order.setTaxAmount(taxAmount);
        order.setGrandTotal(grandTotal);
        order.setStatus("pending");
        order.setCreatedBy(user.getUserId());

        if (orderDAO.createOrder(order, orderItems)) {
            response.sendRedirect("dashboard?message=Order Placed Successfully");
        } else {
            request.setAttribute("errorMessage", "Failed to place order. Please try again.");
            doGet(request, response);
        }
    }
}
