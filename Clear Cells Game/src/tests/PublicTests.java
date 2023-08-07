package tests;

import static org.junit.Assert.*;

import java.util.Random;

import model.BoardCell;
import model.ProcessCellGame;
import model.Game;

import org.junit.FixMethodOrder;
import org.junit.Test;
import org.junit.runners.MethodSorters;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)

public class PublicTests {

	@Test
	public void pub01EmptyBoard() {
		String testName = new Object() {
		}.getClass().getEnclosingMethod().getName();

		int maxRows = 4, maxCols = 5, strategy = 1;
		Game ccGame = new ProcessCellGame(maxRows, maxCols, new Random(1L), 
				strategy);

		String answer = getBoardStr(ccGame);

		assertTrue(TestingSupport.isResultCorrect(testName, answer, true));
	}

	@Test
	public void pub02AnimationSteps() {
		String testName = new Object() {
		}.getClass().getEnclosingMethod().getName();
		int maxRows = 4, maxCols = 5, strategy = 1;
		Game ccGame = new ProcessCellGame(maxRows, maxCols, new Random(1L), 
				strategy);
		ccGame.nextAnimationStep();
		ccGame.nextAnimationStep();

		String answer = getBoardStr(ccGame);
		assertTrue(TestingSupport.isResultCorrect(testName, answer, true));
	}

	@Test
	public void pub03HorizontalCells() {
		String testName = new Object() {
		}.getClass().getEnclosingMethod().getName();
		int maxRows = 8, maxCols = 8, strategy = 1;
		Game ccGame = new ProcessCellGame(maxRows, maxCols, new Random(1L), 
				strategy);

		ccGame.setBoardWithColor(BoardCell.BLUE);
		ccGame.setRowWithColor(maxRows - 1, BoardCell.EMPTY);
		ccGame.setRowWithColor(1, BoardCell.YELLOW);
		ccGame.setBoardCell(1, maxCols - 1, BoardCell.RED);

		String answer = "Before processCell\n\n";
		answer += getBoardStr(ccGame);
		ccGame.processCell(1, 4);
		answer += "\nAfter processCell\n";
		answer += getBoardStr(ccGame);

		assertTrue(TestingSupport.isResultCorrect(testName, answer, true));
	}

	@Test
	public void pub04CollapseCells() {
		String testName = new Object() {
		}.getClass().getEnclosingMethod().getName();
		int maxRows = 8, maxCols = 8, strategy = 1;
		Game ccGame = new ProcessCellGame(maxRows, maxCols, new Random(1L), 
				strategy);

		ccGame.setBoardWithColor(BoardCell.BLUE);
		ccGame.setRowWithColor(maxRows - 1, BoardCell.EMPTY);
		ccGame.setRowWithColor(1, BoardCell.YELLOW);
		ccGame.setBoardCell(1, maxCols - 1, BoardCell.RED);
		ccGame.setRowWithColor(3, BoardCell.GREEN);
		ccGame.setRowWithColor(6, BoardCell.RED);

		String answer = "Before processCell\n\n";
		answer += getBoardStr(ccGame);
		ccGame.processCell(1, 4);
		answer += "\nAfter processCell\n";
		answer += getBoardStr(ccGame);
		ccGame.processCell(1, maxCols - 1);
		answer += "\nAfter processCell\n";
		answer += getBoardStr(ccGame);

		assertTrue(TestingSupport.isResultCorrect(testName, answer, true));
	}

	/* Support methods */
	private static String getBoardStr(Game game) {
		int maxRows = game.getMaxRows(), maxCols = game.getMaxCols();

		String answer = "Board(Rows: " + maxRows + ", Columns: " + maxCols + 
				")\n";
		for (int row = 0; row < maxRows; row++) {
			for (int col = 0; col < maxCols; col++) {
				answer += game.getBoardCell(row, col).getName();
			}
			answer += "\n";
		}

		return answer;
	}
}
