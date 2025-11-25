package com.cafe.controller;

import com.cafe.dao.OrderDAO;
import com.cafe.model.User;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/reports")
public class ReportsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;

    public void init() {
        orderDAO = new OrderDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect("dashboard");
            return;
        }

        List<Map<String, Object>> dailySales = orderDAO.getDailySales();

        double totalRevenue = 0;
        for (Map<String, Object> day : dailySales) {
            totalRevenue += (Double) day.get("total");
        }

        request.setAttribute("dailySales", dailySales);
        request.setAttribute("totalRevenue", totalRevenue);
        request.getRequestDispatcher("reports.jsp").forward(request, response);
    }
}
