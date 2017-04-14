package Lab9.UI;

import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JTextField;
import java.awt.BorderLayout;

public class Lab9GUI {

	private JFrame frame;
	private JTextField UserTextField;
	private JTextField PWTextField;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					Lab9GUI window = new Lab9GUI();
					window.frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the application.
	 */
	public Lab9GUI() {
		initialize();
	}

	/**
	 * Initialize the contents of the frame.
	 */
	private void initialize() {
		frame = new JFrame();
		frame.setBounds(100, 100, 450, 300);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.getContentPane().setLayout(null);
		
		UserTextField = new JTextField();
		UserTextField.setText("UserID");
		UserTextField.setBounds(22, 12, 403, 19);
		frame.getContentPane().add(UserTextField);
		UserTextField.setColumns(10);
		
		PWTextField = new JTextField();
		PWTextField.setText("Password");
		PWTextField.setColumns(10);
		PWTextField.setBounds(22, 37, 403, 19);
		frame.getContentPane().add(PWTextField);
	}
}
