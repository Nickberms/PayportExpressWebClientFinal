<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="extra_features.*"%>
<%@page import="web_services.*"%>
<%@page import="java.text.*"%>
<%@page import="java.util.*"%>
<%@page import="javax.servlet.http.*"%>
<%@page import="javax.xml.datatype.*"%>
<%@page import="net.java.dev.jaxb.array.*"%>
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
            String employeeIdParam = request.getParameter("employeeId");
            if (session == null || session.getAttribute("adminId") == null) {
                response.sendRedirect("../admin_login.jsp");
                return;
            } else if (employeeIdParam == null || employeeIdParam.trim().isEmpty()) {
                String referer = request.getHeader("Referer");
                if (referer != null && !referer.isEmpty()) {
                    response.sendRedirect(referer);
                } else {
                    response.sendRedirect("admin_employees.jsp");
                }
                return;
            }
            try {
                if (action.equals("update")) {
                    int employeeId = Integer.parseInt(request.getParameter("employeeId"));
                    int branchStationed = Integer.parseInt(request.getParameter("branchStationed"));
                    String workingStatus = request.getParameter("workingStatus");
                    String firstName1 = request.getParameter("firstName1").trim();
                    firstName1 = NameFormatter.formatName(firstName1);
                    String lastName1 = request.getParameter("lastName1").trim();
                    lastName1 = NameFormatter.formatName(lastName1);
                    String birthdateString = request.getParameter("birthdate");
                    Date gregorian = null;
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                    gregorian = dateFormat.parse(birthdateString);
                    GregorianCalendar gregorianCalendar = new GregorianCalendar();
                    gregorianCalendar.setTime(gregorian);
                    XMLGregorianCalendar birthdate = DatatypeFactory.newInstance().newXMLGregorianCalendar(gregorianCalendar);
                    String sex = request.getParameter("sex");
                    String town = request.getParameter("town").trim();
                    town = NameFormatter.formatName(town);
                    String municipality = request.getParameter("municipality").trim();
                    municipality = NameFormatter.formatName(municipality);
                    String province = request.getParameter("province").trim();
                    province = NameFormatter.formatName(province);
                    String address = town + ", " + municipality + ", " + province;
                    String phoneNumber = request.getParameter("phoneNumber");
                    String emailAddress = request.getParameter("emailAddress").toLowerCase().trim();
                    String password = request.getParameter("password");
                    try {
                        if (firstName1.isEmpty() || lastName1.isEmpty() || town.isEmpty() || municipality.isEmpty() || province.isEmpty()) {
                            out.println("Sorry, invalid input. Please try again.");
                        } else {
                            employee_port.updateEmployee(employeeId, branchStationed, workingStatus, firstName1, lastName1, birthdate, sex, address, phoneNumber, emailAddress, password);
                            response.sendRedirect("admin_employees.jsp");
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
                                                    <a class="btn btn-danger" href="admin_update_employee.jsp?action=logout">Confirm</a>
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
                                            <h3 class="text-start p-2">Update Payport Express Employee</h3>
                                            <form action="admin_update_employee.jsp?action=update" method="post">
                                                <%
                                                    String employeeIdStr = request.getParameter("employeeId");
                                                    int employeeId = 0;
                                                    List<String> employee = null;
                                                    if (employeeIdStr != null && !employeeIdStr.isEmpty()) {
                                                        try {
                                                            employeeId = Integer.parseInt(employeeIdStr);
                                                            employee = employee_port.selectEmployee(employeeId);
                                                        } catch (Exception error) {
                                                            error.printStackTrace();
                                                        }
                                                    }
                                                    String fullAddress = employee.get(7);
                                                    String[] addressParts = fullAddress.split(",");
                                                    String town = addressParts.length > 0 ? addressParts[0].trim() : "";
                                                    String municipality = addressParts.length > 1 ? addressParts[1].trim() : "";
                                                    String province = addressParts.length > 2 ? addressParts[2].trim() : "";
                                                %>
                                                <div class="row p-2">
                                                    <div class="col-sm-2">
                                                        <label class="form-label" for="employeeId">Employee ID: <%= employee.get(0)%></label>
                                                    </div>
                                                </div>   
                                                <input class="form-control border-secondary" type="text" id="employeeId" name="employeeId" style="display: none;" value="<%= employee.get(0)%>" readonly>
                                                <div class="row p-2">
                                                    <div class="col-sm-4">
                                                        <h3>Branch and Status</h3>
                                                        <label class="form-label" for="branchStationed">Branch Station:</label>
                                                        <select class="form-select border-secondary" id="branchStationed" name="branchStationed">
                                                            <%
                                                                List<StringArray> branchArray = branch_port.selectAllBranches();
                                                                List<String[]> branches = new ArrayList<>();
                                                                for (StringArray branchStringArray : branchArray) {
                                                                    branches.add(branchStringArray.getItem().toArray(new String[0]));
                                                                }
                                                                for (String[] branch : branches) {
                                                                    boolean isSelected = employee != null && employee.get(1).equals(branch[0]);
                                                            %>
                                                            <option value="<%= branch[0]%>" <%= isSelected ? "selected" : ""%>><%= branch[0]%> <%= branch[2]%></option>
                                                            <%
                                                                }
                                                            %>
                                                        </select>
                                                        <label class="form-label" for="workingStatus">Working Status:</label>
                                                        <select class="form-select border-secondary" id="workingStatus" name="workingStatus">
                                                            <option value="Active" <%= "Active".equals(employee.get(2).trim()) ? "selected" : ""%>>Active</option>
                                                            <option value="On Leave" <%= "On Leave".equals(employee.get(2).trim()) ? "selected" : ""%>>On Leave</option>
                                                            <option value="Fired" <%= "Fired".equals(employee.get(2).trim()) ? "selected" : ""%>>Fired</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-sm-4">
                                                        <h3>Basic Information</h3>
                                                        <label class="form-label" for="firstName">First Name:</label>
                                                        <input class="form-control border-secondary" type="text" id="firstName" name="firstName1" value="<%= employee.get(3)%>" oninput="LettersOnly(this)" required>
                                                        <label class="form-label" for="lastName">Last Name:</label>
                                                        <input class="form-control border-secondary" type="text" id="lastName" name="lastName1" value="<%= employee.get(4)%>" oninput="LettersOnly(this)" required>
                                                        <label class="form-label" for="birthdate">Birthdate:</label>
                                                        <input class="form-control border-secondary" type="date" id="birthdate" name="birthdate" value="<%= employee.get(5)%>" required>
                                                        <label class="form-label" for="sex">Sex:</label>   
                                                        <select class="form-select border-secondary" id="sex" name="sex">
                                                            <option value="Male" <%= "Male".equals(employee.get(6).trim()) ? "selected" : ""%>>Male</option>
                                                            <option value="Female" <%= "Female".equals(employee.get(6).trim()) ? "selected" : ""%>>Female</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-sm-4">
                                                        <h3>Address</h3>
                                                        <label class="form-label" for="town">Town:</label>
                                                        <input class="form-control border-secondary" type="text" id="town" name="town" value="<%= town%>" oninput="LettersOnly(this)" required>
                                                        <label class="form-label" for="municipality">Municipality:</label>
                                                        <input class="form-control border-secondary" type="text" id="municipality" name="municipality" value="<%= municipality%>" oninput="LettersOnly(this)" required>
                                                        <label class="form-label" for="province">Province:</label>
                                                        <input class="form-control border-secondary" type="text" id="province" name="province" value="<%= province%>" oninput="LettersOnly(this)" required>
                                                        <br><h3>Credentials</h3>
                                                        <label class="form-label" for="phoneNumber">Phone Number:</label>
                                                        <input class="form-control border-secondary" type="text" id="phoneNumber" name="phoneNumber" value="<%= employee.get(8)%>" oninput="NumbersOnly(this)" minlength="3" maxlength="15" required>
                                                        <label class="form-label" for="emailAddress">Email Address:</label>
                                                        <input class="form-control border-secondary" type="email" id="emailAddress" name="emailAddress" value="<%= employee.get(9)%>" required>
                                                        <label class="form-label" for="password">Password:</label>
                                                        <input class="form-control border-secondary" type="password" id="password" name="password" value="<%= employee.get(10)%>" required>
                                                    </div>
                                                </div>
                                                <div class="row p-2">
                                                    <div class="col-sm-3">
                                                        <div class="d-grid gap-2">
                                                            <button type="submit" class="btn btn-success btn-sm">Save</button>
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