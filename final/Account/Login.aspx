<%@ Page Title="" Language="C#" MasterPageFile="~/MainLayout.master" EnableEventValidation="false" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Users_Login" %>

<%@ Register Src="~/UserControls/SlideShow.ascx" TagPrefix="uc1" TagName="SlideShow" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link rel="stylesheet" href="/Css/compiled.css?v=201404281344" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<section class="banners banners_home">

    <div id="slideshow">
        <div id="slideshow-banner" class="cycle-slideshow" 
            data-cycle-fx="scrollVert" 
            data-cycle-timeout="5000" 
            data-cycle-slides="> a" 
            data-cycle-pause-on-hover=".pauser"
            data-cycle-pager="#slideshow-pager" 
            data-cycle-pager-event="mouseover"            
            data-cycle-pager-template="" 
            data-cycle-swipe="true"
            data-cycle-swipe-fx="scrollHorz"
            >
          <!--   <div class="login_box">
             <table>
             	<tr> 
             		<td>
                    <label> Login :</label>
                    
                    </td>
                    <td>
                    <input type="text" width="120px" height="20px">
                    </td>
                    
                </tr>
                <tr>
                	<td> 
                    <label> Password :</label>
                    </td>
                    <td>
                    <input type="password" width="120px" height="20px">
                    </td>
                
            </table> 
             
             </div>
        </div>
        -->
        <div class="panel clear narrow">
        <h2>Sign in to your Book Clip account</h2>

        <form action="/Account/Login" method="post">

            <input name="__RequestVerificationToken" type="hidden" value="CpGgiS7Rxc77VrPdGbD_NDaYajOKsCdY-2Net4_JalyVSyZixVTpRpouaIMj7G-rXbuGnyQBNXrLbQrbDLskKSKxn3g2fMcRVnV43ca8J4N989RUUU2tuz3jatqRGGz-iiGm6A2" width="120px" />            

            <input type="hidden" name="returnUrl" />
            <label for="UserName">Your ID</label>
            <asp:TextBox ID="userID" runat="server" class="input"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Please enter your ID" ForeColor="#CC0000" ControlToValidate="userID" ValidationGroup="login"></asp:RequiredFieldValidator>
            
            
            <label for="Password">Your password</label>
            <asp:TextBox ID="pwd" class="input" runat="server" TextMode="Password"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Please enter your password" ForeColor="#CC0000" ControlToValidate="pwd" ValidationGroup="login"></asp:RequiredFieldValidator>

            <label class="checkbox">	
                <input checked="checked" class="checkbox" data-val="true" data-val-required="The Remember me? field is required." id="Checkbox1" name="RememberMe" type="checkbox" value="true" /><input name="RememberMe" type="hidden" value="false" />
                Remember me?
            </label>
            <asp:Button ID="login" OnClick="login_Click" runat="server" class="button button_medium" Text="Login" ValidationGroup="login" />
             <a href="/Account/Register.aspx" class="forgot">REGISTRATION</a>
        </form>

        
    </div>
    
</section>

<section class="main_content main_content_home">
    <uc1:SlideShow runat="server" ID="SlideShow1" Title="Best Sellers" OnClick="SlideShow1_Click" categoryID="17"
       ImageHeight="300" ImageWidth="200" TitleAlign="Center" />
       
    <uc1:SlideShow runat="server" id="SlideShow2" Title="New Arrivals" OnClick="SlideShow1_Click" categoryID="16"
       ImageHeight="300" ImageWidth="200" TitleAlign="Center" />

    <uc1:SlideShow runat="server" id="SlideShow3" Title="Special Deals" OnClick="SlideShow1_Click" categoryID="19"
       ImageHeight="300" ImageWidth="200" TitleAlign="Center" />

    <uc1:SlideShow runat="server" id="SlideShow4" Title="Kids" OnClick="SlideShow1_Click" categoryID="18"
       ImageHeight="300" ImageWidth="200" TitleAlign="Center" />

    <p class="home_view_more"><a class="button" href="/Store/BookList.aspx?CategoryID=0">View More Categories</a></p>

</section>



</asp:Content>

