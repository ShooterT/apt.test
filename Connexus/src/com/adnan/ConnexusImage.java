package com.adnan;

import java.util.Date;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.common.base.Joiner;
import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity
public class ConnexusImage implements Comparable<ConnexusImage> {

	@Id
	public Long id;
	public Long streamId;
	public String streamName;
	public String bkUrl;
	public Date createDate;

	@SuppressWarnings("unused")
	public ConnexusImage() {
		this.createDate = new Date();
	}

	public ConnexusImage(Long streamId, String streamName, String bkUrl) {
		this.streamId = streamId;
		this.streamName = streamName;
		this.bkUrl = bkUrl;
		this.createDate = new Date();
	}
	
	@Override
	public String toString() {
		// Joiner is from google Guava (Java utility library), makes the toString method a little cleaner
		Joiner joiner = Joiner.on(":");
		return joiner.join(id.toString(), streamId, streamName, bkUrl==null ? "null" : bkUrl, createDate.toString());
	}

	// Need this for sorting images by date
	@Override
	public int compareTo(ConnexusImage other) {
		if (createDate.after(other.createDate)) {
			return 1;
		} else if (createDate.before(other.createDate)) {
			return -1;
		}
		return 0;
	}
	
}
