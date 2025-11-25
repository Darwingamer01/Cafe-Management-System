<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error - Cafe System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow border-danger">
                    <div class="card-header bg-danger text-white">
                        <h3>Oops! Something went wrong.</h3>
                    </div>
                    <div class="card-body text-center">
                        <p class="lead">We encountered an unexpected error.</p>
                        
                        <% if (exception != null) { %>
                            <div class="alert alert-warning text-start overflow-auto" style="max-height: 200px;">
                                <strong>Error Details:</strong><br>
                                <%= exception.getMessage() %>
                            </div>
                        <% } %>

                        <div class="mt-4">
                            <a href="dashboard" class="btn btn-primary">Return to Dashboard</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
