<!--#include file="../inc/conn_reg.asp"-->
<!--#include file="../inc/config.asp"-->
<!--#include file="cfc.asp"-->
<!--#include file="../public/user.asp"-->
<%
set rs=Server.CreateObject("Adodb.Recordset")
rs.open "SELECT * From news  where nclass_id in("&user(22)&") ORDER BY news_id DESC",conn,1,1 
'删除
if request("del")="del" then
dsql="delete * from news where news_id="&request("news_id")
conn.execute dsql
response.write"<script>alert('文章已成功删除！');location.href='news_list.asp?pageno="%><%=request("pageno")%><%response.write"';</Script>"
end if
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<LINK href="../images/site_css.css" rel=stylesheet type=text/css>
<LINK href="../images/style.css" rel=stylesheet type=text/css>
</head>

<BODY background=../images/BG1.gif bgColor=#ffffff leftMargin=0 topMargin=0>
<br>
<br>
<%
Dim TotalPage '总页数
Dim PageNo '当前显示的是第几页
Dim RecordCount '总记录条数
If RS.RecordCount=0 then
response.write "<P><center>对不起，数据库中没有相关信息！</center></P>"
response.end
else
RS.PageSize = config(3)
Totalpage=INT(RS.recordcount / rs.pagesize * -1)*-1 '计算可显示页面的总数
PageNo = Request.QueryString ("PageNo")
'直接输入页数跳转；
If Request.Form("PageNo")<>"" Then PageNo = Request.Form("PageNo")
'如果没有选择第几页，则默认显示第一页；
If PageNo = "" then PageNo = 1 
Rs.AbsolutePage = PageNo
End If

'获取当前文件名，使得每次翻页都在当前页面进行；
Dim fileName,postion
fileName = Request.ServerVariables("script_name")
postion = InstrRev(fileName,"/")+1
'取得当前的文件名称，使翻页的链接指向当前文件；
fileName = Mid(fileName,postion) 
Dim RowCount
RowCount = config(3) '每页显示的记录条数
%>
&nbsp;&nbsp;&nbsp;&nbsp;文章列表如下: 共计 <%=RS.recordcount%> 条记录<br>
<br>
<table width="95%" border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="#000000">
  <tr align="center" valign="middle"> 
    <td width="5%" bgcolor="#008306">编号</td>
    <td width="16%" bgcolor="#008306">所属目录</td>
    <td width="48%" bgcolor="#008306">文章标题</td>
    <td width="10%" bgcolor="#008306">日期</td>
    <td width="9%" bgcolor="#008306">添加人</td>
    <td width="12%" bgcolor="#008306">编辑</td>
  </tr>
  <%
Do while Not Rs.eof and RowCount>0
%>
  <tr align="center" valign="middle" bgcolor="#C9E393"> 
    <td width="5%"> <%=rs("news_id")%></td>
    <td width="16%" bgcolor="#C9E393"> <%
	set rs3=Server.CreateObject("Adodb.Recordset")
sql="SELECT * From nclass where nclass_id="&rs("nclass_id")
rs3.open sql,conn,1,1
		%> <%
	set rs4=Server.CreateObject("Adodb.Recordset")
sql="SELECT * From class where class_id="&rs3("class_id")
rs4.open sql,conn,1,1
		%> <%=rs4("class_name")%><font color=red>/</font><%=rs3("nclass_name")%></td>
    <td width="48%" bgcolor="#C9E393"><div align="left"><a href="../type.asp?news_id=<%=rs("news_id")%>" target="_blank"><%=rs("news_title")%></a></div></td>
    <td width="10%"><%=rs("news_date")%></td>
    <td width="9%"><%=rs("news_add")%></td>
    <td width="12%">[<a href="news_edit.asp?news_id=<%=rs("news_id")%>">编辑</a>] 
      [<a href="news_list.asp?news_id=<%=rs("news_id")%>&del=del&pageno=<%=pageno%>">删除</a>]</td>
  </tr>
  <%
RowCount = RowCount - 1
Rs.MoveNext
Loop
%>
</table>
<br>
<br>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr align="center" valign="middle"> 
      <td><!--#include file="../public/page.asp"-->
	</td>
      </tr>
</table>
<br>
<br>
 <!--#include file="../public/copyright.inc"-->