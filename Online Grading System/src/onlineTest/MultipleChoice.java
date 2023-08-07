package onlineTest;

public class MultipleChoice extends Question {

	protected String[] answer;

	public MultipleChoice(int questionNumber, String text, double points, 
			String[] answer) {

		super(questionNumber, text, points);

		this.answer = answer;
	}

}
