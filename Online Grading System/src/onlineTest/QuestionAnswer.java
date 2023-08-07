package onlineTest;

import java.io.Serializable;

public class QuestionAnswer implements Serializable {

	boolean answer;
	String[] result;
	protected int questionNumber;
	protected int examId;

	public QuestionAnswer(int examId, int questionNumber, boolean answer) {

		this.examId = examId;
		this.questionNumber = questionNumber;
		this.answer = answer;
	}

	public QuestionAnswer(int examId, int questionNumber, String[] result) {

		this.examId = examId;
		this.questionNumber = questionNumber;
		this.result = result;

	}
}
