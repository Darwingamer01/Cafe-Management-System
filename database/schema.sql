CREATE DATABASE IF NOT EXISTS cafe_db;
USE cafe_db;
-- Users Table
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'staff') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Menu Items Table
CREATE TABLE IF NOT EXISTS menu_items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    item_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Orders Table
CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2),
    tax_amount DECIMAL(10, 2),
    grand_total DECIMAL(10, 2),
    status ENUM('pending', 'completed') DEFAULT 'pending',
    created_by INT,
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);
-- Order Items Table
CREATE TABLE IF NOT EXISTS order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    item_id INT,
    quantity INT NOT NULL,
    item_price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (item_id) REFERENCES menu_items(item_id)
);
-- Inventory Table (Optional)
CREATE TABLE IF NOT EXISTS inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    item_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    unit VARCHAR(20) NOT NULL,
    threshold_level INT DEFAULT 10,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
-- Seed Data
INSERT INTO users (username, password, role)
VALUES ('admin', 'admin123', 'admin'),
    ('staff', 'staff123', 'staff');
INSERT INTO menu_items (
        item_name,
        category,
        description,
        price,
        is_available
    )
VALUES (
        'Cappuccino',
        'Beverages',
        'Espresso with steamed milk foam',
        120.00,
        TRUE
    ),
    (
        'Espresso',
        'Beverages',
        'Strong black coffee',
        90.00,
        TRUE
    ),
    (
        'Latte',
        'Beverages',
        'Espresso with steamed milk',
        110.00,
        TRUE
    ),
    (
        'Chicken Sandwich',
        'Food',
        'Grilled chicken with fresh veggies',
        150.00,
        TRUE
    ),
    (
        'Chocolate Cake',
        'Desserts',
        'Rich dark chocolate cake',
        180.00,
        TRUE
    );