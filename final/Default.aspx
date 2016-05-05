<%@ Page Title="" Language="C#" MasterPageFile="~/MainLayout.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" EnableEventValidation="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="~/UserControls/SlideShow.ascx" TagPrefix="uc1" TagName="SlideShow" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
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
                    <img src="images/logo.jpg" alt="" title="Team" />
 
        </div>
        <div id="slideshow-pager">
                <div class="slideshow-button pauser">
                    <a href="https://www.facebook.com/BraveDoing/ " target="_blank">
                        <h2>DooHee Choi</h2>
                        <p class="description">CEO</p>
                        <p class="show">Contect me: 416-822-8772 / dooing84@gmail.com</p>
                    </a>
                </div>
                
        </div>
    </div>
    
</section>



<section class="main_content main_content_home">


    <uc1:SlideShow runat="server" id="SlideShow1" Title="Best Sellers" OnClick="SlideShow1_Click" categoryID="17"
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

