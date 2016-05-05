using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;

public partial class Users_Login : System.Web.UI.Page
{
    private Account mbBiz = new Account();

    HttpContext context = HttpContext.Current;

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void login_Click(object sender, EventArgs e)
    {
        string mem_ID = userID.Text;
        string password = pwd.Text;

        if (mem_ID == "" || mem_ID == null)
        {
            Response.Redirect("/Default.aspx");

        }

        if (password == "" || password == null)
        {
            Response.Redirect("/Default.aspx");

        }

        //로그인 시작.

        string result = mbBiz.AuthenticateSQL(mem_ID, password);

        if (result != "-1")
        {
            //쿠키 만들기..
            FormsAuthentication.SetAuthCookie(mem_ID, false);

            //로그인 정보 확인후 닉네임 쿠키 설정
            HttpCookie myCookie = new HttpCookie("userInfo");
            myCookie["mem_ID"] = mem_ID;
            myCookie["mem_Name"] = result;

            myCookie.Expires = DateTime.Now.AddMinutes(30.0);
            Response.Cookies.Add(myCookie);

            Response.Redirect("/Default.aspx", false);

        }
        else
        {
            //setLogin();

            //Response.Write("<script>alert('로그인 실패. ID와 비밀번호를 확인해주세요.');history.back();</script>");
            Response.Redirect("/Account/Login.aspx", false);
        }


    }

    protected void join_Click(object sender, EventArgs e)
    {
        //Session["drtUrl"] = Request.Url.ToString();
        Response.Redirect("/Account/Register.aspx");
    }

    protected void SlideShow1_Click(object sender, SlideShowImageEventArgs e)
    {

    }
}