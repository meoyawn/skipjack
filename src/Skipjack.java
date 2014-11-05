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
  private JButton    calculateSigButton;
  private JTextField rField;
  private JTextField sField;
  private JButton    verifyButton;
  private JLabel     verifyField;

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
    generateKeyButton.addActionListener(e -> sigKey.setText(execute(new String[]{"./XGenerator"})));
    calculateSigButton.addActionListener(e -> {
      String[] strings = execute2(new String[]{"./Signaturer", sigKey.getText(), textArea1.getText()});
      rField.setText(strings[0]);
      sField.setText(strings[1]);
    });
    verifyButton.addActionListener(e -> verifyField.setText(execute(new String[]{"./Verifier", sigKey.getText(), textArea1.getText(), rField.getText(), sField.getText()})));
  }

  static String[] execute2(String[] commands) {
    try {
      Runtime r = Runtime.getRuntime();
      Process p = r.exec(commands);
      if (p.waitFor() == 0) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(p.getInputStream()));
        return new String[]{reader.readLine(), reader.readLine()};
      } else {
        System.out.println(new BufferedReader(new InputStreamReader(p.getErrorStream())).readLine());
        throw new RuntimeException();
      }
    } catch (IOException | InterruptedException e) {
      e.printStackTrace();
    }
    throw new RuntimeException();
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
