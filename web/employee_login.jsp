<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="web_services.*"%>
<%@page import="java.util.*"%>
<%@page import="javax.servlet.http.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Employee Login</title>
        <link rel="stylesheet" type="text/css" href="styles.css">
        <script type="text/javascript" src="scripts.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
        <%
            BranchWebServices_Service branch_service = new BranchWebServices_Service();
            BranchWebServices branch_port = branch_service.getBranchWebServicesPort();
            EmployeeWebServices_Service employee_service = new EmployeeWebServices_Service();
            EmployeeWebServices employee_port = employee_service.getEmployeeWebServicesPort();
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
                    List<String> employee = employee_port.employeeLogin(emailAddress, password);
                    if (employee != null) {
                        String workingStatus = employee.get(2);
                        int branchId = Integer.parseInt(employee.get(1));
                        List<String> branch = null;
                        try {
                            branch = branch_port.selectBranch(branchId);
                        } catch (Exception error) {
                            error.printStackTrace();
                        }
                        String operationStatus = branch.get(1);
                        if ("Fired".equals(workingStatus)) {
                            errorMessage = "Access is prohibited for former employees.";
                        } else if ("On Leave".equals(workingStatus)) {
                            errorMessage = "Access is prohibited for employees on leave.";
                        } else if ("Inactive".equals(operationStatus)) {
                            errorMessage = "Access is prohibited for employees at inactive branches.";
                        } else {
                            session = request.getSession(true);
                            session.setAttribute("employeeId", employee.get(0));
                            session.setAttribute("branchStationed", employee.get(1));
                            session.setAttribute("firstName", employee.get(3));
                            session.setAttribute("lastName", employee.get(4));
                            response.sendRedirect("employee_pages/manage_transactions_view.jsp");
                            return;
                        }
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
                            <h5 class="text-center">Employee Login</h5>
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
                                <a class="btn btn-danger btn-sm mt-3" href="admin_login.jsp">Log in as Admin</a>
                            </div>
                        </div>        
                    </div>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
    </body>
</html>