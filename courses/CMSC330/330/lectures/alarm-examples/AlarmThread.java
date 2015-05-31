import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.Scanner;

public class AlarmThread extends Thread {

  private String msg= null;
  private int timeout= 0;

  public AlarmThread(String msg, int timeout) {
    this.msg= msg;
    this.timeout= timeout;
  }
    
  public void run() {      
    try {
      Thread.sleep(timeout * 1000);  // wait (in seconds)
    } catch (InterruptedException e) {
    }
    System.out.println("(" + timeout + ")" + msg);
  }
  
  private static void doAlarm() throws IOException {
    BufferedReader b= new BufferedReader(new InputStreamReader(System.in));
    String line, m;
    int time;
    Scanner scanner;
    Thread t;

    System.out.println("Enter alarms of the form 'time msg', e.g., '3 hello'");
    System.out.print("Alarm> ");  // prompt

    line= b.readLine();
    while (line != null) {

      // read user input
      scanner= new Scanner(line);
      time= scanner.nextInt();
      m= scanner.nextLine();
	
      if (m != null) {
        t= new AlarmThread(m, time);
        t.start();
      }

      System.out.print("Alarm> ");  // prompt
      line= b.readLine();
    }
  }

  public static void main(String args[]) throws IOException {
    doAlarm();
  }

}
