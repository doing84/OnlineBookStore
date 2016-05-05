using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;

using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.Adapters;

using System.Web.Security;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;


/// <summary>
/// Descrizione di riepilogo per RootPage
/// </summary>
public class ScriptPage: System.Web.UI.Page
{
    public ScriptPage()
	{
		//
		// TODO: aggiungere qui la logica del costruttore
		//
	}

    public void RegistScript(string funcName)
    {

        //클라이언트 측 페이지에서 실행되는 '이름'과 '타입'을 정의합니다.
        string csname = "OnsubmitScript";
        Type cstype = this.GetType();

        //클라이언트 측 스크립트를 관리(관리,등록,추가=Page.ClientScript)하는 메서드를 정의합니다.
        ClientScriptManager cs = Page.ClientScript;

        //앞서 정의된 이름과 타입을 매서드로 사용하는 onsubmit등록 함수를 실행합니다.

        //if(!)문은 첫번째 실행되는 onSubmit을 진행 . 두번째오는 onSubmit을 막는 역할을 합니다.
        if (!cs.IsOnSubmitStatementRegistered(cstype, csname))
        {
            //String cstext = "return ValidCheck();";
            String cstext = funcName;
            cs.RegisterOnSubmitStatement(cstype, csname, cstext);
        }
    }

    /* when create alert error message, can use to child page */
    public void ErrorMsg(string msg)
    {
        Response.Write("<script type='text/javascript'>" +
            "alert('" + msg + "');" + //alert msg
            "history.back();" + //go to the previous page
            "</script>");
        Response.End();
    }

    public void ErrorMsg(string msg, string url)
    {
        if (url == "close")
        {
            Response.Write("<script language='javascript'>" +
                "alert('" + msg + "');" +
                "window.close();" +
                "</script>");
            Response.End();
        }
        else if (url == "reload")
        {
            Response.Write("<script language='javascript'>" +
                "alert('" + msg + "');" +
                "parent.window.opener.document.location.reload();" +
                "window.close();" +
                "</script>");
            Response.End();
        }
        else
        {
            Response.Write("<script language='javascript'>" +
                "alert('" + msg + "');" + //alert error msg
                "document.location.href='" + url + "';" + //go to url
                "</script>");
            Response.End();
        }
    }

    public void AlertMsg(string msg)
    {
        Response.Write("<script type='text/javascript'>" +
            "alert('" + msg + "');" + //alert msg
            "</script>");
        Response.End();
    }

}