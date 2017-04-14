package Lab9.UI;

import java.awt.BorderLayout;
import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;

import Lab9.Sec.JLSecurity;

import javax.swing.JTextField;
import javax.swing.JButton;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.security.SecureRandom;
import java.sql.*;
import java.util.Arrays;

public class Lab9View extends JFrame {
	private static Connection con;
	private static SecureRandom random = new SecureRandom();
	private static JLSecurity sec = new JLSecurity();
	private static String user, pass;
	private JPanel contentPane;
	private JTextField UserTextField;
	private JTextField PWTextField;
	private JButton LoginButton;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					Lab9View frame = new Lab9View();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the frame.
	 */
	public Lab9View() {
		Initialize();
		try{
			con = getConnection();
		}
		catch (SQLException s){
			System.out.println(s.getMessage());
		}
	}
	
	public static Connection getConnection() throws SQLException {
		Connection conn = null;
		//String sqlUrl = "jdbc:oracle:thin:@198.168.52.73:1521:orad11g";
		String sqlUrl = "jdbc:oracle:thin:@localhost:1521:xe";
		conn = DriverManager.getConnection(sqlUrl,"system", "SQLpass");
		System.out.println("Connected to database");
		return conn;
	}
	
	
	public void Initialize(){
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 450, 133);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setContentPane(contentPane);
		contentPane.setLayout(null);
		
		UserTextField = new JTextField();
		UserTextField.setText("UserID");
		UserTextField.setBounds(23, 11, 403, 19);
		contentPane.add(UserTextField);
		UserTextField.setColumns(10);
		
		PWTextField = new JTextField();
		PWTextField.setText("Password");
		PWTextField.setBounds(23, 42, 403, 19);
		contentPane.add(PWTextField);
		PWTextField.setColumns(10);
		
		LoginButton = new JButton("Login");
		LoginButton.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				LoginEvent();
			}
		});
		LoginButton.setBounds(23, 73, 194, 25);
		contentPane.add(LoginButton);
		
		JButton NewUserButton = new JButton("Create Account");
		NewUserButton.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				NewUserEvent();
			}
		});
		NewUserButton.setBounds(232, 73, 194, 25);
		contentPane.add(NewUserButton);
	}
	
	public void LoginEvent(){
		/*Validate user input */
		user = UserTextField.getText();
		pass = PWTextField.getText();
		if (user.isEmpty() || pass.isEmpty())
			throw new IllegalArgumentException("The username or password cannot be empty");
		
		/*Validate user credentials */
		String salt = "",
			   userID = "";
		byte[] hash = null,
			   tempHash = null;
		boolean result = false;
		String select = "SELECT USERID, HASH, SALT FROM USERS WHERE USERID = \'" + user + "\'";
		
		try{
			Statement statement = con.createStatement();
			ResultSet rs = statement.executeQuery(select);
			rs.next();
			userID = rs.getString("USERID");
			tempHash = rs.getBytes("HASH");
			salt = rs.getString("SALT");
			rs.close();
		}
		catch (SQLException s){
			System.out.println(s.getMessage());
		}
		/* If salt == "" there is no user */
		if (salt.isEmpty())
			result = false;
		/* If the salt exists, hash the password and compare with parameter */
	
		else{
			hash = sec.hash(pass, salt);
			if (Arrays.equals(hash, tempHash))
				result = true;
		}
	}
	
	public void NewUserEvent() {
		
	}
}
