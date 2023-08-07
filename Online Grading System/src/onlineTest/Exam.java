package onlineTest;

import java.io.Serializable;
import java.util.ArrayList;

public class Exam extends SystemManager implements Serializable {

	protected int examId;
	protected String title;
	protected ArrayList<Question> questions;

	public Exam(int examId, String title) {

		this.examId = examId;
		this.title = title;
		this.questions = new ArrayList<>();

	}

}
