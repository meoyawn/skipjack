import javax.swing.*;
import java.awt.event.ActionListener;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 * Created by adelnizamutdinov on 04/11/14
 */
public class Skipjack {
  private JPanel     root;
  private JTextField keyField;
  private JTextArea  initialText;
  private JTextArea  encryptedText;
  private JTextArea  decryptedText;
  private JButton    encryptButton;
  private JButton    decryptButton;
  private JLabel     keyError;
  private JLabel     decryptError;
  private JTextArea  hashMsg;
  private JTextField hash;
  private JButton    hashButton;
  private JTextField sigKey;
  private JButton    generateKeyButton;
  private JTextArea  textArea1;
  private JButton    вычислитьButton;
  private JTextField textField2;
  private JTextField textField3;

  Timer timer = new Timer(1, null);

  void withTimer(ActionListener actionListener) {
    timer.stop();
    timer = new Timer(2000, actionListener);
    timer.start();
  }

  public Skipjack() {
    encryptButton.addActionListener(e -> {
      try {
        encryptedText.setText(execute(new String[]{"./Encryptor", keyField.getText(), initialText.getText()}));
      } catch (RuntimeException e1) {
        keyError.setText("Ключ должен быть длины 5!");
        withTimer(x -> keyError.setText(""));
      }
    });
    decryptButton.addActionListener(e -> {
      try {
        decryptedText.setText(execute(new String[]{"./Decryptor", keyField.getText(), encryptedText.getText()}));
      } catch (RuntimeException e1) {
        decryptError.setText("Сообщение было зашифровано другим алгоритмом либо другим ключом");
        withTimer(x -> decryptError.setText(""));
      }
    });
    hashButton.addActionListener(e -> hash.setText(execute(new String[]{"./Hasher", hashMsg.getText()})));
  }

  static String execute(String[] commands) {
    try {
      Runtime r = Runtime.getRuntime();
      Process p = r.exec(commands);
      if (p.waitFor() == 0) {
        return new BufferedReader(new InputStreamReader(p.getInputStream())).readLine();
      } else {
        System.out.println(new BufferedReader(new InputStreamReader(p.getErrorStream())).readLine());
        throw new RuntimeException();
      }
    } catch (IOException | InterruptedException e) {
      e.printStackTrace();
    }
    throw new RuntimeException();
  }

  public static void main(String[] args) throws ClassNotFoundException, UnsupportedLookAndFeelException, InstantiationException, IllegalAccessException {
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());

    JFrame frame = new JFrame("Skipjack");
    frame.setContentPane(new Skipjack().root);
    frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    frame.pack();
    frame.setVisible(true);
  }
}
