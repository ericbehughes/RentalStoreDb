package Lab9.UI;

import java.awt.BorderLayout;
import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import java.awt.Component;
import javax.swing.Box;
import java.awt.Dimension;
import java.awt.Button;
import javax.swing.JTextField;

public class Lab9CustomerScreen extends JFrame {

	private JPanel contentPane;
	private JTextField CategoryTextField;
	private JTextField ActorTextField;
	private JTextField TitleTextField;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					Lab9CustomerScreen frame = new Lab9CustomerScreen();
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
	public Lab9CustomerScreen() {
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 647, 405);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setContentPane(contentPane);
		contentPane.setLayout(null);
		
		CategoryTextField = new JTextField();
		CategoryTextField.setText("Category");
		CategoryTextField.setBounds(12, 36, 300, 19);
		contentPane.add(CategoryTextField);
		CategoryTextField.setColumns(10);
		
		ActorTextField = new JTextField();
		ActorTextField.setText("Actor/Actress");
		ActorTextField.setColumns(10);
		ActorTextField.setBounds(12, 67, 300, 19);
		contentPane.add(ActorTextField);
		
		TitleTextField = new JTextField();
		TitleTextField.setText("Title");
		TitleTextField.setColumns(10);
		TitleTextField.setBounds(12, 98, 300, 19);
		contentPane.add(TitleTextField);
		
		Component verticalStrut = Box.createVerticalStrut(20);
		verticalStrut.setBounds(324, 23, 10, 109);
		contentPane.add(verticalStrut);
		
		Component horizontalStrut = Box.createHorizontalStrut(20);
		horizontalStrut.setBounds(12, 128, 623, 12);
		contentPane.add(horizontalStrut);
	}
}
