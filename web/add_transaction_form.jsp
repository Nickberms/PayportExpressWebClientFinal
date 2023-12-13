<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="extra_features.*"%>
<%@page import="web_services.*"%>
<%@page import="java.util.*"%>
<%@page import="javax.servlet.http.*"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Add New Transaction</title>
        <link rel="stylesheet" type="text/css" href="styles.css">
        <%
            TransactionWebServices_Service transaction_service = new TransactionWebServices_Service();
            TransactionWebServices transaction_port = transaction_service.getTransactionWebServicesPort();
        %>
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
            String action = request.getParameter("action");
            try {
                if (action.equals("insert")) {
                    Float serviceFee = Float.parseFloat(request.getParameter("serviceFee"));
                    String senderFirstName = request.getParameter("senderFirstName").trim();
                    senderFirstName = NameFormatter.formatName(senderFirstName);
                    String senderMiddleName = request.getParameter("senderMiddleName").trim();
                    senderMiddleName = NameFormatter.formatName(senderMiddleName);
                    String senderLastName = request.getParameter("senderLastName").trim();
                    senderLastName = NameFormatter.formatName(senderLastName);
                    String senderNameSuffix = request.getParameter("senderNameSuffix");
                    String senderName = senderFirstName;
                    if (senderMiddleName != null && !senderMiddleName.isEmpty()) {
                        senderName += " " + senderMiddleName;
                    }
                    senderName += " " + senderLastName;
                    if (senderNameSuffix != null && !senderNameSuffix.isEmpty()) {
                        senderName += " " + senderNameSuffix;
                    }
                    String senderContactNumber = request.getParameter("senderContactNumber");
                    String receiverFirstName = request.getParameter("receiverFirstName").trim();
                    receiverFirstName = NameFormatter.formatName(receiverFirstName);
                    String receiverMiddleName = request.getParameter("receiverMiddleName").trim();
                    receiverMiddleName = NameFormatter.formatName(receiverMiddleName);
                    String receiverLastName = request.getParameter("receiverLastName").trim();
                    receiverLastName = NameFormatter.formatName(receiverLastName);
                    String receiverNameSuffix = request.getParameter("receiverNameSuffix");
                    String receiverName = receiverFirstName;
                    if (receiverMiddleName != null && !receiverMiddleName.isEmpty()) {
                        receiverName += " " + receiverMiddleName;
                    }
                    receiverName += " " + receiverLastName;
                    if (receiverNameSuffix != null && !receiverNameSuffix.isEmpty()) {
                        receiverName += " " + receiverNameSuffix;
                    }
                    String receiverContactNumber = request.getParameter("receiverContactNumber");
                    Float amount = Float.parseFloat(request.getParameter("amount"));
                    try {
                        if (senderFirstName.isEmpty() || senderLastName.isEmpty() || receiverFirstName.isEmpty() || receiverLastName.isEmpty() || amount <= 0) {
                            out.println("Sorry, invalid input. Please try again.");
                        } else {
                            transaction_port.insertNewTransaction(serviceFee, senderName, senderContactNumber, receiverName, receiverContactNumber, amount);
                            out.println("Submission successful. You can come to any of our branches at any time to confirm and process your transaction.");
                        }
                    } catch (Exception error) {
                        error.printStackTrace();
                    }
                }
            } catch (Exception error) {
                error.printStackTrace();
            }
        %>
        <div class="container-fluid p-0">
            <div style="width:100%; overflow:hidden">
                <header>
                    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
                        <a class="navbar-brand" href="add_transaction_form.jsp">
                            <img src="assets/images/logo.png" class="img-fluid add_transaction_logo">
                            <p class="text-start add_transaction_text">Payport Express</p>
                        </a>
                        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                            <span class="navbar-toggler-icon"></span>
                        </button>
                    </nav>
                </header>
                <div class="row">
                    <div class="col-sm-12">
                        <div class="add_transaction_panel_text">
                            <h2 class="text-center">Payport Express Transaction Form</h2>
                        </div>
                    </div>
                </div>
                <form action="add_transaction_form.jsp?action=insert" method="post">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="add_transaction_div_sender_details">
                                <h3 class="text-center">Sender Details</h3>
                                <div class="row">
                                    <div class="col-sm-3">
                                        <label class="form-label" for="senderFirstName">First Name:</label>
                                        <input class="form-control border-secondary" type="text" id="senderFirstName" name="senderFirstName" oninput="LettersOnly(this)" required>
                                    </div>
                                    <div class="col-sm-3">
                                        <label class="form-label" for="senderMiddleName">Middle Name:</label>
                                        <input class="form-control border-secondary" type="text" id="senderMiddleName" name="senderMiddleName" oninput="LettersOnly(this)">
                                    </div>
                                    <div class="col-sm-3">
                                        <label class="form-label" for="senderLastName">Last Name:</label>
                                        <input class="form-control border-secondary" type="text" id="senderLastName" name="senderLastName" oninput="LettersOnly(this)" required>
                                    </div>
                                    <div class="col-sm-3">
                                        <label class="form-label" for="senderNameSuffix">Name Suffix:</label>
                                        <select id="senderNameSuffix" name="senderNameSuffix" class="form-select border-secondary">
                                            <option value="">None</option>
                                            <option value="Sr.">Sr.</option>
                                            <option value="Jr.">Jr.</option>
                                            <option value="III">III</option>
                                            <option value="IV">IV</option>
                                            <option value="V">V</option>
                                            <option value="VI">VI</option>
                                            <option value="VII">VII</option>
                                            <option value="VIII">VIII</option>
                                            <option value="IX">IX</option>
                                            <option value="X">X</option>
                                        </select>
                                    </div>
                                </div>
                                <label class="form-label" for="senderContactNumber">Contact Number:</label>
                                <input class="form-control border-secondary" type="text" id="senderContactNumber" name="senderContactNumber" oninput="NumbersOnly(this)" minlength="3" maxlength="15" required>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="add_transaction_div_sender_details">
                                <h3 class="text-center">Receiver Details</h3>
                                <div class="row">
                                    <div class="col-sm-3">
                                        <label class="form-label" for="receiverFirstName">First Name:</label>
                                        <input class="form-control border-secondary" type="text" id="receiverFirstName" name="receiverFirstName" oninput="LettersOnly(this)" required>
                                    </div>
                                    <div class="col-sm-3">
                                        <label class="form-label" for="receiverMiddleName">Middle Name:</label>
                                        <input  class="form-control border-secondary" type="text" id="receiverMiddleName" name="receiverMiddleName" oninput="LettersOnly(this)">
                                    </div>
                                    <div class="col-sm-3">
                                        <label class="form-label" for="receiverLastName">Last Name:</label>
                                        <input class="form-control border-secondary" type="text" id="receiverLastName" name="receiverLastName" oninput="LettersOnly(this)" required>
                                    </div>
                                    <div class="col-sm-3">
                                        <label class="form-label" for="receiverNameSuffix">Name Suffix:</label>
                                        <select class="form-control border-secondary" id="receiverNameSuffix" name="receiverNameSuffix">
                                            <option value="">None</option>
                                            <option value="Sr.">Sr.</option>
                                            <option value="Jr.">Jr.</option>
                                            <option value="III">III</option>
                                            <option value="IV">IV</option>
                                            <option value="V">V</option>
                                            <option value="VI">VI</option>
                                            <option value="VII">VII</option>
                                            <option value="VIII">VIII</option>
                                            <option value="IX">IX</option>
                                            <option value="X">X</option>
                                        </select>
                                    </div>
                                </div>
                                <label class="form-label" for="receiverContactNumber">Contact Number:</label>
                                <input class="form-control border-secondary" type="text" id="receiverContactNumber" name="receiverContactNumber" oninput="NumbersOnly(this)" minlength="3" maxlength="15" required>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="add_transaction_div_sender_details">
                                <h3 class="text-center">Amount Money</h3>
                                <div class="row">
                                    <div class="col-sm-6">
                                        <label class="form-label" for="amount">Amount:</label>
                                        <input class="form-control border-secondary" type="text" id="amount" name="amount" oninput="NumbersOnly(this); CalculateServiceFee();" maxlength="6" required>
                                    </div>
                                    <div class="col-sm-6">
                                        <label class="form-label" for="serviceFee">Service Fee:</label>
                                        <input class="form-control border-secondary" type="text" id="serviceFee" name="serviceFee" readonly required>
                                    </div>
                                </div>
                                <div class="row mt-2">
                                    <div class="col-sm-6">
                                        <div class="d-grid gap-2">
                                            <button class="btn btn-success btn-sm" type="submit">Submit</button>
                                        </div>
                                    </div>
                                    </form>
                                    <div class="col-sm-6">
                                        <form action="index.jsp">
                                            <div class="d-grid gap-2">
                                                <input class="btn btn-danger btn-sm" type="submit" value="Cancel">
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div> 
        </div>       
        <script>
            function LettersOnly(inputField) {
                var pattern = /^[A-Za-z]+( [A-Za-z]+)*$/;
                var inputValue = inputField.value;
                if (!pattern.test(inputValue)) {
                    inputField.value = inputValue.replace(/[^A-Za-z\s]/g, '').replace(/\s{2,}/g, ' ');
                }
            }
            function NumbersOnly(inputField) {
                var pattern = /^[0-9]+$/;
                var inputValue = inputField.value;
                if (!pattern.test(inputValue)) {
                    inputField.value = inputValue.replace(/[^0-9]/g, '');
                }
            }
            function CalculateServiceFee() {
                var amount = document.getElementById('amount').value;
                var serviceFee = isNaN(amount) ? 0 : (parseFloat(amount) * 0.02).toFixed(2);
                document.getElementById('serviceFee').value = serviceFee;
            }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    </body>
</html>