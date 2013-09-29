package com.adnan;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import static com.adnan.OfyService.ofy;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.images.ImagesService;
import com.google.appengine.api.images.ImagesServiceFactory;



public class UploadImageServlet extends HttpServlet {

	private BlobstoreService blobstoreService = BlobstoreServiceFactory
			.getBlobstoreService();

	private ImagesService imagesService = ImagesServiceFactory.getImagesService();


	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws IOException{
		Map<String, BlobKey> blobs = blobstoreService.getUploadedBlobs(req);
		BlobKey blobKey = blobs.get("myFile");
		String bkUrl = imagesService.getServingUrl(blobKey);

		Long streamId = new Long(req.getParameter("streamId"));
		String streamName = req.getParameter("streamName");
		ConnexusImage s = new ConnexusImage(streamId, streamName, bkUrl);
		ofy().save().entity(s).now();
		List<Stream> sth = OfyService.ofy().load().type(Stream.class).list();
		for (int i = 0; i < sth.size(); i++){
			if (sth.get(i).name.equals(streamName)){
				sth.get(i).pictureNum++;
				sth.get(i).newImageDate = new Date();
			}
		}
		ofy().save().entities(sth).now();
		resp.sendRedirect("/ViewStreamImage.jsp?streamId=" + streamId + "&"
				+ "streamName=" + streamName + "&offset=0");

	}

}