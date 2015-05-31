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

Projected Final Letter Grade: #{e[14]}
Course Grade by Point Average: #{e[13]} (Class Average: 0.84)

------

Quiz 1: #{e[3]} (Class Average: 73.30) [25%]
Quiz 2: #{e[4]} (Class Average: 78.94) [30%]

Quiz Average: #{e[10]} 
(Class Average: 76.12)

-------

Problem Set 1 [150]: #{e[5]} 
Problem Set 2 [200]: #{e[6]}
Problem Set 3 [100]: #{e[7]}

Problem Set Total: #{e[11]} [25%]
(Class Average: 327.44)

--------

Project Grade [100]: #{e[9]} [20%]
Class Average: 93.66
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

#      Net::SMTP.start('localhost') do |smtp|
#	smtp.send_message(fullText,
#			  @message['from'],
#			  [@message['to'], @message['cc'].split(/,/)].flatten)
#      end

    }


  end
end

list = MailList.new("students.txt", "letter.txt")
  list.send("Nick Feamster <feamster@cc.gatech.edu>",
	    "Your Grades in CS 3251",
	    "Nick Feamster <feamster@cc.gatech.edu>, Abhinav Narain <abhinavnarain10@gmail.com>")
