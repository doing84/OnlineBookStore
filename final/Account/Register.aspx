<%@ Page Title="" Language="C#" MasterPageFile="~/MainLayout.master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Users_Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .style1
        {
            width: 16%;
        }

    </style>

       <script language="javascript" type="text/javascript">
  
           var frm = document.forms[0];

           function submit_Click() {
               //check validation

               var userID = document.getElementById('<%=Member_ID.ClientID%>');
               var prov = document.getElementById('<%=Province.ClientID%>');
               var city = document.getElementById('<%=City.ClientID%>');
               var addr = document.getElementById('<%=Address.ClientID%>');
               var post = document.getElementById('<%=PostalCode.ClientID%>');
               var pwd = document.getElementById('<%=Pwd.ClientID%>');
               var pwd2 = document.getElementById('<%=Pwd_check.ClientID%>');

               var firstName = document.getElementById('<%=First_name.ClientID%>');
               var lastName = document.getElementById('<%=Last_name.ClientID%>');
               
               var cell1 = document.getElementById('<%=cell_phone1.ClientID%>');
               var cell2 = document.getElementById('<%=cell_phone2.ClientID%>');
               var cell3 = document.getElementById('<%=cell_phone3.ClientID%>');

               if (userID.value == "") {
                   alert("Please check your ID");
                   userID.focus();
                   return false;
               }

               if (prov.options[prov.selectedIndex].value == "0") {
                   alert("Please select your province");
                   prov.focus();
                   return false;
               }

               if (city.options[city.selectedIndex].value == "0") {
                   alert("Please select your city");
                   city.focus();
                   return false;
               }

               if (addr.value == "") {
                   alert("Please check your address");
                   addr.focus();
                   return false;
               }

               var regex = new RegExp(/^[ABCEGHJKLMNPRSTVXY]\d[ABCEGHJKLMNPRSTVWXYZ]( )?\d[ABCEGHJKLMNPRSTVWXYZ]\d$/i);

               if (post.value == "") {
                   alert("Please check your postal code");
                   post.focus();
                   return false;
               }

               if (!regex.test(post.value)) {
                   alert("Please make sure postal code is correct");
                   post.focus();
                   return false;
               }


               var regex = new RegExp(/^(?=.*\d)(?=.*[A-Z])[a-zA-Z0-9]{6,}$/);

               if (pwd.value == "") {
                   alert("Please check your password");
                   pwd.focus();
                   return false;
               }
               else if (!regex.test(pwd.value)) {
                   alert("Password must contain minimum 6 characters at least 1 Uppercase Alphabet and 1 Number");
                   pwd.focus();
                   return false;
               }
               else if (pwd2.value != pwd.value) {
                   alert("Diffrent between passwrod and confirm. Please check your password");
                   pwd2.focus();
                   return false;
               }


               if (firstName.value == "") {
                   alert("Please check your first name");
                   firstName.focus();
                   return false;
               }

               if (lastName.value == "") {
                   alert("Please check your last name");
                   lastName.focus();
                   return false;
               }

               if (cell1.value == "") {
                   alert("Please check your phone number");
                   cell1.focus();
                   return false;
               }
    
               if (cell2.value == "") {
                   alert("Please check your phone number");
                   cell2.focus();
                   return false;
               }

               if (cell3.value == "") {
                   alert("Please check your phone number");
                   cell3.focus();
                   return false;
               }

               return true;
           }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <table summary="User Registration application" style="width:60%">
    <caption>User Registration</caption>
    <thead>
        <tr>
            <th align="left" colspan="2">
                ※ You must enter your information to the field with * letter<br />
                ※ Your password must contain minimum 6 characters at least 1 Uppercase Alphabet and 1 Number<br />
            </th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td class="style1">User ID *</td>
            <td>
                <asp:ScriptManager ID="ScriptManager1" runat="server"/>
                
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:TextBox ID="Member_ID" runat="server" OnTextChanged="check_ID" ValidationGroup="member_join" AutoPostBack="True"></asp:TextBox>
                            <asp:Label ID="check_result" runat="server"></asp:Label>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Please enter your ID" ForeColor="#CC0000" ControlToValidate="Member_ID" ValidationGroup="member_join"></asp:RequiredFieldValidator>
            </td>
            
        </tr>
        <tr>
            <td class="style1">Province *</td>
            <td>
                        <asp:DropDownList ID="Province" runat="server" ValidationGroup="member_join" 
                            OnSelectedIndexChanged="Province_SelectedIndexChanged" AutoPostBack="True">
                            <asp:ListItem Value="0">---Please Select---</asp:ListItem>
                            <asp:ListItem Value="Ontario">Ontario</asp:ListItem>
                            <asp:ListItem Value="Quebec">Quebec</asp:ListItem>
                            <asp:ListItem Value="British Columbia">British Columbia</asp:ListItem>
                            <asp:ListItem Value="Alberta">Alberta</asp:ListItem>
                            <asp:ListItem Value="Manitoba">Manitoba</asp:ListItem>
                            <asp:ListItem Value="Saskatchewan">Saskatchewan</asp:ListItem>
                            <asp:ListItem Value="Nova Scotia">Nova Scotia</asp:ListItem>
                            <asp:ListItem Value="New Brunswick">New Brunswick</asp:ListItem>
                            <asp:ListItem Value="Newfoundland and Labrador">Newfoundland and Labrador</asp:ListItem>
                            <asp:ListItem Value="Prince Edward Island">Prince Edward Island</asp:ListItem>
                            <asp:ListItem Value="Northwest Territories">Northwest Territories</asp:ListItem>
                            <asp:ListItem Value="Yukon">Yukon</asp:ListItem>
                            <asp:ListItem Value="Nunavut">Nunavut</asp:ListItem>
                        </asp:DropDownList>
            </td>
        </tr>
        
        <tr>
            <td class="style1">City *</td>
            <td>
                <asp:DropDownList ID="City" runat="server" ValidationGroup="member_join">
                    <asp:ListItem Value="0">---Please select Province first---</asp:ListItem>
                </asp:DropDownList>
            </td>
        </tr>
       <tr>
            <td class="style1">Address *</td>
            <td>
                <asp:TextBox ID="Address" runat="server" ValidationGroup="member_join"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="Please enter your address" ForeColor="#CC0000" ControlToValidate="Address" ValidationGroup="member_join"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td class="style1">Postal code *</td>
            <td>
                 <asp:TextBox ID="PostalCode" runat="server" ValidationGroup="member_join"></asp:TextBox>
                 <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ErrorMessage="Please enter your postal code" ForeColor="#CC0000" ControlToValidate="PostalCode" ValidationGroup="member_join"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            
            <td class="style1">Password *</td>
            <td>
                <asp:TextBox ID="Pwd" runat="server" TextMode="Password" ValidationGroup="member_join"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Please enter your password" ForeColor="#CC0000" ControlToValidate="Pwd" ValidationGroup="member_join"></asp:RequiredFieldValidator>
             </td>
        </tr>
        <tr>
            <td class="style1">Confirm password *</td>
            <td>
                <asp:TextBox ID="Pwd_check" runat="server" TextMode="Password" ValidationGroup="member_join"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="Please enter confirm password" ForeColor="#CC0000" ControlToValidate="Pwd_check" ValidationGroup="member_join"></asp:RequiredFieldValidator>
                <asp:CompareValidator ID="CompareValidator1" runat="server" ErrorMessage="It dosen't match between password and confirm password." ForeColor="#CC0000" ControlToCompare="Pwd" ControlToValidate="Pwd_check"></asp:CompareValidator>
            </td>
            
        </tr>
        <tr>
            <td class="style1">First name *</td>
            <td>
                <asp:TextBox ID="First_name" runat="server" ValidationGroup="member_join"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="Please enter your first name" ForeColor="#CC0000" ControlToValidate="First_name" ValidationGroup="member_join"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td class="style1">Last name *</td>
            <td>
                <asp:TextBox ID="Last_name" runat="server" ValidationGroup="member_join"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" ErrorMessage="Please enter your last name" ForeColor="#CC0000" ControlToValidate="Last_name" ValidationGroup="member_join"></asp:RequiredFieldValidator>
            </td>
        </tr>
 
        <tr>
            <td class="style1">Cell phone *</td>
            <td>
                <p><asp:TextBox ID="cell_phone1" runat="server" Height ="37" Width="50" MaxLength="4" ValidationGroup="member_join"></asp:TextBox> - 
                <asp:TextBox ID="cell_phone2" runat="server" Height ="37" Width="50" MaxLength="4" ValidationGroup="member_join"></asp:TextBox> - 
                <asp:TextBox ID="cell_phone3" runat="server" Height ="37" Width="50" MaxLength="4" ValidationGroup="member_join"></asp:TextBox></p>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ErrorMessage="Please enter your cell phone number" ForeColor="#CC0000" ControlToValidate="cell_phone2" ValidationGroup="member_join"></asp:RequiredFieldValidator>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="Please enter your cell phone number" ForeColor="#CC0000" ControlToValidate="cell_phone1" ValidationGroup="member_join"></asp:RequiredFieldValidator>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ErrorMessage="Please enter your cell phone number" ForeColor="#CC0000" ControlToValidate="cell_phone3" ValidationGroup="member_join"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td class="style1">Email</td>
            <td>
                <asp:TextBox ID="Email" runat="server" ValidationGroup="member_join"></asp:TextBox>
            </td>
        </tr>
    </tbody>
    <tfoot>
        <tr>
            <td colspan="2" style="text-align:center;">
                <asp:Button ID="submit" runat="server" Text="Save" onclick="submit_Click" OnClientClick="if (!submit_Click()) return false;" ValidationGroup="member_join" />
                <asp:Button ID="cancel" runat="server" Text="Cancel" />
            </td>
        </tr>
        
    </tfoot>
        
   </table>

</asp:Content>

