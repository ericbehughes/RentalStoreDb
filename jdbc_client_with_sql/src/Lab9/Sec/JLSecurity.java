package Lab9.Sec;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.Security;
import java.security.spec.InvalidKeySpecException;
import java.math.BigInteger;
import java.sql.*;

import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class JLSecurity {
	private static SecureRandom random = new SecureRandom();
	
	//Takes a username and password and creates and account for that user
	public void newUser(String username, String password) throws SQLException{

	}
	
	
	//Prompts the user to input a username and password, and creates an account for that user.
	public void newUser() throws SQLException{
		
	}
	
	//Takes a username and password returns true if they belong to a valid user
	public boolean login(String username, String password)throws SQLException{
		return false;
	}
	
	//Prompts the user to input their login info, returns true if they are a valid user, false otherwise
	public boolean login() throws SQLException{
		return false;
	}
		
	
	//Helper Functions below:
	//getConnection() - obtains a connection
	//getSalt() - creates a randomly generated string 
	//hash() - takes a password and a salt as input and then computes their hash
	
	
	//Creates a randomly generated String
	public String getSalt(){
		return new BigInteger(140, random).toString(32);
	}
	
	//Takes a password and a salt a performs a one way hashing on them, returning an array of bytes.
	public byte[] hash(String password, String salt){
		try{
			SecretKeyFactory skf = SecretKeyFactory.getInstance( "PBKDF2WithHmacSHA512" );
	        
			/*When defining the keyspec, in addition to passing in the password and salt, we also pass in
			a number of iterations (1024) and a key size (256). The number of iterations, 1024, is the
			number of times we perform our hashing function on the input. Normally, you could increase security
			further by using a different number of iterations for each user (in the same way you use a different
			salt for each user) and storing that number of iterations. Here, we just use a constant number of
			iterations. The key size is the number of bits we want in the output hash*/ 
			PBEKeySpec spec = new PBEKeySpec( password.toCharArray(), salt.getBytes(), 1024, 256 );

			SecretKey key = skf.generateSecret( spec );
	        byte[] hash = key.getEncoded( );
	        return hash;
        }catch( NoSuchAlgorithmException | InvalidKeySpecException e ) {
            throw new RuntimeException( e );
        }
	}
}