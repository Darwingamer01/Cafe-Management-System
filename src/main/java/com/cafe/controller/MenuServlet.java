package com.cafe.controller;

import com.cafe.dao.MenuDAO;
import com.cafe.model.MenuItem;
import com.cafe.model.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MenuDAO menuDAO;

    public void init() {
        menuDAO = new MenuDAO();
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("user");
            return user != null && "admin".equals(user.getRole());
        }
        return false;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null)
            action = "list";

        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteMenuItem(request, response);
                break;
            default:
                listMenuItems(request, response);
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("insert".equals(action)) {
            insertMenuItem(request, response);
        } else if ("update".equals(action)) {
            updateMenuItem(request, response);
        }
    }

    private void listMenuItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<MenuItem> listMenuItems = menuDAO.getAllMenuItems();
        request.setAttribute("listMenuItems", listMenuItems);
        request.getRequestDispatcher("menu-list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("menu-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        MenuItem existingItem = menuDAO.getMenuItem(id);
        request.setAttribute("menuItem", existingItem);
        request.getRequestDispatcher("menu-form.jsp").forward(request, response);
    }

    private void insertMenuItem(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        boolean isAvailable = request.getParameter("available") != null;

        if (name == null || name.trim().isEmpty() || category == null || category.trim().isEmpty() || priceStr == null
                || priceStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Name, Category, and Price are required.");
            showNewForm(request, response);
            return;
        }

        double price;
        try {
            price = Double.parseDouble(priceStr);
            if (price < 0) {
                request.setAttribute("errorMessage", "Price cannot be negative.");
                showNewForm(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid price format.");
            showNewForm(request, response);
            return;
        }

        MenuItem newItem = new MenuItem();
        newItem.setItemName(name);
        newItem.setCategory(category);
        newItem.setDescription(description);
        newItem.setPrice(price);
        newItem.setAvailable(isAvailable);

        menuDAO.addMenuItem(newItem);
        response.sendRedirect("menu");
    }

    private void updateMenuItem(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        boolean isAvailable = request.getParameter("available") != null;

        if (name == null || name.trim().isEmpty() || category == null || category.trim().isEmpty() || priceStr == null
                || priceStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Name, Category, and Price are required.");
            // We need to re-fetch the item to show the edit form with ID, but since we have
            // the data, we can just forward
            // However, showEditForm expects an ID parameter.
            // Simpler to just set attributes and forward to form
            MenuItem item = new MenuItem();
            item.setItemId(id);
            item.setItemName(name);
            item.setCategory(category);
            item.setDescription(description);
            // price might be invalid, so we can't set it easily if parse fails, but we can
            // try
            request.setAttribute("menuItem", item);
            request.getRequestDispatcher("menu-form.jsp").forward(request, response);
            return;
        }

        double price;
        try {
            price = Double.parseDouble(priceStr);
            if (price < 0) {
                request.setAttribute("errorMessage", "Price cannot be negative.");
                MenuItem item = new MenuItem();
                item.setItemId(id);
                item.setItemName(name);
                item.setCategory(category);
                item.setDescription(description);
                item.setAvailable(isAvailable);
                request.setAttribute("menuItem", item);
                request.getRequestDispatcher("menu-form.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid price format.");
            MenuItem item = new MenuItem();
            item.setItemId(id);
            item.setItemName(name);
            item.setCategory(category);
            item.setDescription(description);
            item.setAvailable(isAvailable);
            request.setAttribute("menuItem", item);
            request.getRequestDispatcher("menu-form.jsp").forward(request, response);
            return;
        }

        MenuItem item = new MenuItem();
        item.setItemId(id);
        item.setItemName(name);
        item.setCategory(category);
        item.setDescription(description);
        item.setPrice(price);
        item.setAvailable(isAvailable);

        menuDAO.updateMenuItem(item);
        response.sendRedirect("menu");
    }

    private void deleteMenuItem(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        menuDAO.deleteMenuItem(id);
        response.sendRedirect("menu");
    }
}
