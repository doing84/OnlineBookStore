using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SubLayout : System.Web.UI.MasterPage
{
    public decimal amount;
    public string userID;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (Convert.ToString(Request.Cookies["userInfo"]) != "")
            {
                userID = Request.Cookies["userInfo"]["mem_ID"];
                amount = ShoppingCartAccess.GetTotalAmount(userID);
            }
            else
            {
                amount = 0;
            }
        }
    }

}
