using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;

public partial class MainLayout : System.Web.UI.MasterPage
{
    private Account mbBiz = new Account();
    HttpContext context = HttpContext.Current;
    public string userID;
    public decimal amount;
    public bool isAdmin;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            setLogin();

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

    protected void setLogin()
    {

        //exist user info
        //if (context.User.Identity.IsAuthenticated)
        if(Convert.ToString(Request.Cookies["userInfo"]) != "")
        {
            this.MultiView1.ActiveViewIndex = 1;
            userName.Text = Request.Cookies["userInfo"]["mem_Name"];
        }
        //not exist user info
        else
        {
            this.MultiView1.ActiveViewIndex = 0;
        }
    }

    protected void btnLogout_Click(object sender, EventArgs e)
    {

        string redPath = FormsAuthentication.GetRedirectUrl(context.User.Identity.Name, false);

        FormsAuthentication.SignOut();

        //delete cookie
        if (Request.Cookies["userInfo"] != null)
        {
            HttpCookie myCookie = new HttpCookie("userInfo");
            myCookie.Expires = DateTime.Now.AddDays(-1d);
            Response.Cookies.Add(myCookie);
        }

        Response.Redirect("/Default.aspx", false);
    }
}
