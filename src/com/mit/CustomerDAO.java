package com.mit;
import java.sql.*;
public class CustomerDAO {
	static Connection conn;
	static PreparedStatement pst;
	
	public static int insertCustomer(CustomerBean u) {
		int status = 0;
		try {
			conn = ConnectionProvider.getCon();
			if (u.getUsername().equals("") || u.getRole().equals("") || 
					u.getAge().equals("") || u.getState().equals("")) {
				return status;
			} else {			
				PreparedStatement theStatement = null;
				theStatement = conn.prepareStatement("select * from username2 where username=?");
                theStatement.setString(1, u.getUsername());
                ResultSet theResult = theStatement.executeQuery();

                if(theResult.next())
                    return status;
				
				
				pst = conn.prepareStatement("insert into username2 values(?,?,?,?)");
				pst.setString(1, u.getUsername());
				pst.setString(2, u.getRole());
				pst.setString(3, u.getAge());
				pst.setString(4, u.getState());
				status = pst.executeUpdate();
				conn.close();
			}
		} catch (Exception ex) {
			System.out.println(ex);
		}
		return status;
	}
	
	
	public static String signinCustomer(CustomerBean u) {
		int status = 0;
		try {
			conn = ConnectionProvider.getCon();			
			PreparedStatement theStatement = null;
			theStatement = conn.prepareStatement("select * from username2 where username = ?");
			theStatement.setString(1, u.getUsername());
			ResultSet theResult = theStatement.executeQuery();

			if(theResult.next()) {
				return theResult.getString("role");
			}

			conn.close();

		} catch (Exception ex) {
			System.out.println(ex);
		}
		return null;
		
	}

	public static ArrayList<String> insertProduct(ProductBean u) {
		ArrayList<String> error = new ArrayList<String>();
		
		try {
			conn = ConnectionProvider.getCon();
			
			if (u.getName() == "" || u.getSku() == "" || u.getCategory() == "" || u.getPrice() == "") 
				error.add("Please fill out all fields");
				
			if (u.getSku() != "") {
				PreparedStatement check_sku = conn.prepareStatement("SELECT * FROM products WHERE sku='"
																	+ u.getSku() +"'");
				
				ResultSet rs_sku = check_sku.executeQuery();
				if (rs_sku.next()) 
					error.add("SKU id taken");
			}
			
			if (u.getCategory() != "") {
				PreparedStatement check_sku = conn.prepareStatement("SELECT * FROM categories WHERE name='"
																	+ u.getCategory() +"'");
			
				ResultSet rs_sku = check_sku.executeQuery();
				if (!rs_sku.next()) 
					error.add("Category does not exist");
			}
			
			int price = 0;
			try {
				price = Integer.parseInt(u.getPrice());
				if (price < 0)
					error.add("Invalid price");
			} catch(Exception e) {
				error.add("Invalid price");
			}
			
			if (error.isEmpty()) {
				PreparedStatement pstmt = conn.prepareStatement("INSERT INTO products (name,sku,category,price)" +
							  									"VALUES (?,?,?,?)");
				pstmt.setString(1, u.getName());
				pstmt.setString(2, u.getSku());
				pstmt.setString(3, u.getCategory());
				pstmt.setInt(4, price);
				
				pstmt.executeUpdate();
			}
			
			conn.close();
		} catch (Exception e) {
			error.add("Insertion Failure");
		}
		
		return error;
	}
	
	
}
