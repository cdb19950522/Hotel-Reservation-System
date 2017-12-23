<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Review</title>
</head>
<body>
	<%	
	
		String id = request.getParameter("cid");
		
		try{
			//Create a connection string
			String url = "jdbc:mysql://cs336database.c89rkcpk4ocp.us-east-2.rds.amazonaws.com:3306/hoteldatabase";
			
			//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
			Class.forName("com.mysql.jdbc.Driver");
			
			//Create a connection to your DB
			Connection con = DriverManager.getConnection(url, "root", "hotelcs336");
			
			//Create a SQL statement
			Statement stmt = con.createStatement();
			
			//get the rate
			String r = request.getParameter("rate");
			//get the comment
			String comment = request.getParameter("comment");
			//get invoice number
			String inno = request.getParameter("InvoiceNo");
			//get category
			String category = request.getParameter("category");
			//generate reviewid
			
			String step1 = id+inno;
			//String step2 = step1+Integer.toString((category.charAt(0)+0));
			
			int reviewid = (int)(Math.random() * 100000);
			int cid = Integer.parseInt(id);
			int invoice = Integer.parseInt(inno);
			int rate = Integer.parseInt(r);
			String str = "SELECT ResDate FROM Reservation Where InvoiceNo = "+inno;
			
			ResultSet result = stmt.executeQuery(str);
			
			result.next();
			//get the date of the invoice
			java.sql.Date date = result.getDate("ResDate");
			String insertSQL = "";
			
			String tmp = category;
			String room_tmp = "room";
			
			if(category.equals("room")){
				insertSQL = "INSERT INTO RoomReview(ReviewID,Rating,TextComment,reviewDate)" + "VALUES(?,?,?,?)";

			}else if(category.equals("breakfast")){
				insertSQL = "INSERT INTO BreakfastReview(ReviewID,Rating,TextComment,reviewDate)" + "VALUES(?,?,?,?)";
			}else{
				insertSQL = "INSERT INTO ServiceReview(ReviewID,Rating,TextComment,reviewDate)" + "VALUES(?,?,?,?)";
			}
			PreparedStatement st = con.prepareStatement(insertSQL);
			st.setInt(1, reviewid);
			st.setInt(2,rate);
			st.setString(3,comment);
			st.setDate(4, date);
			st.executeUpdate();
			if(category.equals("room")){
				str = "update makes set isRoomReviewed = 1 where CID="+id+" and InvoiceNo="+inno;
			}else if(category.equals("breakfast")){
				str = "update makes set isBreakfastReviewed = 1 where CID="+id+" and InvoiceNo="+inno;
			}else{
				str = "update makes set isServiceReviewed = 1 where CID="+id+" and InvoiceNo="+inno;
			}
			stmt.execute(str);
			con.close();
		}catch(Exception e){
			
		}finally{
			//System.out.print(request.getParameter("cid"));
			request.setAttribute("cid", Integer.parseInt(request.getParameter("cid")));
			
			
			request.getRequestDispatcher("hello.jsp").forward(request, response);
		}
	%>
</body>
</html>