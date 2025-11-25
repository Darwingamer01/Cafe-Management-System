# Cafe Management System ☕

A comprehensive web-based application for managing cafe operations, including order processing, menu management, billing, and sales reporting.

## 🚀 Features

*   **User Authentication**: Secure login for Admin and Staff roles.
*   **Dashboard**: Overview of quick actions and recent orders (global view for all users).
*   **Menu Management**: Admin-only access to add, update, and delete menu items.
*   **Order Processing**:
    *   Create new orders with multiple items.
    *   Real-time total calculation.
    *   Status tracking (Pending -> Completed).
    *   **Global Recent Orders**: Staff and Admins see the same list of recent orders.
*   **Billing**: Generate print-friendly bills with tax calculation.
*   **Reporting**: Admin-only access to daily sales reports (filtered by 'Completed' orders).
*   **Input Validation**: Server-side validation for menu items and orders.

## 🛠️ Prerequisites & Installation Guide

Before you begin, ensure you have the following installed. If not, follow the steps below.

### 1. Java Development Kit (JDK) 8 or higher
*   **Verify Installation**:
    Open Command Prompt (cmd) and run:
    ```bash
    java -version
    ```
    *If you see a version number (e.g., `java version "1.8.0_..."`), you are good to go.*

*   **Installation Steps**:
    1.  Go to the [Oracle JDK Downloads](https://www.oracle.com/java/technologies/downloads/) page.
    2.  Download the **x64 Installer** for Windows.
    3.  Run the installer and follow the on-screen instructions.
    4.  **Set Environment Variable**:
        *   Search for "Edit the system environment variables" in Windows Search.
        *   Click "Environment Variables".
        *   Under "System variables", click "New".
        *   Variable name: `JAVA_HOME`
        *   Variable value: Path to your JDK installation (e.g., `C:\Program Files\Java\jdk-17`).
        *   Find the `Path` variable, click "Edit", then "New", and add `%JAVA_HOME%\bin`.

### 2. Apache Maven
*   **Verify Installation**:
    Run:
    ```bash
    mvn -version
    ```
    *If you see Apache Maven version info, it's installed.*

*   **Installation Steps**:
    1.  Download the **Binary zip archive** from [Maven Downloads](https://maven.apache.org/download.cgi).
    2.  Extract the zip file to a folder (e.g., `C:\Program Files\Apache\maven`).
    3.  **Add to Path**:
        *   Open Environment Variables (as above).
        *   Edit the `Path` variable.
        *   Add the path to the `bin` folder inside your extracted Maven folder (e.g., `C:\Program Files\Apache\maven\bin`).

### 3. MySQL Server
*   **Verify Installation**:
    Run:
    ```bash
    mysql --version
    ```
    *Or check if "MySQL Workbench" is installed.*

*   **Installation Steps**:
    1.  Download the **MySQL Installer for Windows** from [MySQL Downloads](https://dev.mysql.com/downloads/installer/).
    2.  Run the installer and choose **"Developer Default"** setup type.
    3.  Follow the configuration steps.
    4.  **Important**: When asked for a **Root Password**, remember it! You will need this for the application to connect.

## ⚙️ Installation & Setup Guide

Follow these steps carefully to get the project running on your local machine.

### Step 1: Database Configuration 🗄️

1.  **Locate the Schema File**:
    *   Navigate to the `database` folder in this project.
    *   You will find a file named `schema.sql`. This contains the code to create the database and tables.

2.  **Import Database**:
    *   **Option A: Using MySQL Workbench (Recommended)**
        1.  Open MySQL Workbench and connect to your local instance.
        2.  Go to **File** > **Open SQL Script**.
        3.  Select `database/schema.sql`.
        4.  Click the **Lightning Bolt** icon ⚡ to execute the script.
    *   **Option B: Using Command Line**
        1.  Open "MySQL Command Line Client".
        2.  Enter your root password.
        3.  Run the following command (replace path with actual path):
            ```sql
            source C:/path/to/cafe_management/database/schema.sql
            ```

3.  **Connect Application to Database**:
    *   Open the file: `src/main/java/com/cafe/dao/DatabaseConnection.java`.
    *   Find the `getConnection()` method (around line 15).
    *   **Update the Password**:
        ```java
        // Change "root" to your MySQL root password if it's different
        DriverManager.getConnection("jdbc:mysql://localhost:3306/cafe_db", "root", "YOUR_PASSWORD");
        ```
    *   Save the file.

### Step 2: Build the Project 🏗️

1.  **Open Terminal**:
    *   Open Command Prompt (cmd) or PowerShell.
    *   Navigate to the project root directory (where `pom.xml` is located):
        ```bash
        cd path/to/cafe_management
        ```
2.  **Run Build Command**:
    *   Execute the following command to compile the code and download dependencies:
        ```bash
        mvn clean package
        ```
    *   **Success**: You should see a "BUILD SUCCESS" message.

### Step 3: Run the Application 🚀

1.  **Start the Server**:
    *   In the same terminal, run:
        ```bash
        mvn tomcat7:run
        ```
2.  **Wait for Startup**:
    *   The first time might take a minute. Look for the message: `INFO: Starting ProtocolHandler ["http-bio-8080"]`.
3.  **Access the App**:
    *   Open your web browser (Chrome, Edge, etc.).
    *   Go to: [http://localhost:8080/CafeManagementSystem](http://localhost:8080/CafeManagementSystem)

### Step 4: Login & Test ✅

*   **Admin Login**:
    *   Username: `admin`
    *   Password: `admin123`
*   **Staff Login**:
    *   Username: `staff`
    *   Password: `staff123`

## 📂 Project Structure

```
cafe_management/
├── src/main/java/com/cafe/
│   ├── controller/       # Servlets (Login, Order, Menu, Dashboard, Reports)
│   ├── dao/              # Data Access Objects (Database logic)
│   ├── model/            # Java Beans (User, Order, MenuItem)
│   └── util/             # Utilities (DatabaseConnection)
├── src/main/webapp/
│   ├── css/              # Stylesheets (style.css)
│   ├── WEB-INF/          # Configuration (web.xml)
│   ├── dashboard.jsp     # Main dashboard
│   ├── login.jsp         # Login page
│   ├── order-form.jsp    # Order creation page
│   ├── menu-list.jsp     # Menu management list
│   ├── menu-form.jsp     # Add/Edit menu item
│   ├── billing.jsp       # Bill view
│   └── reports.jsp       # Sales reports
├── database/
│   └── schema.sql        # Database schema and seed data
└── pom.xml               # Maven dependencies
```

## 📖 Usage Guide

### Getting Started
1.  **Login**:
    *   **Admin**: `admin` / `admin123`
    *   **Staff**: `staff` / `staff123`

### Managing Orders
1.  Go to **New Order**.
2.  Select items and enter quantities.
3.  Click **Place Order**.
4.  To mark an order as paid/completed:
    *   Find the order in **Recent Orders** (Dashboard or Order page).
    *   Click **Mark Completed**. The status will change to "Completed" (Green badge).

### Managing Menu (Admin Only)
1.  Go to **Menu Management**.
2.  **Add**: Click "Add New Item".
3.  **Edit/Delete**: Use the actions in the menu table.

### Viewing Reports (Admin Only)
1.  Go to **Reports**.
2.  View daily sales summaries.
    *   *Note*: Only orders with status "Completed" are included in the revenue.

## 💻 Development Guide

*   **UI Changes**: Modify files in `src/main/webapp/` (JSP files) or `src/main/webapp/css/style.css`.
*   **Business Logic**: Modify Servlets in `src/main/java/com/cafe/controller/`.
*   **Database Logic**: Modify DAOs in `src/main/java/com/cafe/dao/`.

## ❓ Troubleshooting

Here are some common issues and how to fix them:

### 1. `java.sql.SQLException: Access denied for user`
*   **Cause**: Incorrect database username or password.
*   **Fix**: Open `src/main/java/com/cafe/dao/DatabaseConnection.java` and update the `DriverManager.getConnection` line with your correct MySQL password.

### 2. `Port 8080 is already in use`
*   **Cause**: Another application is using port 8080.
*   **Fix**: Stop the other application or restart your computer. You can also change the port in `pom.xml` (requires configuration).

### 3. `Data truncated for column 'status'`
*   **Cause**: Trying to save a status value that isn't allowed by the database (e.g., "Paid" instead of "completed").
*   **Fix**: Ensure you are using the "Mark Completed" button which sends the correct "completed" status.

### 4. `ClassNotFoundException: com.mysql.cj.jdbc.Driver`
*   **Cause**: Maven dependencies are not downloaded correctly.
*   **Fix**: Run `mvn clean install` in the terminal to force re-downloading dependencies.

### 5. `HTTP Status 404 - Not Found`
*   **Cause**: The application didn't start correctly or the URL is wrong.
*   **Fix**:
    *   Check the terminal for startup errors.
    *   Ensure you are visiting: [http://localhost:8080/CafeManagementSystem](http://localhost:8080/CafeManagementSystem)

## 🤝 Contributing
1.  Fork the repository.
2.  Create a feature branch.
3.  Commit your changes.
4.  Push to the branch.
5.  Open a Pull Request.
