<%@ Page Title="" Language="C#" MasterPageFile="~/MainLayout.master" EnableEventValidation="false" AutoEventWireup="true" CodeFile="WishList.aspx.cs" Inherits="Store_WishList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script language="javascript">
        function askConfirm()
        {
            return confirm("Do you really want to delete this book?");
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <table>
        <tr>
            <td colspan="6">
                <asp:Label ID="pagingLabel" runat="server" CssClass="PagingText" Visible="false" />
                &nbsp;&nbsp;
                <asp:HyperLink ID="previousLink" runat="server" CssClass="PagingText" Visible="false">Previous</asp:HyperLink>
                &nbsp;&nbsp;
                <asp:HyperLink ID="nextLink" runat="server" CssClass="PagingText" Visible="false">Next</asp:HyperLink>
            </td>
        </tr>
        <tr>
            <asp:DataList ID="wishLIst" runat="server" RepeatDirection="Horizontal" RepeatColumns="3" CellPadding="5" CellSpacing="5" RepeatLayout="Table" Width="800px">
                <ItemTemplate>
                    <td>
                        <asp:ImageButton ID="del" runat="server" ImageUrl="../images/x-gif.gif" CommandName="wishListDel" CommandArgument='<%#Eval("BookID") %>' OnClientClick="if (!askConfirm()) return false;" OnCommand="DelBtn_Click" />
                    </td>
                    <td>
                        
                        <a href="BookDetail.aspx?BookID=<%#Eval("BookID") %>" style="text-decoration:none;">
                             <img src='/BookImg/<%#Eval("Thumbnail") %>' alt="" title="<%#Eval("Title") %>" width="200" height="200" class="cover" /><br />
                            <asp:Label ID="bookTitle" runat="server" Text='<%#Eval("Title") %>' /> 
                           <div class="price "><span>$</span><%#Eval("Price").ToString().Substring(0, Eval("Price").ToString().Length - 2)%></div>
                        </a>
                    </td>
                </ItemTemplate>
            </asp:DataList>

        </tr>
    </table>
</asp:Content>

