#!/usr/bin/env python

import os
import re
import smtplib
from email.mime.text import MIMEText


class Spammer(object):

    def __init__(self, maillist, messagefile, sender, subject, cc, bcc):

        self.ml = {}

        self.sender = sender
        self.subject = subject
        self.cc = cc
        self.bcc = bcc

        # use Google as the SMTP server
        self.smtp = smtplib.SMTP("smtp.gmail.com", 587)
        self.smtp.ehlo()
        self.smtp.starttls()
        self.smtp.ehlo()
        self.smtp.login('feamster@gmail.com', 'xsebfafxfekqdpmf')
        

        # read the main mailing list                
        with open(maillist) as f:
            for line in f.readlines():
               last,first,email  = line.strip('\r\n').split(',')
               if not re.match(r'.*@', email): continue
               self.ml[email] = (first,last)

        # main message
        with open(messagefile) as f:
            self.message = f.read().rstrip('\n')
              

    def sendMessage(self, email):

        ######
        # prepare the message body

        msgtxt = re.sub(r'@FIRST@', self.ml[email][0], self.message)

        
        ########################################
        # prepare the message for sending
        msg = MIMEText(msgtxt)
        msg['From'] = self.sender
        msg['To'] = '{0} {1} <{2}>'.format(self.ml[email][0],
                                            self.ml[email][1],
                                            email)
        msg['Subject'] = self.subject
        if len(self.cc) > 0: msg['cc'] = self.cc 
        if len(self.bcc) > 0: msg['bcc'] = self.bcc

            
        ######
        # show what will be sent
        print msg

        ######
        # actually send the message - UNCOMMENT to Send
        # self.smtp.sendmail('feamster@uchicago.edu',email, msg.as_string())


    def sendMessages(self):
        for email in self.ml.keys():
            self.sendMessage(email)
            
    def printEmails(self):
        for email in self.ml.keys():
            print '{0} {1} <{2}>'.format(self.ml[email][0],
                                            self.ml[email][1],
                                            email)



                        
##################################################    
#     def __init__(self, maillist, messagefile, sender, subject, cc, bcc):

sp = Spammer(
        # maillist
        'uchicago-phd-2020.txt', 
        #'test.txt',
        # messagefile
        'interview-message.txt',
        # sender
        'Nick Feamster <feamster@uchicago.edu>',
        # subject
        'Talk about Ph.D. at University of Chicago?',
        '',
        'Nick Feamster <feamster@gmail.com>',
        )

sp.sendMessages()
