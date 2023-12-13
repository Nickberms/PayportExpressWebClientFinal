<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="web_services.*"%>
<%@page import="java.util.*"%>
<%@page import="javax.servlet.http.*"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Admin Login</title>
        <link rel="stylesheet" type="text/css" href="styles.css">
        <script type="text/javascript" src="scripts.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <%
            AdminWebServices_Service admin_service = new AdminWebServices_Service();
            AdminWebServices admin_port = admin_service.getAdminWebServicesPort();
        %>
    </head>
    <body style="background: #06BF7B;">
        <%
            HttpServletResponse httpResponse = response;
            httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            httpResponse.setHeader("Pragma", "no-cache");
            httpResponse.setDateHeader("Expires", 0);
            session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            String errorMessage = "";
            try {
                if ("POST".equals(request.getMethod())) {
                    String emailAddress = request.getParameter("emailAddress");
                    String password = request.getParameter("password");
                    List<String> admin = admin_port.adminLogin(emailAddress, password);
                    if (admin != null) {
                        session = request.getSession(true);
                        session.setAttribute("adminId", admin.get(0));
                        session.setAttribute("firstName", admin.get(1));
                        session.setAttribute("lastName", admin.get(2));
                        session.setAttribute("email", admin.get(7));
                        response.sendRedirect("admin_pages/admin_employees.jsp");
                        return;
                    } else {
                        errorMessage = "Invalid email address or password.";
                    }
                }
            } catch (Exception error) {
                errorMessage = "Invalid email address or password.";
                error.printStackTrace();
            }
        %>
        <div class="container-fluid p-0">
            <div style="width:100%; overflow:hidden">
                <div class="employe_login_panel">
                    <center>
                        <img src="assets/images/user_login.png" class="img-fluid employee_login_icon">
                    </center>
                    <div class="row">
                        <div class="col-sm-12">
                            <h5 class="text-center">Admin Login</h5>
                            <form method="POST">
                                <label class="form-label" for="emailAddress">Email Address:</label>
                                <input class="form-control border-secondary" type="text" id="emailAddress" name="emailAddress" required>
                                <label class="form-label" for="password">Password:</label>
                                <input class="form-control border-secondary" type="password" id="password" name="password" required>
                                <div class="d-grid gap-2">
                                    <input class="btn btn-success btn-sm mt-3" type="submit" value="Log In">
                                </div>
                            </form>
                            <div><%= errorMessage%></div>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col-sm-12">
                            <form action="add_transaction_form.jsp">
                                <div class="d-grid gap-2">
                                    <input class="btn btn-warning btn-sm" type="submit" value="Go to Add Transaction Form">
                                </div>
                            </form>
                            <div class="d-grid gap-2">
                                <a class="btn btn-danger btn-sm mt-3" href="employee_login.jsp">Log in as Employee</a>
                            </div>
                        </div>   
                    </div>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
    </body>
</html>