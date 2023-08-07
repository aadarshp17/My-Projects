package onlineTest;

import java.io.Serializable;
import java.util.ArrayList;

public class Student implements Serializable {

	protected String name;

	protected ArrayList<QuestionAnswer> questionAnswers;

	public Student(String name) {

		this.name = name;

		this.questionAnswers = new ArrayList<>();

	}

}
