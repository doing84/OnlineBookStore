using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Store_OrderDetails : System.Web.UI.Page
{
    public string userID;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Convert.ToString(Request.Cookies["userInfo"]) != "")
        {
            userID = Request.Cookies["userInfo"]["mem_ID"];
        }
        else
        {
            Response.Write("<script language=javascript>alert('You need login first');history.back;</script>");
        }
    }
}