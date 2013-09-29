package com.adnan;

import java.util.HashSet;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity
public class AppUser {
	@Id 
	public Long id;
	public String userName;
	public String userEmail;
	public HashSet<String> streamsOwned;
	public HashSet<String> streamsSubed;

	// constructor function on users without arguments passed in
	// solving two main parts: Own & Subscribe
	public AppUser(){
		streamsOwned = new HashSet<String>();
		streamsSubed = new HashSet<String>();
	}

	// constructor function on users with arguments passed in
	public AppUser(String userName,String userEmail){
		this.streamsOwned = new HashSet<String>();
		this.streamsSubed = new HashSet<String>();
		this.userName = userName;
		this.userEmail = userEmail;
	}
}
