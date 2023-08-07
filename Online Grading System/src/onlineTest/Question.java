package onlineTest;

import java.io.Serializable;

public class Question implements Serializable {

	protected int questionNumber;
	protected String text;
	protected double points;

	public Question(int questionNumber, String text, double points) {

		this.questionNumber = questionNumber;
		this.text = text;
		this.points = points;
	}

}
