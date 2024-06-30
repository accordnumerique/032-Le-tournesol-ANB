<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="WebSite.Fr.emails.GenericPage" %>
<html>
  <head runat="server"></head>
	<body style="background-image: url('images/bg.jpg'); background-repeat: repeat; background-color: #eaecee; font-family: Tahoma, Arial, Helvetica, Verdana, sans-serif;">
		<div align="center">
			

			<table style="width: 634px; background-color: White; border: solid 1px #bcbdbd" border="0" cellpadding="0" cellspacing="0">
				<tr style="background-color: #eeeeee; height: 5px"><td colspan=3><div style="height:5px"></div></td></tr>
				<tr>
					<td style="background-color: #eeeeee; width: 5px"></td>
					<td><div style="width: 620px; border: solid 1px #bcbdbd;">
						    <table border="0" cellpadding="0" cellspacing="0"  style="background-color: #d0d0d0; width:100%">
							    <tr>
								    <td align="left"><h1 style="color: rgba(9, 15, 30, 0.8); font-weight: bold; font-size: 26px; margin: 10px;"><%= CompanyName %></h1></td>
								    <td align="right" width="200"><a href="<%= WebSite %>" style="display: block; width: 199px; height: 47px; background: url(images/button.png); text-align: center; line-height: 47px; 
								                                  	color: #555555; font-weight: 900; text-decoration: none; font-size: 16px;">Visit website</a></td>
							    </tr>
									<tr style="background-color:White">
										<td colspan=2 align=center>
										 
									<img src="<%= Logo %>" alt="<%= CompanyName %>" style="max-height:250px; padding:5px" />		
										</td>
									</tr>
						    </table>
								<div style="padding:5px; margin:5px">
									<%= EmailContent %>
									
									<div style="height: 1px; margin-top: 19px; border-bottom: 1px solid #e3e5e6;"></div><!--Line-->
								</div>
					    </div>
					</td>
					<td style="background-color: #eeeeee; width: 5px"></td>
				</tr>
				<tr style="background-color: #eeeeee; height: 5px"><td colspan=3><div style="height:5px"></div></td></tr>
			</table>
			
			<p style="font-size: 12px; color: #999999; margin: 15px 0 0 0; line-height: 19px;">
				<br />This email has ben send to <%= Email %><br /> <a href="<%= WebSite %>" style="color: #2670c3; text-decoration: none;">Visit website</a>
				| <a href="/en/Inscription-Journal.aspx" style="color: #2670c3; text-decoration: none;">Subscription settings</a><br/></p>
		</div>
	</body>

</html>