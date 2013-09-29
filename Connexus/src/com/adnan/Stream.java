package com.adnan;

import java.util.ArrayList;
import java.util.Date;

import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.google.common.base.Joiner;
import com.googlecode.objectify.ObjectifyFactory;

@Entity
public class Stream implements Comparable<Stream> {

	static {
		 ObjectifyService.register(Stream.class);
	}
	// id is set by the datastore for us
	@Id
	public Long id;
	public String name;
	public String tags;
	public Date createDate;
	public Date newImageDate;
	public int visitTime;
	public int pictureNum;
	public String coverImageUrl;
	public ArrayList<Date> visitQueue;	
  
	// TODO: figure out why this is needed
	@SuppressWarnings("unused")
	private Stream() {
		visitTime = 0;
		pictureNum = 0;
		coverImageUrl = "http://www.full-stop.net/wp-content/uploads/2012/05/Great-wall-of-china.jpeg";
		createDate = new Date();
		newImageDate = new Date();
		visitQueue = new ArrayList<Date>();
	}
	
	@Override
	public String toString() {
		Joiner joiner = Joiner.on(":");
		return joiner.join(id.toString(), name, tags, createDate.toString());
 	}
    
	// If the input of coverImageUrl is empty, use default
	public Stream(String name, String tags) {
		this.name = name;
		this.tags = tags;
		this.coverImageUrl = "http://www.full-stop.net/wp-content/uploads/2012/05/Great-wall-of-china.jpeg";
		this.createDate = new Date();
		this.newImageDate = new Date();
		this.visitQueue = new ArrayList<Date>();
		visitTime = 0;
		pictureNum = 0;
	}
	
	// To see if the input of coverImageUrl is not empty
	public Stream(String name, String tags, String coverImageUrl) {
		this.name = name;
		this.tags = tags;
		this.coverImageUrl = coverImageUrl;
		this.createDate = new Date();
		this.newImageDate = new Date();
		this.visitQueue = new ArrayList<Date>();
		visitTime = 0;
		pictureNum = 0;
	}
	
	// update queue with date created in the arraylist.
	// note that getTime() method use milli-second.
	public int updateQueue(Date date){
		ArrayList<Date> tmpArrayList = new ArrayList<Date>();
		for (Date e:visitQueue ){
			if ((date.getTime()-e.getTime())/(1000*60*60) >= 1){
				tmpArrayList.add(e);
			}
		}
		for (Date e:tmpArrayList){
			visitQueue.remove(e);
		}
		return visitQueue.size();
	}

	// method to update when new image put on
	public void updateNewImageDate(){
		newImageDate = new Date();
	}
	
	@Override
	public int compareTo(Stream other) {
		if (createDate.after(other.createDate)) {
			return 1;
		} else if (createDate.before(other.createDate)) {
			return -1;
		}
		return 0;
	}
}
