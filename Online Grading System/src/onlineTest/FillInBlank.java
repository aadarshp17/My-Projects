package onlineTest;

public class FillInBlank extends Question {

	public String[] answer;

	public FillInBlank(int questionNumber, String text, double points, 
			String[] answer) {

		super(questionNumber, text, points);

		this.answer = answer;
	}

}
