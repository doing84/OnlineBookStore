<%@ Page Title="" Language="C#" MasterPageFile="~/MainLayout.master" AutoEventWireup="true" CodeFile="ShoppingCartDetails.aspx.cs" Inherits="Store_ShoppingCartDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:Label ID="titleLabel" runat="server" Text="Your Shopping Cart" CssClass="ShoppingCartTitle" />
  <br />
  <asp:Label ID="statusLabel" CssClass="AdminPageText" ForeColor="Red" runat="server" /><br />
  <asp:GridView ID="grid" runat="server" AutoGenerateColumns="False" DataKeyNames="BookID" Width="100%" BorderWidth="0px" OnRowDeleting="grid_RowDeleting" OnSelectedIndexChanged="grid_SelectedIndexChanged">
    <Columns>
      <asp:BoundField DataField="Title" HeaderText="Title" ReadOnly="True" SortExpression="Name" >
        <ControlStyle Width="100%" />
      </asp:BoundField>
      <asp:BoundField DataField="Price" DataFormatString="{0:c}" HeaderText="Price"  ReadOnly="True"
        SortExpression="Price" />
      <asp:TemplateField HeaderText="Quantity">
        <ItemTemplate>
          <asp:TextBox ID="editQuantity" runat="server" CssClass="GridEditingRow" Width="100px" MaxLength="2" Text='<%#Eval("Quantity")%>' />
        </ItemTemplate>
      </asp:TemplateField>
      <asp:BoundField DataField="Subtotal" DataFormatString="{0:c}" HeaderText="Subtotal"
        ReadOnly="True" SortExpression="Subtotal" />
      <asp:ButtonField ButtonType="Button" CommandName="Delete" Text="Delete" >
        <ControlStyle CssClass="SmallButtonText " />
      </asp:ButtonField>
    </Columns>
  </asp:GridView>
  <table width="100%">
    <tr>
      <td>
        <span class="ProductDescription">
          Total amount:
        </span>
</td>
        <td>
        <asp:Label ID="totalAmountLabel" runat="server" Text="Label" CssClass="ProductPrice" />
      </td>
      <td align="right">
        <asp:Button ID="updateButton" runat="server" Text="Update Quantities" Width="200px" CssClass="button button_small" OnClick="updateButton_Click" /><br />
        </td>
        <td align="right">
        <asp:Button ID="checkoutButton" runat="server" CssClass="button button_small"  Width="200px" Text="Proceed to Checkout" OnClick="checkoutButton_Click" />
      </td>
    </tr>
  </table>
  <br />
  <asp:Button ID="continueShoppingButton" runat="server" Text="Continue Shopping" CssClass="button button_small" OnClick="continueShoppingButton_Click" /><br />
  <br />
</asp:Content>

