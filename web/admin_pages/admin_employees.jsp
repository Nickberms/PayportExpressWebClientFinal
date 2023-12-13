<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="extra_features.*"%>
<%@page import="web_services.*"%>
<%@page import="java.util.*"%>
<%@page import="javax.servlet.http.*"%>
<%@page import="net.java.dev.jaxb.array.*"%>
<%@page import="extra_features.*"%>
<%@page import="web_services.*"%>
<%@page import="java.text.*"%>
<%@page import="java.util.*"%>
<%@page import="javax.servlet.http.*"%>
<%@page import="javax.xml.datatype.*"%>
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
            if (session == null || session.getAttribute("adminId") == null) {
                response.sendRedirect("../admin_login.jsp");
                return;
            }
            try {
                if (action.equals("insert")) {
                    int branchStationed = Integer.parseInt(request.getParameter("branchStationed"));
                    String firstName_1 = request.getParameter("firstName_1").trim();
                    firstName_1 = NameFormatter.formatName(firstName_1);
                    String lastName_1 = request.getParameter("lastName_1").trim();
                    lastName_1 = NameFormatter.formatName(lastName_1);
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
                        if (firstName_1.isEmpty() || lastName_1.isEmpty() || town.isEmpty() || municipality.isEmpty() || province.isEmpty()) {
                            out.println("Sorry, invalid input. Please try again.");
                        } else {
                            employee_port.insertNewEmployee(branchStationed, firstName_1, lastName_1, birthdate, sex, address, phoneNumber, emailAddress, password);
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
        <%
            try {
                if (action.equals("delete")) {
                    String employeeIdParam = request.getParameter("employeeId");
                    int employeeId = Integer.parseInt(employeeIdParam);
                    employee_port.deleteEmployee(employeeId);
                    response.sendRedirect("admin_employees.jsp");
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
                                                    <a class="btn btn-danger" href="admin_employees.jsp?action=logout">Confirm</a>
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
                                            <h3 class="text-start p-2">Employees</h3>
                                            <div class="row p-2">
                                                <div class="col-sm-12">
                                                    <div class="branch_cards">
                                                        <div class="branch_card_headers"></div>
                                                        <div class="row">
                                                            <div class="col-sm-12">
                                                                <img src="../assets/images/6577285.png" class="img-fluid" id="branch_card_icon" style="width:20%;">
                                                                <div class="row p-2">
                                                                    <div class="col-sm-12">
                                                                        <p class="text-start"><b>Manage Employees</b></p>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row p-2">
                                                <div class="col-sm-12">
                                                    <div class="add_branches_button_Wrapper">
                                                        <div class="d-grid gap-2">
                                                            <button class="btn btn-success btn-sm" data-bs-toggle="modal" data-bs-target="#admin_add_employee">Add New Employee</button>
                                                        </div>
                                                        <div class="modal modal-xl fade" id="admin_add_employee" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                                            <div class="modal-dialog">
                                                                <div class="modal-content">
                                                                    <div class="modal-header">
                                                                        <h1 class="modal-title fs-5" id="exampleModalLabel">Add New Payport Express Employee</h1>
                                                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                    </div>
                                                                    <div class="modal-body">
                                                                        <form action="admin_employees.jsp?action=insert" method="post">
                                                                            <div class="row">
                                                                                <div class="col-sm-4">
                                                                                    <h3>Branch</h3>
                                                                                    <label class="form-label" for="branchStationed">Branch Station:</label>
                                                                                    <select id="branchStationed" name="branchStationed" class="form-select border-secondary">
                                                                                        <%
                                                                                            List<StringArray> branchArray = branch_port.selectAllBranches();
                                                                                            List<String[]> branches = new ArrayList<>();
                                                                                            for (StringArray branchStringArray : branchArray) {
                                                                                                branches.add(branchStringArray.getItem().toArray(new String[0]));
                                                                                            }
                                                                                            for (String[] branch : branches) {
                                                                                        %>
                                                                                        <option value="<%= branch[0]%>"><%= branch[0]%> <%= branch[2]%></option>
                                                                                        <%
                                                                                            }
                                                                                        %>
                                                                                    </select>
                                                                                </div>
                                                                                <div class="col-sm-4">
                                                                                    <h3>Basic Information</h3>
                                                                                    <label class="form-label" for="firstName">First Name:</label>
                                                                                    <input class="form-control border-secondary" type="text" id="firstName" name="firstName_1" oninput="LettersOnly(this)" required>
                                                                                    <label class="form-label" for="lastName">Last Name:</label>
                                                                                    <input class="form-control border-secondary" type="text" id="lastName" name="lastName_1" oninput="LettersOnly(this)" required>
                                                                                    <label class="form-label" for="birthdate">Birthdate:</label>
                                                                                    <input class="form-control border-secondary" type="date" id="birthdate" name="birthdate" required>
                                                                                    <label class="form-label" for="sex">Sex:</label>
                                                                                    <select id="sex" name="sex" class="form-select border-secondary">
                                                                                        <option value="Male">Male</option>
                                                                                        <option value="Female">Female</option>
                                                                                    </select>
                                                                                </div>
                                                                                <div class="col-sm-4">
                                                                                    <h3>Address</h3>
                                                                                    <label class="form-label" for="town">Town:</label>
                                                                                    <input class="form-control border-secondary" type="text" id="town" name="town" oninput="LettersOnly(this)" required>
                                                                                    <label class="form-label" for="municipality">Municipality:</label>
                                                                                    <input class="form-control border-secondary" type="text" id="municipality" name="municipality" oninput="LettersOnly(this)" required>
                                                                                    <label class="form-label" for="province">Province:</label>
                                                                                    <input class="form-control border-secondary" type="text" id="province" name="province" oninput="LettersOnly(this)" required><br>
                                                                                    <h3>Credentials</h3>
                                                                                    <label class="form-label" for="phoneNumber">Phone Number:</label>
                                                                                    <input class="form-control border-secondary" type="text" id="phoneNumber" name="phoneNumber" oninput="NumbersOnly(this)" minlength="3" maxlength="15" required>
                                                                                    <label class="form-label" for="emailAddress">Email Address:</label>
                                                                                    <input class="form-control border-secondary" type="email" id="emailAddress" name="emailAddress" required>
                                                                                    <label class="form-label" for="password">Password:</label>
                                                                                    <input class="form-control border-secondary" type="password" id="password" name="password" required>
                                                                                </div>
                                                                                <div class="modal-footer">
                                                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                                    <button class="btn btn-success">Save</button>
                                                                                </div>
                                                                            </div>
                                                                        </form>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row p-2">
                                                <div class="col-sm-3">
                                                    <form action="<%=request.getRequestURI()%>" method="get">
                                                        <input type="text" id="keyword" placeholder="Search Employees" name="keyword" class="form-control border-secondary">
                                                        </div>
                                                        <div class="col-sm-3">
                                                            <button class="btn btn-success btn-sm">Search</button>
                                                    </form>
                                                </div>
                                            </div>
                                            <div class="row p-2">
                                                <div class="col-sm-12">
                                                    <div class="employee_table_container">
                                                        <div class="employee_table_wrapper">
                                                            <table class="table table-bordered table-striped border-secondary" style="font-size: 9pt">
                                                                <thead class="table-success">
                                                                    <tr>
                                                                        <th>Actions</th>
                                                                        <th>Employee ID</th>
                                                                        <th>Branch Stationed</th>
                                                                        <th>Working Status</th>
                                                                        <th>First Name</th>
                                                                        <th>Last Name</th>
                                                                        <th>Birthdate</th>
                                                                        <th>Sex</th>
                                                                        <th>Address</th>
                                                                        <th>Phone Number</th>
                                                                        <th>Email Address</th>  
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <%
                                                                        List<StringArray> employeeArray = employee_port.selectAllEmployees();
                                                                        List<String[]> employees = new ArrayList<>();
                                                                        for (StringArray employeeStringArray : employeeArray) {
                                                                            employees.add(employeeStringArray.getItem().toArray(new String[0]));
                                                                        }
                                                                        HashMap<Integer, String> branchMap = new HashMap<>();
                                                                        List<StringArray> branchArray_user = branch_port.selectAllBranches();
                                                                        for (StringArray branchStringArray : branchArray_user) {
                                                                            String[] branch = branchStringArray.getItem().toArray(new String[0]);
                                                                            branchMap.put(Integer.parseInt(branch[0]), branch[2]);
                                                                        }
                                                                        String keyword = request.getParameter("keyword");
                                                                        if (keyword != null) {
                                                                            keyword = keyword.toLowerCase();
                                                                        }
                                                                        for (String[] employee : employees) {
                                                                            String branchName = branchMap.getOrDefault(Integer.parseInt(employee[1]), "No Branch");
                                                                            boolean matchesKeyword = true;
                                                                            if (keyword != null && !keyword.trim().isEmpty()) {
                                                                                matchesKeyword = false;
                                                                                for (String field : employee) {
                                                                                    if (field != null && field.toLowerCase().contains(keyword)) {
                                                                                        matchesKeyword = true;
                                                                                        break;
                                                                                    }
                                                                                }
                                                                                if (branchName.toLowerCase().contains(keyword)) {
                                                                                    matchesKeyword = true;
                                                                                }
                                                                            }
                                                                            if (matchesKeyword) {
                                                                    %>
                                                                    <tr>
                                                                        <td>
                                                                            <a class="btn btn-sm btn-primary" href="admin_update_employee.jsp?employeeId=<%= employee[0]%>">Update</a>
                                                                            <a class="btn btn-sm btn-danger" href="admin_employees.jsp?action=delete&employeeId=<%= employee[0]%>" onclick="return confirm('Delete employee? Make sure it does not hold any records anymore');">Delete</a>
                                                                        </td>
                                                                        <td><%= employee[0]%></td>
                                                                        <td><%= employee[1]%> <%= branchName%></td>
                                                                        <td><%= employee[2]%></td>
                                                                        <td><%= employee[3]%></td>
                                                                        <td><%= employee[4]%></td>
                                                                        <td><%= employee[5]%></td>
                                                                        <td><%= employee[6]%></td>
                                                                        <td><%= employee[7]%></td>
                                                                        <td><%= employee[8]%></td>
                                                                        <td><%= employee[9]%></td>  
                                                                    </tr>
                                                                    <%
                                                                            }
                                                                        }
                                                                    %>   
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
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