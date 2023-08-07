package onlineTest;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.TreeMap;
import java.util.TreeSet;

public class SystemManager implements Manager, Serializable {

	protected ArrayList<Exam> exams = new ArrayList<>();

	protected ArrayList<Student> students = new ArrayList<>();

	protected String[] letterGrade;

	protected double[] numberGrade;

	@Override
	public boolean addExam(int examId, String title) {

		if (this.findExamIndex(examId) != -1) {
			return false;
		}

		exams.add(new Exam(examId, title));

		return true;
	}

	private int findExamIndex(int examId) {

		int index = -1;

		for (int i = 0; i < exams.size(); i++) {
			if (exams.get(i).examId == examId) {
				index = i;
			}
		}

		return index;

	}

	private int findStudentIndex(String name) {

		int index = -1;

		for (int i = 0; i < students.size(); i++) {
			if (students.get(i).name.equals(name)) {
				index = i;
			}
		}

		return index;

	}

	@Override
	public void addTrueFalseQuestion(int examId, int questionNumber, 
			String text, double points, boolean answer) {

		TrueOrFalse question = new TrueOrFalse(questionNumber, text, points, 
				answer);

		this.exams.get(this.findExamIndex(examId)).questions.add(question);

	}

	@Override
	public void addMultipleChoiceQuestion(int examId, int questionNumber, 
			String text, double points, String[] answer) {

		MultipleChoice question = new MultipleChoice(questionNumber, text, 
				points, answer);

		this.exams.get(this.findExamIndex(examId)).questions.add(question);

	}

	@Override
	public void addFillInTheBlanksQuestion(int examId, int questionNumber, 
			String text, double points,
			String[] answer) {

		Arrays.sort(answer);

		FillInBlank question = new FillInBlank(questionNumber, text, points, 
				answer);

		this.exams.get(this.findExamIndex(examId)).questions.add(question);

	}

	@Override
	public String getKey(int examId) {

		Exam exam = exams.get(findExamIndex(examId));

		String result = "";

		for (int i = 0; i < exam.questions.size(); i++) {

			result += "Question Text: " + exam.questions.get(i).text;

			result += "\n" + "Points: " + exam.questions.get(i).points;

			if (exam.questions.get(i) instanceof TrueOrFalse) {

				result += "\n" + "Correct Answer: ";

				if (((TrueOrFalse) exam.questions.get(i)).answer == true) {
					result += "True" + "\n";
				} else {
					result += "False" + "\n";
				}

			} else if (exam.questions.get(i) instanceof MultipleChoice) {

				result += "\n" + "Correct Answer: " + Arrays.toString(
						((MultipleChoice) exam.questions.get(i)).answer)
						+ "\n";
			} else {
				result += "\n" + "Correct Answer: " + Arrays.toString(
						((FillInBlank) exam.questions.get(i)).answer)
						+ "\n";

			}
		}
		return result;
	}

	@Override
	public boolean addStudent(String name) {

		if (this.findStudentIndex(name) != -1) {
			return false;
		}

		Student student = new Student(name);

		students.add(student);

		return true;
	}

	@Override
	public void answerTrueFalseQuestion(String studentName, int examId, 
			int questionNumber, boolean answer) {

		AnswerTorF questionAnswer = new AnswerTorF(studentName, examId, 
				questionNumber, answer);

		Student student = students.get(this.findStudentIndex(studentName));

		student.questionAnswers.add(questionAnswer);

	}

	@Override
	public void answerMultipleChoiceQuestion(String studentName, int examId, 
			int questionNumber, String[] answer) {

		AnswerMultipleC questionAnswer = new AnswerMultipleC(studentName, 
				examId, questionNumber, answer);

		Student student = students.get(this.findStudentIndex(studentName));

		student.questionAnswers.add(questionAnswer);

	}

	@Override
	public void answerFillInTheBlanksQuestion(String studentName, int examId, 
			int questionNumber, String[] answer) {

		Arrays.sort(answer);

		AnswerFillIn questionAnswer = new AnswerFillIn(studentName, examId, 
				questionNumber, answer);

		Student student = students.get(this.findStudentIndex(studentName));

		student.questionAnswers.add(questionAnswer);

	}

	@Override
	public double getExamScore(String studentName, int examId) {

		double studentScore = 0.0;
		double pointsPerAns = 0.0;

		Exam exam = exams.get(findExamIndex(examId));

		Student student = students.get(findStudentIndex(studentName));

		for (int i = 0; i < exam.questions.size(); i++) {

			for (int j = 0; j < student.questionAnswers.size(); j++) {

				if (student.questionAnswers.get(j).examId == examId
						&& student.questionAnswers.get(j).questionNumber == 
						exam.questions.get(i).questionNumber) {

					if (student.questionAnswers.get(j) instanceof AnswerTorF) {

						if (((TrueOrFalse) exam.questions.get(i)).answer == 
								student.questionAnswers.get(j).answer) {

							studentScore += exam.questions.get(i).points;

						}

					} else if (student.questionAnswers.get(j) instanceof 
							AnswerMultipleC) {

						if (Arrays.equals(((MultipleChoice) exam.questions.
								get(i)).answer,
								student.questionAnswers.get(j).result)) {

							studentScore += exam.questions.get(i).points;

						}

					} else if (student.questionAnswers.get(j) instanceof 
							AnswerFillIn) {

						String[] correctAns = ((FillInBlank) exam.questions.
								get(i)).answer;
						String[] studentAns = student.questionAnswers.get(j)
								.result;

						pointsPerAns = exam.questions.get(i).points / 
								correctAns.length;

						for (int m = 0; m < studentAns.length; m++) {

							for (int n = 0; n < correctAns.length; n++) {

								if (studentAns[m].equals(correctAns[n])) {

									studentScore += pointsPerAns;

								}
							}

						}

					}
				}

			}

		}

		return studentScore;
	}

	@Override
	public String getGradingReport(String studentName, int examId) {

		double studentScore = 0.0;
		double examPoints = 0.0;
		double questionPoints = 0.0;
		double pointsPerAns = 0.0;
		String report = "";

		Exam exam = exams.get(findExamIndex(examId));
		Student student = students.get(findStudentIndex(studentName));

		for (int i = 0; i < exam.questions.size(); i++) {

			examPoints += exam.questions.get(i).points;

			questionPoints = 0.0;

			for (int j = 0; j < student.questionAnswers.size(); j++) {

				if (student.questionAnswers.get(j).examId == examId
						&& student.questionAnswers.get(j).questionNumber == 
						exam.questions.get(i).questionNumber) {

					if (student.questionAnswers.get(j) instanceof AnswerTorF) {

						if (((TrueOrFalse) exam.questions.get(i)).answer == 
								student.questionAnswers.get(j).answer) {

							studentScore += exam.questions.get(i).points;

							questionPoints += exam.questions.get(i).points;

						}

					} else if (student.questionAnswers.get(j) instanceof 
							AnswerMultipleC) {

						if (Arrays.equals(((MultipleChoice) exam.questions.
								get(i)).answer,
								student.questionAnswers.get(j).result)) {

							studentScore += exam.questions.get(i).points;

							questionPoints += exam.questions.get(i).points;

						}

					} else if (student.questionAnswers.get(j) instanceof 
							AnswerFillIn) {

						String[] correctAns = ((FillInBlank) exam.questions.
								get(i)).answer;
						String[] studentAns = student.questionAnswers.get(j).
								result;

						pointsPerAns = exam.questions.get(i).points / 
								correctAns.length;

						for (int m = 0; m < studentAns.length; m++) {

							for (int n = 0; n < correctAns.length; n++) {

								if (studentAns[m].equals(correctAns[n])) {

									studentScore += pointsPerAns;

									questionPoints += pointsPerAns;

								}
							}

						}

					}
				}

			}

			report += "Question #" + (i + 1) + " " + questionPoints + 
					" points out of " + exam.questions.get(i).points
					+ "\n";

		}

		report += "Final Score: " + studentScore + " out of " + examPoints;

		return report;
	}

	@Override
	public void setLetterGradesCutoffs(String[] letterGrades, double[] cutoffs){

		letterGrade = letterGrades;
		numberGrade = cutoffs;

	}

	@Override
	public double getCourseNumericGrade(String studentName) {

		double courseGrade = 0.0;
		double totalExamScore = 0.0;
		double examPoints = 0.0;

		TreeMap<Integer, String> totalExams = new TreeMap<>();

		Student student = students.get(findStudentIndex(studentName));

		// got total number of exams
		for (int i = 0; i < student.questionAnswers.size(); i++) {

			totalExams.put(student.questionAnswers.get(i).examId, "blah");

		}

		ArrayList<Integer> p = new ArrayList<>(totalExams.keySet());

		for (int j = 0; j < p.size(); j++) {

			Exam exam = exams.get(findExamIndex(p.get(j)));

			examPoints = 0.0;

			for (int k = 0; k < exam.questions.size(); k++) {

				examPoints += exam.questions.get(k).points;

			}

			totalExamScore += this.getExamScore(studentName, p.get(j)) / 
					examPoints;

		}

		courseGrade = (totalExamScore / p.size()) * 100;

		return courseGrade;
	}

	@Override
	public String getCourseLetterGrade(String studentName) {

		String grade = "";
		int indexOfGrade = 0;
		double studentGrade = this.getCourseNumericGrade(studentName);

		for (int i = numberGrade.length - 1; i >= 0; i--) {

			if (studentGrade >= numberGrade[i]) {

				indexOfGrade = i;

			}

		}

		grade = letterGrade[indexOfGrade];

		return grade;
	}

	@Override
	public String getCourseGrades() {

		String result = "";

		students.sort((s1, s2) -> s1.name.compareTo(s2.name));

		for (int i = 0; i < students.size(); i++) {

			result += students.get(i).name + " " + this.getCourseNumericGrade
					(students.get(i).name) + " "
					+ this.getCourseLetterGrade(students.get(i).name);

		}

		return result;

	}

	@Override
	public double getMaxScore(int examId) {

		double highScore = 0.0;

		for (int i = 0; i < this.students.size(); i++) {

			if (this.getExamScore(students.get(i).name, examId) > highScore) {

				highScore = this.getExamScore(students.get(i).name, examId);

			}

		}
		return highScore;
	}

	@Override
	public double getMinScore(int examId) {

		double lowScore = 100.00;

		for (int i = 0; i < this.students.size(); i++) {

			if (this.getExamScore(students.get(i).name, examId) < lowScore) {

				lowScore = this.getExamScore(students.get(i).name, examId);

			}

		}
		return lowScore;

	}

	@Override
	public double getAverageScore(int examId) {

		double totalScore = 0.0;
		double totalStudents = 0.0;

		for (int i = 0; i < this.students.size(); i++) {

			totalStudents += 1;
			totalScore += this.getExamScore(students.get(i).name, examId);
		}

		return totalScore / totalStudents;

	}

	@Override
	public void saveManager(Manager manager, String fileName) {
		try {
			File file = new File(fileName);
			ObjectOutputStream output = new ObjectOutputStream
					(new FileOutputStream(file));

			output.writeObject(manager);
			output.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@Override
	public Manager restoreManager(String fileName) {

		try {
			File file = new File(fileName);
			ObjectInputStream input = new ObjectInputStream
					(new FileInputStream(file));
			Manager manager = (Manager) input.readObject();
			input.close();
			return manager;
		} catch (IOException | ClassNotFoundException e) {
			e.printStackTrace();
			return null;
		}

	}

}
