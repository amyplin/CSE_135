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
}
