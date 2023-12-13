<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="extra_features.*"%>
<%@page import="web_services.*"%>
<%@page import="java.util.*"%>
<%@page import="javax.servlet.http.*"%>
<%@page import="net.java.dev.jaxb.array.*"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Manage Transactions</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" type="text/css" href="employee_styles.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
        <script type="text/javascript" src="employee_scripts.js"></script>
        <%
            BranchWebServices_Service branch_service = new BranchWebServices_Service();
            BranchWebServices branch_port = branch_service.getBranchWebServicesPort();
            EmployeeWebServices_Service employee_service = new EmployeeWebServices_Service();
            EmployeeWebServices employee_port = employee_service.getEmployeeWebServicesPort();
            TransactionWebServices_Service transaction_service = new TransactionWebServices_Service();
            TransactionWebServices transaction_port = transaction_service.getTransactionWebServicesPort();
        %>
    </head>
    <body style="background: #06BF7B;">        
        <%
            HttpServletResponse httpResponse = response;
            httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            httpResponse.setHeader("Pragma", "no-cache");
            httpResponse.setDateHeader("Expires", 0);
            session = request.getSession(false);
            String employeeId = (String) session.getAttribute("employeeId");
            if (session == null || session.getAttribute("employeeId") == null) {
                response.sendRedirect("../employee_login.jsp");
                return;
            }
            int branchId = 0;
            String branchName = "";
            if (session != null && session.getAttribute("branchStationed") != null) {
                branchId = Integer.parseInt((String) session.getAttribute("branchStationed"));
                HashMap<Integer, String> branchMap = new HashMap<>();
                List<StringArray> branchArray = branch_port.selectAllBranches();
                for (StringArray branchStringArray : branchArray) {
                    String[] branch = branchStringArray.getItem().toArray(new String[0]);
                    branchMap.put(Integer.parseInt(branch[0]), branch[2]);
                }
                branchName = branchMap.getOrDefault(branchId, "");
            }
            String firstName = (String) session.getAttribute("firstName");
            String lastName = (String) session.getAttribute("lastName");
            String action = request.getParameter("action");
            try {
                if (action.equals("logout")) {
                    if (session != null) {
                        session.invalidate();
                    }
                    response.sendRedirect("../employee_login.jsp");
                    return;
                }
            } catch (Exception error) {
                error.printStackTrace();
            }
        %>
        <div class="container-fluid p-0">
            <div class="employee_page" style="width:100%; overflow: hidden">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="employee_page_headers" style="width:100%; background-color: #011204; color:white; border-radius: 10px; overflow: hidden; padding:10px;">
                            <h2>Welcome <%= firstName%> <%= lastName%></h2>
                            <p>Employee ID: <%= employeeId%></p>
                            <p>Branch Stationed: <%= branchId%> <%= branchName%></p>
                            <a class="btn btn-sm btn-danger" href="manage_transactions_view.jsp?action=logout">Logout</a>
                        </div>
                    </div>
                </div>         
                <div class="row">
                    <div class="col-sm-12">
                        <%
                            try {
                                String controlNumberParam = request.getParameter("controlNumber");
                                int controlNumber = Integer.parseInt(controlNumberParam);
                                if (action.equals("pay")) {
                                    List<String> transaction = transaction_port.selectTransaction(controlNumber);
                                    String feeStatus = transaction.get(1);
                                    if ("Paid".equals(feeStatus)) {
                                        response.sendRedirect("manage_transactions_view.jsp");
                                    } else {
                                        transaction_port.payServiceFee(controlNumber);
                                        response.sendRedirect("manage_transactions_view.jsp");
                                    }
                                } else if (action.equals("send")) {
                                    List<String> transaction = transaction_port.selectTransaction(controlNumber);
                                    String feeStatus = transaction.get(1);
                                    int branchSent = Integer.parseInt(transaction.get(10));
                                    int branchWithdrawn = Integer.parseInt(transaction.get(11));
                                    if ("Unpaid".equals(feeStatus) || branchSent != 0 || branchWithdrawn != 0) {
                                        response.sendRedirect("manage_transactions_view.jsp");
                                    } else {
                                        transaction_port.sendAmount(controlNumber, Integer.parseInt(employeeId), branchId);
                                        response.sendRedirect("manage_transactions_view.jsp");
                                    }
                                } else if (action.equals("withdraw")) {
                                    List<String> transaction = transaction_port.selectTransaction(controlNumber);
                                    int branchSent = Integer.parseInt(transaction.get(10));
                                    int branchWithdrawn = Integer.parseInt(transaction.get(11));
                                    if (branchSent != 0 && branchWithdrawn == 0) {
                                        transaction_port.withdrawAmount(controlNumber, Integer.parseInt(employeeId), branchId);
                                        response.sendRedirect("manage_transactions_view.jsp");
                                    } else {
                                        response.sendRedirect("manage_transactions_view.jsp");
                                    }
                                } else if (action.equals("delete")) {
                                    List<String> transaction = transaction_port.selectTransaction(controlNumber);
                                    String feeStatus = transaction.get(1);
                                    if ("Paid".equals(feeStatus)) {
                                        response.sendRedirect("manage_transactions_view.jsp");
                                    } else {
                                        transaction_port.deleteTransaction(controlNumber);
                                        response.sendRedirect("manage_transactions_view.jsp");
                                    }
                                }
                            } catch (Exception error) {
                                error.printStackTrace();
                            }
                        %>
                        <h2>Manage Transactions</h2>
                        <form action="<%=request.getRequestURI()%>" method="get">
                            <div class="row">
                                <div class="col-sm-6">
                                    <input class="form-control border-secondary" type="text" id="keyword" name="keyword" placeholder="Search Transactions">
                                </div>
                                <div class="col-sm-6">
                                    <input class="btn btn-warning btn-sm" type="submit" value="Search">
                                </div>
                            </div>
                        </form>
                        <div class="transaction_table_wrapper" style="width:100%; overflow:scroll">
                            <div class="transaction_table_wrapper" style="width:200vw;">
                                <table class="table table-bordered table-striped border-secondary mt-2">
                                    <thead class="table-success">
                                        <tr>
                                            <th style="width:130px">Actions</th>
                                            <th>Control Number</th>
                                            <th>Fee Status</th>
                                            <th>Service Fee</th>
                                            <th>Sender Name</th>
                                            <th>Sender Contact Number</th>
                                            <th>Receiver Name</th>
                                            <th>Receiver Contact Number</th>
                                            <th>Amount</th>
                                            <th>Sender Employee</th>
                                            <th>Receiver Employee</th>
                                            <th>Branch Sent</th>
                                            <th>Branch Withdrawn</th>
                                            <th>Date Sent</th>
                                            <th>Date Withdrawn</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            List<StringArray> transactionArray = transaction_port.selectAllTransactions();
                                            List<String[]> transactions = new ArrayList<>();
                                            for (StringArray transactionStringArray : transactionArray) {
                                                transactions.add(transactionStringArray.getItem().toArray(new String[0]));
                                            }
                                            Map<String, String> employeeMap = new HashMap<>();
                                            List<StringArray> employeeArray = employee_port.selectAllEmployees();
                                            for (StringArray employeeStringArray : employeeArray) {
                                                String[] employee = employeeStringArray.getItem().toArray(new String[0]);
                                                employeeMap.put(employee[0], employee[3] + " " + employee[4]);
                                            }
                                            Map<String, String> branchMap = new HashMap<>();
                                            List<StringArray> branchArray = branch_port.selectAllBranches();
                                            for (StringArray branchStringArray : branchArray) {
                                                String[] branch = branchStringArray.getItem().toArray(new String[0]);
                                                branchMap.put(branch[0], branch[2]);
                                            }
                                            String keyword = request.getParameter("keyword");
                                            if (keyword != null) {
                                                keyword = keyword.toLowerCase();
                                            }
                                            for (String[] transaction : transactions) {
                                                boolean matchesKeyword = true;
                                                if (keyword != null && !keyword.trim().isEmpty()) {
                                                    matchesKeyword = false;
                                                    for (int i = 0; i < transaction.length; i++) {
                                                        String field = transaction[i];
                                                        if (field != null && field.toLowerCase().contains(keyword)) {
                                                            matchesKeyword = true;
                                                            break;
                                                        }
                                                        if ((i == 7 || i == 8) && employeeMap.containsKey(field) && employeeMap.get(field).toLowerCase().contains(keyword)) {
                                                            matchesKeyword = true;
                                                            break;
                                                        }
                                                        if ((i == 9 || i == 10) && branchMap.containsKey(field) && branchMap.get(field).toLowerCase().contains(keyword)) {
                                                            matchesKeyword = true;
                                                            break;
                                                        }
                                                    }
                                                }
                                                if (matchesKeyword) {
                                        %>
                                        <tr>
                                            <td>
                                                <a class="btn btn-success btn-sm" href="manage_transactions_view.jsp?action=pay&controlNumber=<%= transaction[0]%>" onclick="return confirm('Pay service fee? This action cannot be undone');">Pay</a>
                                                <a class="btn btn-primary btn-sm" href="manage_transactions_view.jsp?action=send&controlNumber=<%= transaction[0]%>" onclick="return confirm('Send amount? Make sure it is already been paid');">Send</a>
                                                <a class="btn btn-warning btn-sm" href="manage_transactions_view.jsp?action=withdraw&controlNumber=<%= transaction[0]%>" onclick="return confirm('Withdraw amount? Make sure it is already been sent');">Withdraw</a>
                                                <a class="btn btn-danger btn-sm" href="manage_transactions_view.jsp?action=delete&controlNumber=<%= transaction[0]%>" onclick="return confirm('Delete transaction? Make sure it is still unpaid');">Delete</a>
                                            </td>
                                            <td><%= transaction[0]%></td>
                                            <td><%= transaction[1]%></td>
                                            <td><%= transaction[2]%></td>
                                            <td><%= transaction[3]%></td>
                                            <td><%= transaction[4]%></td>
                                            <td><%= transaction[5]%></td>
                                            <td><%= transaction[6]%></td>
                                            <td><%= transaction[7]%></td>
                                            <td><%= ("0".equals(transaction[8])) ? "" : transaction[8] + " " + employeeMap.getOrDefault(transaction[8], "")%></td>
                                            <td><%= ("0".equals(transaction[9])) ? "" : transaction[9] + " " + employeeMap.getOrDefault(transaction[9], "")%></td>
                                            <td><%= ("0".equals(transaction[10])) ? "" : transaction[10] + " " + branchMap.getOrDefault(transaction[10], "")%></td>
                                            <td><%= ("0".equals(transaction[11])) ? "" : transaction[11] + " " + branchMap.getOrDefault(transaction[11], "")%></td>
                                            <td><%= (transaction[12] != null && !transaction[12].isEmpty()) ? transaction[12] : ""%></td>
                                            <td><%= (transaction[13] != null && !transaction[13].isEmpty()) ? transaction[13] : ""%></td>
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
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
    </body>
</html>