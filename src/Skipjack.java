import javax.swing.*;

/**
 * Created by adelnizamutdinov on 04/11/14
 */
public class Skipjack {
  private JTextField textField1;
  private JTextArea  textArea1;
  private JTextArea  textArea2;
  private JTextArea  textArea3;
  private JPanel     root;
  private JButton    зашифроватьButton;
  private JButton    расшифроватьButton;

  public static void main(String[] args) throws ClassNotFoundException, UnsupportedLookAndFeelException, InstantiationException, IllegalAccessException {
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());

    JFrame frame = new JFrame("Skipjack");
    frame.setContentPane(new Skipjack().root);
    frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    frame.pack();
    frame.setVisible(true);
  }
}
