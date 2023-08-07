package onlineTest;

import java.io.Serializable;

public class TrueOrFalse extends Question {

	protected boolean answer;

	public TrueOrFalse(int questionNumber, String text, double points, 
			boolean answer) {

		super(questionNumber, text, points);

		this.answer = answer;
	}

}
