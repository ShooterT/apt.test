package com.adnan;

import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyFactory;

// APT: this solves potential "not registered" failures, e.g., if we bringup app and immediately go to ViewAllStreams.jsp
// call to data store read via objectify service will fail even if stream class calls the register() method 
// See this for details: https://code.google.com/p/objectify-appengine/wiki/BestPractices#How_NOT_To_Register_Entities
public class OfyService {
    static {
    	factory().register(Stream.class);
    	factory().register(ConnexusImage.class);
    	factory().register(AppUser.class);
    }
    
    static int freq = 0;
    static int count = 0;
    

    public static Objectify ofy() {
        return com.googlecode.objectify.ObjectifyService.ofy();
    }

    public static ObjectifyFactory factory() {
        return com.googlecode.objectify.ObjectifyService.factory();
    }
    
    public static void sendmail(String address,String msg){
    	Properties props = new Properties();
    	props.put("mail.smtp.host", "smtp.gmail.com");
    	props.put("mail.smtp.socketFactory.port", "465");
    	props.put("mail.smtp.socketFactory.class",
    			"javax.net.ssl.SSLSocketFactory");
    	props.put("mail.smtp.auth", "true");
    	props.put("mail.smtp.port", "465");

    	Session session = Session.getDefaultInstance(props,
    		new javax.mail.Authenticator() {
    			protected PasswordAuthentication getPasswordAuthentication() {
    				return new PasswordAuthentication("tongzhaoapt@gmail.com","1357924685");
    			}
    		});

    	try {

    		Message message = new MimeMessage(session);
    		message.setFrom(new InternetAddress("tongzhaoapt@gmail.com"));
    		System.out.println(address);
    		message.setRecipients(Message.RecipientType.TO,
    				InternetAddress.parse(address));
    		message.setSubject("Testing Subject");
    		message.setText(msg);

    		Transport.send(message);

    		System.out.println("Done");

    	} 
    	
    	catch (MessagingException e) {
    		throw new RuntimeException(e);
    	}

    }
}