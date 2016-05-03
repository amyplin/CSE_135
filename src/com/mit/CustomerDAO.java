package com.mit;
import java.sql.*;
import java.util.*;
public class CustomerDAO {
	static Connection conn;
	static PreparedStatement pst;
	
	public static int insertCustomer(CustomerBean u) {
		int status = 0;
		try {
			conn = ConnectionProvider.getCon();
			conn.setAutoCommit(false);
			
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
				conn.commit();
				conn.setAutoCommit(true);
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


	public static boolean insertCategory(CategoryBean u, String name, String description) throws SQLException {
		try {
			PreparedStatement pstmt = null;
			PreparedStatement theStatement = null;
			conn = ConnectionProvider.getCon();
			conn.setAutoCommit(false);

			if (name.equals("") || description.equals("")) {
				return false;
			} else {

				theStatement = conn.prepareStatement("select * from categories where name = ?");
				theStatement.setString(1, name);
				ResultSet theResult = theStatement.executeQuery();

				if (theResult.next()) {
					return false;
				} else {

					pstmt = conn
							.prepareStatement("INSERT INTO categories (name, description,count) VALUES (?, ?,?)");

					pstmt.setString(1, u.getName());
					pstmt.setString(2, u.getDescription());
					pstmt.setInt(3, 0);

					int rowCount = pstmt.executeUpdate();
					conn.commit();
					return true;
				}
			}
		} catch (Exception e) {
			System.out.println(e);
		} finally {
			conn.setAutoCommit(true);
			conn.close();
		}
		return true;

	}

	
	public static boolean deleteCategory(CategoryBean u, String name) throws SQLException {
		Savepoint savepoint = null;
		try {
			conn = ConnectionProvider.getCon();
			PreparedStatement pstmt = null;
			PreparedStatement theStatement = null;
			conn.setAutoCommit(false);
			
			theStatement = conn.prepareStatement("select * from categories where name = ?");
			theStatement.setString(1, name);
			ResultSet theResult = theStatement.executeQuery();

			if (!theResult.next() || theResult.getInt("count") > 0) {
				return false;
			}

			pstmt = conn.prepareStatement("DELETE FROM categories WHERE name = ?");
			pstmt.setString(1, u.getName());
			int rowCount = pstmt.executeUpdate();
			savepoint = conn.setSavepoint();

			conn.commit();
			return true;
		} catch (Exception e) {
			System.out.println(e);
		} finally {
			conn.setAutoCommit(true);
			conn.close();
		}
		return true;
	}

	public static boolean updateCategory(CategoryBean u, String origName, String name, String description) throws SQLException {
		try {
			PreparedStatement pstmt = null;
			PreparedStatement theStatement = null;
			conn = ConnectionProvider.getCon();
			conn.setAutoCommit(false);

			if (name.equals("") || description.equals("")) {
				return false;
			} else {
				if (!origName.equals(name)) {  //if updating name
					//check if category still exists
					theStatement = conn.prepareStatement("select * from categories where name = ?");
					theStatement.setString(1, origName);
					ResultSet theResult = theStatement.executeQuery();

					//check if name is still unique
					theStatement = conn.prepareStatement("select * from categories where name = ?");
					theStatement.setString(1, name);
					ResultSet rs2 = theStatement.executeQuery();

					if (!theResult.next() || rs2.next()) { //update but no longer available
						return false;
					}
				} 
				pstmt = conn
						.prepareStatement("UPDATE categories SET name=?, description = ? WHERE name = ?");
				pstmt.setString(1, u.getName());
				pstmt.setString(2, u.getDescription());
				pstmt.setString(3, origName);
				int rowCount = pstmt.executeUpdate();

				conn.commit();
				return true;
			}
		} catch (Exception e) {
			System.out.println(e);
		} finally {
			conn.setAutoCommit(true);
			conn.close();
		}
		return true;
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
				
				check_sku.close();
				rs_sku.close();
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
				
				pstmt = conn.prepareStatement("UPDATE categories SET count=count+1 WHERE name=?");
				pstmt.setString(1, u.getCategory());
				pstmt.executeUpdate();
				
				pstmt.close();
			}
			
			conn.close();
		} catch (Exception e) {
			error.add("Insertion Failure");
		}
		
		return error;
	}
	
	public static ArrayList<String> updateProduct(ProductBean u, String sku) {
		ArrayList<String> error = new ArrayList<String>();
		try {
			conn = ConnectionProvider.getCon();
			
			if (u.getName() == "" || u.getSku() == "" || u.getCategory() == "" || u.getPrice() == "") 
				error.add("Please fill out all fields");
				
			if (u.getSku() != "" && !sku.equals(u.getSku())) {
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
				PreparedStatement pstmt = conn.prepareStatement("UPDATE products SET name=?,sku=?,category=?,price=?" +
							  									"WHERE sku=?");
				pstmt.setString(1, u.getName());
				pstmt.setString(2, u.getSku());
				pstmt.setString(3, u.getCategory());
				pstmt.setInt(4, price);
				pstmt.setString(5,sku);
				pstmt.executeUpdate();
			}
			
			conn.close();
		} catch (Exception e) {
			error.add("Update Failure");
		}
		
		return error;
	}
	
	public static ArrayList<String> deleteProduct(String sku, String category) {
		ArrayList<String> error = new ArrayList<String>();
		
		try {
			conn = ConnectionProvider.getCon();
			PreparedStatement pstmt = conn.prepareStatement("DELETE FROM products WHERE sku=?");
			pstmt.setString(1, sku);
			pstmt.executeUpdate();
			
			pstmt = conn.prepareStatement("UPDATE categories SET count=count-1 WHERE name=?");
			pstmt.setString(1, category);
			pstmt.executeUpdate();
			
			pstmt.close();
			conn.close();
		} catch (Exception e) {
			error.add("Failure to delete");
		}
		
		return error;
	}
}
