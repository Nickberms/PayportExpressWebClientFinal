<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="web_services.*"%>
<%@page import="java.util.*"%>
<%@page import="javax.servlet.http.*"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Payport Express</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
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
        %>
        <div class="container-fluid p-0">
            <div style="width:100%; overflow:hidden">
                <div class="row">
                    <div class="col-sm-12">
                        <center>
                            <img src="assets/images/logo.png" alt="" class="img-fluid" style="border-radius: 50%; width:10%;"/>
                        </center>
                    </div>
                </div>
                <hr>
                <div class="row">
                    <div class="col-sm-12">
                        <center>
                            <img src="assets/images/3882227.png" class="img-fluid" style="width:10%" alt=""/>
                        </center>
                        <div style="width:50%; margin:10px auto;">
                            <div class="d-grid gap-2">
                                <a href="add_transaction_form.jsp" class="btn btn-warning btn-sm">Go to Add Transaction Form</a>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-6">
                        <center>
                            <img src="assets/images/5673264.png" class="img-fluid" style="width:10%" alt=""/>
                        </center>
                        <div style="width:50%; margin:10px auto;">
                            <div class="d-grid gap-2">
                                <a href="employee_login.jsp" class="btn btn-warning btn-sm">Go to Employee Login</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-6">
                        <center>
                            <img src="assets/images/2206248.png" class="img-fluid" style="width:10%" alt=""/>
                        </center>
                        <div style="width:50%; margin:10px auto;">
                            <div class="d-grid gap-2">
                                <a href="admin_login.jsp" class="btn btn-warning btn-sm">Go to Admin Login</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
    </body>
</html>