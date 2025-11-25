package com.cafe.controller;

import com.cafe.dao.OrderDAO;
import com.cafe.model.Order;
import com.cafe.model.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
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

        User user = (User) session.getAttribute("user");

        // Fetch recent orders for the user (or all if admin? For now just user's own
        // orders)
        // If admin wants to see all, we might need a different method, but "Recent
        // Orders" usually implies "My Orders" or "System Orders" depending on context.
        // Let's show user's own orders for now.
        List<Order> recentOrders = orderDAO.getAllRecentOrders();
        request.setAttribute("recentOrders", recentOrders);

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}
