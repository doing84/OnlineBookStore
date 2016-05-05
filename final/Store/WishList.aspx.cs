using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections.Specialized;


public partial class Store_WishList : ScriptPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        setControl();
    }

    private void setControl()
    {
        //set category ID from query string
        string BookID = Request.QueryString["BookID"];
        string userID = string.Empty;

        if(Convert.ToString(Request.Cookies["userInfo"]) != "")
        {
            userID = Request.Cookies["userInfo"]["mem_ID"];
        }
        else
        {
            ErrorMsg("You need to login.");
        }

        //set page number from query string
        string page = Request.QueryString["page"];
        if (page == null) page = "1";

        // How many pages of products?
        int howManyPages = 1;
        bool result = CatalogAccess.CreateWishList(userID, Int32.Parse(BookID));

        // Retrieve list of Wish List
            wishLIst.DataSource = CatalogAccess.GetWishList(userID, Int32.Parse(page), out howManyPages);
            wishLIst.DataBind();
        
        // display paging controls
        if (howManyPages > 1)
        {
            // have the current page as integer
            int currentPage = Int32.Parse(page);
            // make controls visible
            pagingLabel.Visible = true;
            previousLink.Visible = true;
            nextLink.Visible = true;
            // set the paging text
            pagingLabel.Text = "Page " + page + " of " + howManyPages.ToString();
            // create the Previous link
            if (currentPage == 1)
                previousLink.Enabled = false;
            else
            {
                NameValueCollection query = Request.QueryString;
                string paramName, newQueryString = "?";
                for (int i = 0; i < query.Count; i++)
                    if (query.AllKeys[i] != null)
                        if ((paramName = query.AllKeys[i].ToString()).ToUpper() != "PAGE")
                            newQueryString += paramName + "=" + query[i] + "&";
                previousLink.NavigateUrl = Request.Url.AbsolutePath + newQueryString + "Page=" + (currentPage - 1).ToString();
            }
            // create the Next link
            if (currentPage == howManyPages)
                nextLink.Enabled = false;
            else
            {
                NameValueCollection query = Request.QueryString;
                string paramName, newQueryString = "?";
                for (int i = 0; i < query.Count; i++)
                    if (query.AllKeys[i] != null)
                        if ((paramName = query.AllKeys[i].ToString()).ToUpper() != "PAGE")
                            newQueryString += paramName + "=" + query[i] + "&";
                nextLink.NavigateUrl = Request.Url.AbsolutePath + newQueryString + "Page=" + (currentPage + 1).ToString();
            }
        }
    }

    protected void DelBtn_Click(Object sender, CommandEventArgs e) 
    {
        if (e.CommandName == "wishListDel")
        {
            string bookID = Convert.ToString(e.CommandArgument);
            string userID = string.Empty;

            if (Convert.ToString(Request.Cookies["userInfo"]) != "")
            {
                userID = Request.Cookies["userInfo"]["mem_ID"];
            }
            else
            {
                ErrorMsg("You need to login.");
            }

            bool result = CatalogAccess.DeleteWishList(userID, Int32.Parse(bookID));

            Response.Redirect(Request.Url.AbsoluteUri);
        }
    }

}