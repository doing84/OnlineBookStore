<%@ Page Title="" Language="C#" MasterPageFile="~/MainLayout.master" AutoEventWireup="true" CodeFile="BookDetails.aspx.cs" Inherits="Store_BookDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
       <script language="javascript" type="text/javascript">
           function submit_Click()
           {
                   //check validation

                   var title = document.getElementById('<%=reviewTl.ClientID%>');
                var editor = document.getElementById('<%=editor1.ClientID%>');
                var info = '<%=Request.Cookies["userInfo"]%>';

                if (info == "") {
                    alert("You need to login first before writting review");
                    return false;
                }

                if (title.value == "") {
                    alert("Please enter your title");
                    title.focus();
                    return false;
                }

                if (editor.value == "") {
                    alert("Please enter your review");
                    editor.focus();
                    return false;
                }

                return true;
           }

           function del(obj)
           {

               if (confirm("Do you want to delete your review?")) {
                   return true;
               }

               return false;
           }
    </script>
       <style type="text/css">
           .thumb {
               width: 261px;
           }
       </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <section class="title" id="mainCoverBg">

    <div class="wrap">
        <br /><br />
    <table width="100%" style="vertical-align: text-top">
        <tr>
            <td style="width:20%;">
                <div class="thumb" style="vertical-align: top">
                    <asp:Image ID="mainCover" runat="server" class="cover" /><br /><br />
                
                     <asp:Button ID="continueShoppingButton" runat="server" Text="Continue Shopping" CssClass="button button_large"  OnClick="continueShoppingButton_Click" /><br />

                </div>
            </td>
            <td style="width:70%;">
                <h2 id="bookTitle"><asp:Label ID="bookTitle" runat="server"></asp:Label></h2>
                
                <ul itemprop="offers" itemscope itemtype="http://schema.org/Offer" style="margin-top:0px;">
                    <li>
                        <span>Author: </span>
                        <asp:Label ID="Author" runat="server"></asp:Label>
                    </li>
                    <li>
                        <span>ISBN : </span> 
                        <asp:Label ID="ISBN" runat="server"></asp:Label>
                    </li>
                    <li>
                        <span>List Price : </span> 
                        <asp:Label ID="ListPrice" runat="server"></asp:Label>
                    </li>
                     <li>
                         <span>Year : </span> 
                         <asp:Label ID="Year" runat="server"></asp:Label>
                    </li>
                </ul>
                <hr />
                <div id="extra-info" class="description">
                    <span itemprop="description">
                        <asp:Label ID="Desc" runat="server" Width="580px"></asp:Label>
                    </span>
                </div>
                <hr />
                <p>
                      <asp:Button ID="addToCartButton" runat="server" Text="Add to Cart" CssClass="button button_medium" OnClick="addToCartButton_Click" Height="50px" />
                </p>
                <p>
                    <a href="/Store/ShoppingCartDetails.aspx" class="button button_small inline">View Cart &raquo;</a>

                    <a href='/Store/WishList.aspx?BookID=<%=BookID %>' class="button button_small icon">
                        <span class="icon">
                            <span aria-hidden="true" class="icon-gift"></span>
                            <span class="screen_reader_text">Gift</span>
                        </span>
                        Add to Wishlist
                    </a>
                </p>   
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="lblError" runat="server"></asp:Label>
                
                <asp:ScriptManager ID="ScriptManager1" runat="server">
                </asp:ScriptManager>
                
                <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <table>
                            <tr>
                                <td style="height:30px" colspan="2"></td>
                            </tr>
                            <tr>
                                <td>Title : </td>
                                <td style="height:30px">
                                    <asp:TextBox ID="reviewTl" ValidationGroup="comm" runat="server" Width="300"></asp:TextBox> 
                                </td>
                            </tr>
                            <tr>
                                <td>Review : </td>
                                <td>
                                     <asp:TextBox ID="editor1" runat="server" ValidationGroup="comm" TextMode="MultiLine" Rows="6" Width="300"></asp:TextBox> 
  
                                </td>
                            </tr>
                            <tr>
                                <td align="right" colspan="2">
                                   <asp:Button ID="addComm" ValidationGroup="comm" runat="server" Text="Write" OnClientClick="if (!submit_Click()) return false;" OnClick="addComm_Click" />
                                    
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </asp:UpdatePanel>

            </td>
            <td>
                 <asp:UpdatePanel ID="commListUp" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                    
                    <asp:ListView ID="commList" runat="server" ItemPlaceholderID="commItemList" OnItemDataBound="ListView_ItemDataBound">
                        <LayoutTemplate>
                            <p>&nbsp;</p>
                            <table cellpadding="0" cellspacing="3" border="0" width="800px">
	                            <caption><asp:Label ID="Label1" runat="server" /></caption>
	                            <asp:PlaceHolder ID="commItemList" runat="server" />
	                            <tfoot>
            	                   
	                            </tfoot>
            	                
	                         </table>
                        </LayoutTemplate>
                        <ItemTemplate>
                                <tr>
                                    <td style="width:60px; padding:5px" align="center" valign="top">
                                        <%#Eval("UserID") %>
                                    </td>
                                    <td align="left" style="padding:5px">
                                        <b><%#Eval("Title") %></b><br />
                                        <%#Eval("Description") %>
                                    </td>
                                    <td align="right" style="width:30px" valign="top">
                                        <%#Eval("DateAdded") %>
                                        <asp:ImageButton ID="x" runat="server" Visible="False" CommandName="reviewDel" CommandArgument='<%# Eval("BookID") %>' OnCommand="imgBtn_Click" OnClientClick="return del(this);" />
                                    </td>
                                </tr>
                        </ItemTemplate>
                        <EmptyDataTemplate>
                            <table cellpadding="0" cellspacing="3" border="0" width="650">
	                            <caption><asp:Label ID="Label1" runat="server" /></caption>
	                         </table>
                        </EmptyDataTemplate>
                    </asp:ListView>
                    
                    </ContentTemplate>
                </asp:UpdatePanel>

            </td>
        </tr>
    </table>

    </div>
    </section>
</asp:Content>

