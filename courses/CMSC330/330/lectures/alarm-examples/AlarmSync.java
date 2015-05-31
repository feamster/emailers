import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.Scanner;

public class AlarmSync {

  private static String msg= null;
  private static int timeout= 0;

  private static void doAlarm() throws IOException {
    BufferedReader b= new BufferedReader(new InputStreamReader(System.in));
    String line;
    Scanner scanner;

    System.out.println("Enter alarms of the form 'time msg', e.g., '3 hello'");
    System.out.print("Alarm> ");  // prompt

    line= b.readLine();
    while (line != null) {

      // read user input
      scanner= new Scanner(line);
      timeout= scanner.nextInt();
      msg= scanner.nextLine();
	
      try {
        Thread.sleep(timeout * 1000);  // wait (in seconds)
      } catch (InterruptedException e) {
      }

      System.out.println("(" + timeout + ")" + msg);

      System.out.print("Alarm> ");  // prompt
      line= b.readLine();
    }
  }

  public static void main(String args[]) throws IOException {
    doAlarm();
  }

}
