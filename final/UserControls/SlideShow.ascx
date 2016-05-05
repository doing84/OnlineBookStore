<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SlideShow.ascx.cs" Inherits="UserControls_SlideShow" %>


<div class="book_carousel ">
    <!-- caption -->
    <header>
        <h2 class="title"><span><asp:Label ID="lblTitle" runat="server" Text="Slide Show"></asp:Label></span></h2>
 <a href="/Store/BookList.aspx?CategoryID=<%= categoryID%>" class="view_all">View All</a>     </header>
               <!-- slides -->

    <ul class="book_covers">
            <asp:DataList ID="dataList" runat="server" RepeatDirection="Horizontal" OnItemDataBound="dataList_ItemCreated"
                            ShowHeader="False" CellPadding="0" ShowFooter="False" OnItemCreated="dataList_ItemCreated" SeparatorStyle-Wrap="False" FooterStyle-Wrap="False" HeaderStyle-Wrap="False" EditItemStyle-Wrap="False" ItemStyle-Wrap="False" RepeatLayout="Flow">
                <ItemTemplate>
                     <li class="col">
                        <asp:HyperLink ID="viewDetail" runat="server" CssClass="icon next">
                        <asp:ImageButton ID="imgSlideShow" alt="" runat="server" CssClass="cover" />
                        </asp:HyperLink>
                        <div class="price "><span>$</span><%#Eval("Price").ToString().Substring(0, Eval("Price").ToString().Length - 2)%></div>
                     </li>
                 </ItemTemplate>
             </asp:DataList>
    </ul>
</div>