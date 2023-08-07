package tests;

import static org.junit.Assert.*;
import org.junit.FixMethodOrder;
import org.junit.Test;
import org.junit.runners.MethodSorters;

import tubeVideosManager.*;
import java.util.ArrayList;


@FixMethodOrder(MethodSorters.NAME_ASCENDING)

public class PublicTests {
	@Test
	public void pub01VideoComments() {
		String testName = new Object() {
		}.getClass().getEnclosingMethod().getName();
		StringBuffer results = new StringBuffer();
		
		String title = "How to Draw in Java Tutorial";
		String url = "https://www.youtube.com/embed/ifVf9ejuFWI";
		int durationInMinutes = 17;
		Genre genre = Genre.Educational;
		
		Video video = new Video(title, url, durationInMinutes, genre);
		video.addComments("Nice video");
		video.addComments("Recommended");
		
		results.append(video).append("\n");
		results.append(video.getComments());
		assertTrue(TestingSupport.isResultCorrect(testName, results.toString(), true));
	}
	
	@Test
	public void pub02TubeVideosManagerAddVideoToDatabase() {
		String testName = new Object() {
		}.getClass().getEnclosingMethod().getName();
		StringBuffer results = new StringBuffer();
		
		TubeVideosManager tubeVideosManager = new TubeVideosManager();
		String title = "How to Draw in Java Tutorial";
		String url = "https://www.youtube.com/embed/ifVf9ejuFWI";
		int durationInMinutes = 17;
		Genre genre = Genre.Educational;
		
		/* Adding first video */
		tubeVideosManager.addVideoToDB(title, url, durationInMinutes, genre);		
		title = "Git & GitHub Crash Course for Beginners";
		url = "https://www.youtube.com/embed/SWYqp7iY_Tc";
		durationInMinutes = 33;
		genre = Genre.Educational;
		
		/* Adding second video */
		tubeVideosManager.addVideoToDB(title, url, durationInMinutes, genre);
		
		/* Getting videos */
		ArrayList<Video> videos = tubeVideosManager.getAllVideosInDB();
		results.append(videos);
		
		assertTrue(TestingSupport.isResultCorrect(testName, results.toString(), true));
	}
	
}