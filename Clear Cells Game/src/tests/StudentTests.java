package tests;

import static org.junit.Assert.*;

import java.util.Random;

import org.junit.FixMethodOrder;
import org.junit.Test;
import org.junit.runners.MethodSorters;

import model.BoardCell;
import model.Game;
import model.ProcessCellGame;

/* The following directive executes tests in sorted order */
@FixMethodOrder(MethodSorters.NAME_ASCENDING)

public class StudentTests {

	@Test
	public void test1() {
		int maxRows = 8, maxCols = 8, strategy = 1;
		Game ccGame = new ProcessCellGame(maxRows, maxCols, new Random(1L), 
				strategy);

		ccGame.setBoardWithColor(BoardCell.BLUE);
		ccGame.setRowWithColor(maxRows - 1, BoardCell.EMPTY);
		ccGame.setRowWithColor(1, BoardCell.YELLOW);
		ccGame.setBoardCell(1, maxCols - 1, BoardCell.RED);

		String answer = "Before processCell\n\n";
		answer += getBoardStr(ccGame);

		System.out.println(answer);
	}

	@Test
	public void test2() {

		int maxRows = 5, maxCols = 4, strategy = 1;
		Game ccGame = new ProcessCellGame(maxRows, maxCols, new Random(1L), 
				strategy);

		ccGame.setBoardWithColor(BoardCell.BLUE);
		ccGame.setRowWithColor(1, BoardCell.EMPTY);
		ccGame.setRowWithColor(2, BoardCell.EMPTY);
		ccGame.setBoardCell(1, 3, BoardCell.RED);
		ccGame.setColWithColor(1, BoardCell.GREEN);
		ccGame.setRowWithColor(maxRows - 1, BoardCell.EMPTY);

		System.out.println("Before processCell\n\n");
		System.out.println(getBoardStr(ccGame));

		// System.out.println(answer);

		ccGame.processCell(1, 1);
		System.out.println("\nAfter processCell\n");
		System.out.println(getBoardStr(ccGame) + "   " + ccGame.getScore());

		// System.out.println(ccGame.getBoardCell(1, 3));

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
