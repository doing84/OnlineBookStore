<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BookList.ascx.cs" Inherits="UserControls_BookList" %>


    <table>
        <tr>
            <td colspan="3">
                <asp:Label ID="pagingLabel" runat="server" CssClass="PagingText" Visible="false" />
                &nbsp;&nbsp;
                <asp:HyperLink ID="previousLink" runat="server" CssClass="PagingText" Visible="false">Previous</asp:HyperLink>
                &nbsp;&nbsp;
                <asp:HyperLink ID="nextLink" runat="server" CssClass="PagingText" Visible="false">Next</asp:HyperLink>
            </td>
        </tr>
        <tr>
            <asp:DataList ID="bookList" runat="server" RepeatDirection="Horizontal" RepeatColumns="3" CellPadding="5" CellSpacing="5" RepeatLayout="Table" Width="800px" >
                <ItemTemplate>
                    <td valign="top">
                        <a href="BookDetails.aspx?BookID=<%#Eval("BookID") %>" style="text-decoration:none;">
                             <img src='/BookImg/<%#Eval("Image") %>' alt="" title="<%#Eval("Title") %>" width="200" height="300" class="cover" /><br />
                            <asp:Label ID="bookTitle" runat="server" Text='<%#Eval("Title") %>' /> 
                           <div class="price "><span>$</span><%#Eval("Price").ToString().Substring(0, Eval("Price").ToString().Length - 2)%></div>
                        </a>
                    </td>
                </ItemTemplate>
            </asp:DataList>

        </tr>
    </table>