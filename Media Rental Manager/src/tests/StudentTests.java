package tests;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Random;

import org.junit.Test;

import tubeVideosManager.Genre;
import tubeVideosManager.Playlist;
import tubeVideosManager.TubeVideosManager;
import tubeVideosManager.Video;

/**
 * 
 * You need student tests if you are asking for help during office hours about
 * bugs in your code. Feel free to use tools available in TestingSupport.java
 * 
 * @author UMCP CS Department
 *
 */
public class StudentTests {

	@Test
	public void testing_All_Methods_In_TubeVideosManager() {

		TubeVideosManager tubeVideosManager = new TubeVideosManager();

		tubeVideosManager.addVideoToDB("Video1", "link1", 10, Genre.Comedy);

		tubeVideosManager.addVideoToDB("Video2", "link2", 20, Genre.Educational);

		System.out.println(tubeVideosManager.searchForVideos("SP", null, -1, Genre.Comedy));

		System.out.println(tubeVideosManager.addComments("Video1", "Success!"));

		System.out.println(tubeVideosManager.addVideoToDB("Video3", "link3", 3, Genre.Music));

		System.out.println(tubeVideosManager.addPlaylist("My Tunes"));

		System.out.println(tubeVideosManager.addVideoToPlaylist("Video1", "My Tunes"));

		System.out.println(tubeVideosManager.equals(tubeVideosManager));

		System.out.println(Arrays.toString(tubeVideosManager.getPlaylistsNames()));

		ArrayList<Video> videos = tubeVideosManager.getAllVideosInDB();

		System.out.println(videos);

	}

	@Test
	public void testing_All_Methods_In_Playlist() {

		Playlist playlist = new Playlist("Kiwi");

		Playlist playlist2 = new Playlist("Pineapple");

		System.out.println(playlist.addToPlaylist("Video1"));
		System.out.println(playlist.addToPlaylist("Video2"));
		System.out.println(playlist.addToPlaylist("Video3"));
		System.out.println(playlist.addToPlaylist("Video1"));

		System.out.println(playlist.getName());

		Random random = new Random(5);

		playlist.shuffleVideoTitles(null);

		System.out.println(playlist.getPlaylistVideosTitles());

		playlist.shuffleVideoTitles(random);

		System.out.println(playlist.getPlaylistVideosTitles());

		playlist.removeFromPlaylistAll("Video1");

		System.out.println(playlist.getPlaylistVideosTitles());

	}

	@Test
	public void testing_All_Methods_In_Video() {

		Video video = new Video("Apple", "link1", 1, Genre.Comedy);

		Video video2 = new Video("Banana", "link2", 2, Genre.Educational);

		System.out.println(video.addComments("Great!"));

		System.out.println(video.getComments() + " " + video.getDurationInMinutes() + " " + video.getTitle() + " "
				+ video.getUrl() + " " + video.getGenre());

		System.out.println(video.compareTo(video2));

		System.out.println(video.equals(video2));

	}

}
