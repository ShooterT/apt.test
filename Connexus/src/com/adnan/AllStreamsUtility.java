package com.adnan;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Date;

//Define class first to select streams, based on start date and end date.
class StreamSelector{
	long startDate;
	long endDate;
	StreamSelector(Date start, Date end){
		this.startDate = start.getTime();
		this.endDate = end.getTime();
	}
	boolean streamsMatch(Stream s){
		return (s.createDate.getTime() >= startDate && s.createDate.getTime() <= endDate);
	}
}

class ImageSelector{
	long startDate;
	long endDate;
	ImageSelector(Date start, Date end){
		this.startDate = start.getTime();
		this.endDate = end.getTime();
	}
	boolean imagesMatch(ConnexusImage c){
		return (c.createDate.getTime() >= startDate && c.createDate.getTime() <= endDate);
				
	}
}

public class AllStreamsUtility {
	
	// fetch all streams
	public static List<Stream> allStreams(){
		List<Stream> th = OfyService.ofy().load().type(Stream.class).list();
		Collections.sort(th);
		return th;
	}
	
	// fetch all images in a stream
	public static List<ConnexusImage> allImages(){
		List<ConnexusImage> th = OfyService.ofy().load().type(ConnexusImage.class).list();
		Collections.sort(th);
		return th;
	}
	
	// fetch all selected streams
	public static List<Stream> allSelectedStreams(StreamSelector selector){
		List<Stream> th = allStreams();
		// List<Stream> th = OfyService.ofy().load().type(Stream.class).list();
		// Collections.sort(th);
		List<Stream> result = new ArrayList<Stream>();
		for(Stream s: th){
			if(selector.streamsMatch(s))
				result.add(s);
		}
		return result;
	}
	
	// fetch all selected images from a stream
	public static List<ConnexusImage> allSelectedImages(ImageSelector imageSelector) {
		List<ConnexusImage> th = allImages();
		List<ConnexusImage> result = new ArrayList<ConnexusImage>();
		for(ConnexusImage c: th){
			if(imageSelector.imagesMatch(c))
				result.add(c);
		}
		return result;
	}
	
}




