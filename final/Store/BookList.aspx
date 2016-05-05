<%@ Page Title="" Language="C#" MasterPageFile="~/SubLayout.master" AutoEventWireup="true" CodeFile="BookList.aspx.cs" Inherits="Store_BookList" %>

<%@ Register src="../UserControls/BookList.ascx" tagname="BookList" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <uc1:BookList ID="BookList1" runat="server" />
</asp:Content>

