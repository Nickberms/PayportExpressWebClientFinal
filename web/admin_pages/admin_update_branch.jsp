<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="extra_features.*"%>
<%@page import="web_services.*"%>
<%@page import="java.util.*"%>
<%@page import="javax.servlet.http.*"%>
<%@page import="net.java.dev.jaxb.array.*"%>
<%@page import="extra_features.*"%>
<%@page import="web_services.*"%>
<%@page import="java.util.*"%>
<%@page import="javax.servlet.http.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Payport Express</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
        <link rel="stylesheet" href="navbar_style.css"/>
        <link rel="stylesheet" href="admin_styles.css"/>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <script type="text/javascript" src="admin_scripts.js"></script>
        <%
            BranchWebServices_Service branch_service = new BranchWebServices_Service();
            BranchWebServices branch_port = branch_service.getBranchWebServicesPort();
            EmployeeWebServices_Service employee_service = new EmployeeWebServices_Service();
            EmployeeWebServices employee_port = employee_service.getEmployeeWebServicesPort();
        %>
    </head>
    <body>
        <%
            HttpServletResponse httpResponse = response;
            httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            httpResponse.setHeader("Pragma", "no-cache");
            httpResponse.setDateHeader("Expires", 0);
            session = request.getSession(false);
            String adminId = (String) session.getAttribute("adminId");
            if (session == null || session.getAttribute("adminId") == null) {
                response.sendRedirect("../admin_login.jsp");
                return;
            }
            String firstName = (String) session.getAttribute("firstName");
            String lastName = (String) session.getAttribute("lastName");
            String email = (String) session.getAttribute("email");
            String action = request.getParameter("action");
            try {
                if (action.equals("logout")) {
                    if (session != null) {
                        session.invalidate();
                    }
                    response.sendRedirect("../admin_login.jsp");
                    return;
                }
            } catch (Exception error) {
                error.printStackTrace();
            }
        %>
        <%
            httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            httpResponse.setHeader("Pragma", "no-cache");
            httpResponse.setDateHeader("Expires", 0);
            session = request.getSession(false);
            String branchIdParam = request.getParameter("branchId");
            if (session == null || session.getAttribute("adminId") == null) {
                response.sendRedirect("../admin_login.jsp");
                return;
            } else if (branchIdParam == null || branchIdParam.trim().isEmpty()) {
                String referer = request.getHeader("Referer");
                if (referer != null && !referer.isEmpty()) {
                    response.sendRedirect(referer);
                } else {
                    response.sendRedirect("admin_branches.jsp");
                }
                return;
            }
            try {
                if (action.equals("update")) {
                    int branchId = Integer.parseInt(request.getParameter("branchId"));
                    String operationStatus = request.getParameter("operationStatus");
                    String branchName = request.getParameter("branchName").trim();
                    branchName = NameFormatter.formatName(branchName);
                    String town = request.getParameter("town").trim();
                    town = NameFormatter.formatName(town);
                    String municipality = request.getParameter("municipality").trim();
                    municipality = NameFormatter.formatName(municipality);
                    String province = request.getParameter("province").trim();
                    province = NameFormatter.formatName(province);
                    String address = town + ", " + municipality + ", " + province;
                    try {
                        if (branchName.isEmpty() || town.isEmpty() || municipality.isEmpty() || province.isEmpty()) {
                            out.println("Sorry, invalid input. Please try again.");
                        } else {
                            branch_port.updateBranch(branchId, operationStatus, branchName, address);
                            response.sendRedirect("admin_branches.jsp");
                        }
                    } catch (Exception error) {
                        error.printStackTrace();
                    }
                }
            } catch (Exception error) {
                error.printStackTrace();
            }
        %>
        <input type="hidden" value="<%= adminId%>">
        <div class="container-fluid p-0">
            <div class="admin_panel" style="width: 100%; overflow: hidden">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="app">
                            <div class="menu-toggle">
                                <div class="hamburger">
                                    <span></span>
                                </div>
                            </div>
                            <aside class="sidebar">
                                <h5 class="text-center" style="color:white">Admin</h5>
                                <center>
                                    <img src="../assets/images/149071.png" class="img-fluid" style="width:50%">
                                </center>
                                <h5 class="text-center mt-2" style="color:white">
                                    <%= firstName%>  <%= lastName%>
                                </h5>
                                <hr>
                                <h3>Menu</h3>
                                <nav class="menu">
                                    <a class="menu-item" href="admin_employees.jsp">Employees</a>
                                    <a class="menu-item" href="admin_branches.jsp">Branches</a>
                                </nav>
                                <div class="d-grid gap-2">
                                    <button class="btn btn-danger btn-sm" data-bs-toggle="modal" data-bs-target="#logout">Logout</button>
                                    <div class="modal fade" id="logout" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h1 class="modal-title fs-5" id="exampleModalLabel">Confirming Logout</h1>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <p class="text-center">Are you sure you want to logout?</p>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                    <a class="btn btn-danger" href="admin_update_branch.jsp?action=logout">Confirm</a>
                                                </div>        
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </aside>
                            <main class="content">
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="panels">
                                            <h3 class="text-start p-2">Update Payport Express Branch</h3>
                                            <form action="admin_update_branch.jsp?action=update" method="post">
                                                <div> 
                                                    <%
                                                        String branchIdStr = request.getParameter("branchId");
                                                        int branchId = 0;
                                                        List<String> branch = null;
                                                        if (branchIdStr != null && !branchIdStr.isEmpty()) {
                                                            try {
                                                                branchId = Integer.parseInt(branchIdStr);
                                                                branch = branch_port.selectBranch(branchId);
                                                            } catch (Exception error) {
                                                                error.printStackTrace();
                                                            }
                                                        }
                                                        String fullAddress = branch.get(3);
                                                        String[] addressParts = fullAddress.split(",");
                                                        String town = addressParts.length > 0 ? addressParts[0].trim() : "";
                                                        String municipality = addressParts.length > 1 ? addressParts[1].trim() : "";
                                                        String province = addressParts.length > 2 ? addressParts[2].trim() : "";
                                                    %>
                                                    <div>
                                                        <div class="row p-2">
                                                            <div class="col-sm-2">
                                                                <label class="form-label" for="branchId">Branch ID: <%= branch.get(0)%></label>
                                                            </div>
                                                        </div>
                                                        <input class="form-control border-secondary" type="text" id="branchId" name="branchId" style="display: none;" value="<%= branch.get(0)%>" readonly>
                                                        <h3 class="text-start p-2">Status and Name</h3>  
                                                        <div class="row p-2">
                                                            <div class="col-sm-6">
                                                                <label for="operationStatus" class="form-label">Operation Status:</label>
                                                                <select id="operationStatus" name="operationStatus" class="form-select border-secondary">
                                                                    <option value="Active" <%= "Active".equals(branch.get(1).trim()) ? "selected" : ""%>>Active</option>
                                                                    <option value="Inactive" <%= "Inactive".equals(branch.get(1).trim()) ? "selected" : ""%>>Inactive</option>
                                                                </select>
                                                            </div>    
                                                            <div class="col-sm-6">
                                                                <label class="form-label" for="branchName">Branch Name:</label>
                                                                <input class="form-control border-secondary" type="text" id="branchName" name="branchName" value="<%= branch.get(2)%>" oninput="LettersOnly(this)" required>
                                                            </div>    
                                                        </div>     
                                                        <div class="row p-2">
                                                            <h3>Address</h3>
                                                            <div class="col-sm-4">
                                                                <label class="form-label" for="town">Town:</label>
                                                                <input class="form-control border-secondary" type="text" id="town" name="town" value="<%= town%>" oninput="LettersOnly(this)" required>
                                                            </div>   
                                                            <div class="col-sm-4">
                                                                <label class="form-label" for="municipality">Municipality:</label>
                                                                <input class="form-control border-secondary" type="text" id="municipality" name="municipality" value="<%= municipality%>" oninput="LettersOnly(this)" required>
                                                            </div>
                                                            <div class="col-sm-4">
                                                                <label class="form-label" for="province">Province:</label>
                                                                <input  class="form-control border-secondary" type="text" id="province" name="province" value="<%= province%>" oninput="LettersOnly(this)" required>
                                                            </div>    
                                                        </div>
                                                        <div class="d-grid gap-2 p-4">
                                                            <button type="submit" class="btn btn-sm btn-success">Save</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </main>
                        </div>  
                    </div>
                </div>  
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        <script>
            const menu_toggle = document.querySelector('.menu-toggle');
            const sidebar = document.querySelector('.sidebar');
            menu_toggle.addEventListener('click', () => {
                menu_toggle.classList.toggle('is-active');
                sidebar.classList.toggle('is-active');
            });
        </script>
    </body>
</html>