#!/usr/bin/ruby

require 'net/smtp'

class MailList
  def initialize(list, contents)
    @emails = Array.new
    @students = Array.new

    IO.foreach(list) { |l|
      @students << l if (l !~ /^\#/)
    }

    @message = Hash.new
    @message['body'] = IO.readlines(contents)
    @message['reply-to'] = 'feamster@cc.gatech.edu'
  end
  
  def send(from, subject, cc=nil)
    @message['from'] = from
    @message['subject'] = subject
    @message['cc'] = cc

    @students.each { |t|
      t.chomp!

      e = t.split(/,/)

      email = t.split(/,/)[0] + "@mail.gatech.edu"

      firstname = t.split(/,/)[2]
      firstname.gsub!(/\"/,'')
      firstname.gsub!(/\s+/,'')

      lastname = t.split(/,/)[1]
      lastname.gsub!(/\"/,'')

      name = "#{firstname} #{lastname}"

      gradeline = <<EOS

------

Projected Final Letter Grade: #{e[18]}
Course Grade by Point Average: #{e[17]} (Class Average: 0.XX)

------

Quiz 1 [85]:  #{e[3]} (Class Average: 72/85) 
Quiz 2 [100]: #{e[4]} (Class Average: 71/100) 
Quiz 3 [100]: #{e[5]} (Class Average: 65/100)

Quiz Total: #{e[15]}  
(Class Average: 207.44)

-------

Problem Set 2 [100]: #{e[6]} (Class Average: 99/100)
Problem Set 3 [100]: #{e[7]} (Class Average: 86/100)
Problem Set 4 [100]: #{e[8]} (Class Average: 91/100)
Problem Set 5 [100]: #{e[9]} (Class Average: 95/100)
Problem Set 6 [100]: #{e[10]} (Class Average: 99/100)
Problem Set 7 [100]: #{e[11]} (Class Average: 96/100)
Problem Set 8 [100]: #{e[12]} (Class Average: 98/100)
Problem Set 9 [100]: #{e[13]} (Not Graded Yet)

Problem Set Total: #{e[17]} [XX%]
(Class Average: 644.67)

--------

Project Grade [100]: #{e[14]} [XX%]
Class Average: 90.67
EOS

      @message['to'] =  name + ' <' + email + '>'

      fullText = ["From: #{@message['from']}", 
		  "Reply-To: #{@message['reply-to']}", 
		  "To: #{@message['to']}",
		  "Cc: #{@message['cc']}", 
		  "Subject: #{@message['subject']}\n\n",
		  @message['body'].join("")].join("\n")
      tmp1 = fullText.gsub(/\@NAME\@/, firstname);
      tmp2 =tmp1.gsub!(/\@GRADES\@/, gradeline);
      fullText = tmp2

      print "#{@message['to']}\n"
      print fullText

    }


  end
end

list = MailList.new("students.txt", "letter.txt")
  list.send("Nick Feamster <feamster@cc.gatech.edu>",
	    "Your Grades in CS 6250",
	    "Nick Feamster <feamster@cc.gatech.edu>, Muhammad Shahbaz <shahbaz@cc.gatech.edu>, Sean Donovan <sdonovan@gatech.edu>")
