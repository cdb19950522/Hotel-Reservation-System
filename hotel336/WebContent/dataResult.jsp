<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import = "java.util.Date,java.text.SimpleDateFormat"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Data Analysis</title>
</head>
<body>
	<%
		String fromdate = request.getParameter("fromDate");
		String todate = request.getParameter("toDate");
		SimpleDateFormat formater = new SimpleDateFormat("MM/dd/yyyy");
		Date sd = formater.parse(fromdate);
		Date ed = formater.parse(todate);
		if(sd.compareTo(ed)>=0){
			response.sendRedirect("ddateError.jsp");
		}
		try{
			//Create a connection string
			String url = "jdbc:mysql://cs336database.c89rkcpk4ocp.us-east-2.rds.amazonaws.com:3306/hoteldatabase";
			
			//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
			Class.forName("com.mysql.jdbc.Driver");
			
			//Create a connection to your DB
			Connection con = DriverManager.getConnection(url, "root", "hotelcs336");
			
			//Create a SQL statement
			Statement stmt = con.createStatement();
			
			String str = "SELECT rr.Rating as rate, r.Type as type From RoomReview rr, Has_Room r, evaluates e Where rr.ReviewID = e.ReviewID and e.HotelID = r.HotelID and e.Room_no = r.Room_no and rr.reviewDate<="+todate+" and rr.reviewDate not in"+
			"(SELECT reviewDate From RoomReview Where reviewDate>="+fromdate+") ORDER BY rate desc";
			ResultSet result = stmt.executeQuery(str);
			ArrayList<String> al = new ArrayList<String>();
			int rate = 0;
			while(result.next()){
				int r = result.getInt("rate");
				if(r<rate){
					break;
				}
				rate = r;
				String t = result.getString("type");
				if(al.indexOf(t)<0){
					al.add(t);
				}
			}
			out.print("<p>The top rated Room type(s) is/are</p>");
			for(int i = 0; i<al.size();i++){
				out.print("<p>"+al.get(i)+"</p>");
			}
			str = "SELECT rr.Rating as rate, r.bType as type From BreakfastReview rr, Offers_Breakfast r, assesses e Where rr.ReviewID = e.ReviewID and e.HotelID = r.HotelID and e.bType = r.bType and rr.reviewDate<="+todate+" and rr.reviewDate not in"+
					"(SELECT reviewDate From RoomReview Where reviewDate>="+fromdate+") ORDER BY rate desc";
			result = stmt.executeQuery(str);
			ArrayList<String> bl = new ArrayList<String>();
			int rate1 = 0;
			while(result.next()){
				int r = result.getInt("rate");
				if(r<rate1){
					break;
				}
				rate1 = r;
				String t = result.getString("type");
				if(bl.indexOf(t)<0){
					bl.add(t);
				}
			}
			out.print("<p>The top rated Breakfast type/types is/are</p>");
			for(int i = 0; i<bl.size();i++){
				out.print("<p>"+bl.get(i)+"</p>");
			}
			str = "SELECT rr.Rating as rate, r.sType as type From ServiceReview rr, Provides_Service r, rates e Where rr.ReviewID = e.ReviewID and e.HotelID = r.HotelID and e.sType = r.sType and rr.reviewDate<="+todate+" and rr.reviewDate not in"+
					"(SELECT reviewDate From RoomReview Where reviewDate>="+fromdate+") ORDER BY rate desc";
			result = stmt.executeQuery(str);
			ArrayList<String> cl = new ArrayList<String>();
			int rate2 = 0;
			while(result.next()){
				int r = result.getInt("rate");
				if(r<rate2){
					break;
				}
				rate2 = r;
				String t = result.getString("type");
				if(cl.indexOf(t)<0){
					cl.add(t);
				}
			}
			out.print("<p>The top rated Service type/types is/are</p>");
			for(int i = 0; i<cl.size();i++){
				out.print("<p>"+cl.get(i)+"</p>");
			}
			str = "select c.name as name, sum(r.TotalAmt) as spent"+
					" From Customer c, Reservation r, makes m"+
					" Where c.CID = m.CID"+
					" and m.InvoiceNo = r.InvoiceNo"+
					" and r.ResDate<="+todate+
					" and r.ResDate not in("+
						" select r.ResDate"+
					    " from Reservation r"+
					    " where r.ResDate>=" + fromdate+
					")"+
					" group by c.CID"+
					" order by spent desc";
			result = stmt.executeQuery(str);
			ArrayList<String> dl = new ArrayList<String>();
			int indc = 0;
			while(result.next()&&indc<5){
				String s = result.getString("name");
				dl.add(s);
				indc++;
			}
			out.print("<p>Our top 5 customers are</p>");
			for(int i = 0; i<dl.size();i++){
				out.print("<p>"+dl.get(i)+"</p>");
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	%>
	<br>
	<br>
	<input type="button" value="Back" onClick = "javascript:location.href='Data.jsp'">
</body>
</html>