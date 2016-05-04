package com.mit;
import java.sql.*;
import java.util.*;
public class CustomerDAO {
	static Connection conn;
	static PreparedStatement pst;
	
	public static int insertCustomer(CustomerBean u) throws SQLException {
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
			
			}
		} catch (Exception ex) {
			System.out.println(ex);
		} finally {
			conn.setAutoCommit(true);
			conn.close();
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
	
	public static ArrayList<String> insertProduct(ProductBean u) throws SQLException {
		ArrayList<String> error = new ArrayList<String>();
		
		try {
			conn = ConnectionProvider.getCon();
			conn.setAutoCommit(false);
			
			if (u.getName() == "" || u.getSku() == "" || u.getCategory() == "" || u.getPrice() == "") 
				error.add("Please fill out all fields");
				
			if (u.getSku() != "") {
				PreparedStatement check_sku = conn.prepareStatement("SELECT * FROM products WHERE sku='"
																	+ u.getSku() +"'");
				
				ResultSet rs_sku = check_sku.executeQuery();
				if (rs_sku.next()) 
					error.add("SKU id taken");
				
				check_sku.close();
				rs_sku.close();
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
			
			double price = 0.0;
			try {
				price = Double.parseDouble(u.getPrice());
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
				pstmt.setDouble(4, price);
				pstmt.executeUpdate();
				
				pstmt = conn.prepareStatement("UPDATE categories SET count=count+1 WHERE name=?");
				pstmt.setString(1, u.getCategory());
				pstmt.executeUpdate();
				
				pstmt.close();
			}
			
			conn.commit();
		} catch (Exception e) {
			error.add("Insertion Failure");
		} finally {
			conn.setAutoCommit(true);
			conn.close();
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
	
	public static String addToCart(String username, int quantity, String sku) {
		try {
			conn = ConnectionProvider.getCon();
			
			//start transaction
			conn.setAutoCommit(false);
			PreparedStatement stmt = conn.prepareStatement("SELECT quantity FROM shoppingcart WHERE username = ?" +
					"AND sku = ?" );
			stmt.setString(1, username);
			stmt.setString(2, sku);
			ResultSet rset = stmt.executeQuery();
			
			if(rset.next())
			{
				int current_quantity = rset.getInt(1); //the current quantity
				quantity += current_quantity;
				
				PreparedStatement updatestmt = conn.prepareStatement("UPDATE shoppingcart SET quantity = ? WHERE username = ? AND sku = ?");
				updatestmt.setInt(1, quantity);
				updatestmt.setString(2, username);
				updatestmt.setString(3, sku);
				
				updatestmt.executeUpdate();
				updatestmt.close();
				
				
			} else {
			
				PreparedStatement pstmt = conn.prepareStatement("INSERT INTO shoppingcart VALUES (?,?,?)");
				pstmt.setString(1, username);
				pstmt.setInt(2, quantity);
				pstmt.setString(3, sku);
				
				pstmt.executeUpdate();
				pstmt.close();
			}
			
			stmt.close();
			conn.commit();
			conn.close();
		} catch (SQLException e) {
			System.out.println(e);
			if(conn != null){
				try{
					conn.rollback();
				} catch(SQLException e2) {
					System.out.println(e2);
				}
			}
			return "Failed to add to shopping cart. Please try again";
		} finally {
			try{
				conn.setAutoCommit(true);
			} catch (SQLException e) {
				System.out.println(e);
				
			}
		}
		return "";
	}
	
	public static String checkout(String username, String creditcard) {
		try{
			conn = ConnectionProvider.getCon();
			// start transaction
			conn.setAutoCommit(false);
		
			
			// add to orders relation
			PreparedStatement pstmt = conn.prepareStatement(
			"INSERT INTO orders (order_id, username, creditcard, productname, productcategory, productprice, productquantity, dateordered)" +
			"SELECT (SELECT coalesce (MAX(order_id) + 1, 0) FROM orders), username, ?, name, category, price, quantity, transaction_timestamp()" +
			"FROM shoppingcart join products on shoppingcart.sku = products.sku where username = ?" );
			
			pstmt.setString(1, creditcard);
			pstmt.setString(2, username);
			pstmt.executeUpdate();
			
			
			// remove from shopping cart
			PreparedStatement rmvstmt = conn.prepareStatement("DELETE FROM shoppingcart WHERE username = ?");
			rmvstmt.setString(1, username);
			rmvstmt.executeUpdate();
			
			conn.commit();
			conn.close();
		} catch (SQLException ex) {
			System.out.println(ex);
			if(conn != null){
				try{
					conn.rollback();
				} catch(SQLException e2) {
					System.out.println(e2);
				}
			}
			return "Failed to checkout. Please try again";
		} finally {
			try{
				conn.setAutoCommit(true);
			} catch (SQLException e) {
				System.out.println(e);
				
			}
		}
		return "";
	}
}
