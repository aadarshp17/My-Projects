package model;

import java.util.Random;

/**
 * Group Members: Aadarsh Patel- apatel66, Joseph Wu - joewu55, Henry Tolson -
 * htolson, Jarred - jdeazev1 Strategy 2: If player clicks on a single empty
 * cell in the middle of a given colored row, then the entire row will turn
 * empty and double the players score.
 */

/**
 * This class extends GameModel and implements the logic of strategy #1. A
 * description of this strategy can be found in the javadoc for the processCell
 * method.
 * 
 * We define an empty cell as BoardCell.EMPTY. An empty row is defined as one
 * where every cell corresponds to BoardCell.EMPTY.
 * 
 * @author Department of Computer Science, UMCP
 */

public class ProcessCellGame extends Game {

	private int strategy;
	private Random random;
	private int score = 0;

	/**
	 * Defines a board with empty cells. It relies on the super class 
	 * constructor to
	 * define the board. The random parameter is used for the generation 
	 * of random
	 * cells. The strategy parameter defines which processing cell strategy 
	 * to use
	 * (for this project the default will be 1).
	 * 
	 * 
	 * @param maxRows
	 * @param maxCols
	 * @param random
	 * @param strategy
	 */
	public ProcessCellGame(int maxRows, int maxCols, Random random, 
			int strategy) {

		super(maxRows, maxCols);

		this.strategy = strategy;

		if (strategy != 1 && strategy != 2) {
			this.strategy = 1;
		}

		this.random = random;

	}

	/**
	 * The game is over when the last board row (row with index 
	 * board.length -1) is
	 * different from empty row.
	 */
	public boolean isGameOver() {

		for (int col = 0; col < this.getMaxCols(); col++) {

			if (this.board[this.getMaxRows() - 1][col] != BoardCell.EMPTY) {
				return true;
			}

		}

		return false;

	}

	public int getScore() {

		return this.score;

	}

	/**
	 * This method will attempt to insert a row of random BoardCell 
	 * objects if the
	 * last board row (row with index board.length -1) corresponds to the 
	 * empty row;
	 * otherwise no operation will take place.
	 */
	public void nextAnimationStep() {

		if (isGameOver() == false) {

			int emptyCells = 0;

			for (int col = 0; col < this.getMaxCols(); col++) {

				if (this.board[this.board.length - 1][col] == BoardCell.EMPTY){
					emptyCells++;
				}

			}

			if (emptyCells == this.getMaxCols()) {

				// Created shifted array
				BoardCell[][] shiftedArray = new BoardCell[this.getMaxRows() 
				                                       + 1][this.getMaxCols()];

				// transferring cells from board array to shifted array
				for (int row = 0; row < shiftedArray.length; row++) {

					for (int col = 0; col < shiftedArray[row].length; col++) {

						if (row == 0) {

							shiftedArray[row][col] = BoardCell.
									getNonEmptyRandomBoardCell(random);

						} else {

							shiftedArray[row][col] = this.board[row - 1][col];
						}
					}

				}

				board = shiftedArray;

				shiftedArray = null;

			}

			emptyCells = 0;

		}

	}

	public void collapseRows(BoardCell[][] board) {

		if (isGameOver() == false) {

			int emptyCells = 0;

			int row = 0;

			for (; row < this.getMaxRows(); row++) {

				for (int col = 0; col < this.getMaxCols(); col++) {

					if (this.board[row][col] == BoardCell.EMPTY) {
						emptyCells++;
					}

				}

				if (emptyCells == this.getMaxCols()) {

					int emptyRow = row;

					// Created shifted array
					BoardCell[][] shiftedArray = new BoardCell
							[this.getMaxRows()][this.getMaxCols()];

					// transferring cells from board array to shifted array
					for (int rows = 0; rows < shiftedArray.length - 1; rows++){

						for (int cols = 0; cols < shiftedArray[rows].length; 
								cols++) {

							shiftedArray[rows][cols] = this.board[(rows >=
									emptyRow ? rows + 1 : rows)][cols];

						}

					}

					for (int columns = 0; columns < this.getMaxCols(); 
							columns++) {

						shiftedArray[this.getMaxRows() - 1][columns] = 
								BoardCell.EMPTY;

					}

					this.board = shiftedArray;

					shiftedArray = null;

					emptyCells = 0;

				}

				emptyCells = 0;

			}

		}

	}

	/**
	 * The default processing associated with this method is that for strategy #1.
	 * If you add a new strategy, make sure you add a conditional so the processing
	 * described below is associated with strategy #1. <br>
	 * <br>
	 * Strategy #1 Description.<br>
	 * <br>
	 * This method will turn to BoardCell.EMPTY the cell selected and any adjacent
	 * surrounding cells in the vertical, horizontal, and diagonal directions that
	 * have the same color. The clearing of adjacent cells will continue as long as
	 * cells have a color that corresponds to the selected cell. Notice that the
	 * clearing process does not clear every single cell that surrounds a cell
	 * selected (only those found in the vertical, horizontal or diagonal
	 * directions). <br>
	 * IMPORTANT: Clearing a cell adds one point to the game's score.<br>
	 * <br>
	 * 
	 * If after processing cells, any rows in the board are empty,those rows will
	 * collapse, moving non-empty rows upward. For example, if we have the following
	 * board (an * represents an empty cell):<br />
	 * <br />
	 * RRR<br />
	 * GGG<br />
	 * YYY<br />
	 * * * *<br/>
	 * <br />
	 * then processing each cell of the second row will generate the following
	 * board<br />
	 * <br />
	 * RRR<br />
	 * YYY<br />
	 * * * *<br/>
	 * * * *<br/>
	 * <br />
	 * IMPORTANT: If the game has ended no action will take place.
	 * 
	 * 
	 */
	public void processCell(int rowIndex, int colIndex) {

		if (isGameOver() == false) {

			// Strategy 1
			if (this.strategy == 1) {

				int x = colIndex;

				int y = rowIndex;

				BoardCell color = this.getBoardCell(rowIndex, colIndex);

				if (color != BoardCell.EMPTY) {

					this.board[rowIndex][colIndex] = BoardCell.EMPTY;
					this.score += 1;

					// Down
					while (indicesCheck(board, ++rowIndex, colIndex)) {

						if (this.getBoardCell(rowIndex, colIndex) == color) {
							this.board[rowIndex][colIndex] = BoardCell.EMPTY;
							this.score += 1;
						} else {
							break;
						}
					}

					colIndex = x;

					rowIndex = y;

					// Up
					while (indicesCheck(board, --rowIndex, colIndex)) {

						if (this.getBoardCell(rowIndex, colIndex) == color) {
							this.board[rowIndex][colIndex] = BoardCell.EMPTY;
							this.score += 1;
						} else {
							break;
						}
					}

					colIndex = x;

					rowIndex = y;

					// Left
					while (indicesCheck(board, rowIndex, --colIndex)) {

						if (this.getBoardCell(rowIndex, colIndex) == color) {
							this.board[rowIndex][colIndex] = BoardCell.EMPTY;
							this.score += 1;
						} else {
							break;
						}
					}

					colIndex = x;

					rowIndex = y;

					// Right
					while (indicesCheck(board, rowIndex, ++colIndex)) {

						if (this.getBoardCell(rowIndex, colIndex) == color) {
							this.board[rowIndex][colIndex] = BoardCell.EMPTY;
							this.score += 1;
						} else {
							break;
						}
					}

					colIndex = x;

					rowIndex = y;

					// Up and Left
					while (indicesCheck(board, --rowIndex, --colIndex)) {

						if (this.getBoardCell(rowIndex, colIndex) == color) {
							this.board[rowIndex][colIndex] = BoardCell.EMPTY;
							this.score += 1;
						} else {
							break;
						}
					}

					colIndex = x;

					rowIndex = y;

					// Down and Left
					while (indicesCheck(board, ++rowIndex, --colIndex)) {

						if (this.getBoardCell(rowIndex, colIndex) == color) {
							this.board[rowIndex][colIndex] = BoardCell.EMPTY;
							this.score += 1;
						} else {
							break;
						}
					}

					colIndex = x;

					rowIndex = y;

					// Up and Right
					while (indicesCheck(board, --rowIndex, ++colIndex)) {

						if (this.getBoardCell(rowIndex, colIndex) == color) {
							this.board[rowIndex][colIndex] = BoardCell.EMPTY;
							this.score += 1;
						} else {
							break;
						}
					}

					colIndex = x;

					rowIndex = y;

					// Down and Right
					while (indicesCheck(board, ++rowIndex, ++colIndex)) {

						if (this.getBoardCell(rowIndex, colIndex) == color) {
							this.board[rowIndex][colIndex] = BoardCell.EMPTY;
							this.score += 1;
						} else {
							break;
						}
					}

					this.collapseRows(board);

					colIndex = x;

					rowIndex = y;
				}

			}

			// Strategy 2
			if (this.strategy == 2) {

				int x = colIndex;

				int y = rowIndex;

				BoardCell color = this.getBoardCell(rowIndex, colIndex);

				if (this.getBoardCell(rowIndex, colIndex) != BoardCell.EMPTY) {

					this.board[rowIndex][colIndex] = BoardCell.EMPTY;
					this.score += 1;

					// Down
					while (indicesCheck(board, ++rowIndex, colIndex)) {

						if (this.getBoardCell(rowIndex, colIndex) == color) {
							this.board[rowIndex][colIndex] = BoardCell.EMPTY;
							this.score += 1;

						} else {
							break;
						}
					}

					colIndex = x;

					rowIndex = y;

					// Up
					while (indicesCheck(board, --rowIndex, colIndex)) {

						if (this.getBoardCell(rowIndex, colIndex) == color) {
							this.board[rowIndex][colIndex] = BoardCell.EMPTY;
							this.score += 1;
						} else {
							break;
						}
					}

					colIndex = x;

					rowIndex = y;

					// Left
					while (indicesCheck(board, rowIndex, --colIndex)) {

						if (this.getBoardCell(rowIndex, colIndex) == color) {
							this.board[rowIndex][colIndex] = BoardCell.EMPTY;
							this.score += 1;
						} else {
							break;
						}
					}

					colIndex = x;

					rowIndex = y;

					// Right
					while (indicesCheck(board, rowIndex, ++colIndex)) {

						if (this.getBoardCell(rowIndex, colIndex) == color) {
							this.board[rowIndex][colIndex] = BoardCell.EMPTY;
							this.score += 1;
						} else {
							break;
						}
					}

					colIndex = x;

					rowIndex = y;

					// Up and Left
					while (indicesCheck(board, --rowIndex, --colIndex)) {

						if (this.getBoardCell(rowIndex, colIndex) == color) {
							this.board[rowIndex][colIndex] = BoardCell.EMPTY;
							this.score += 1;
						} else {
							break;
						}
					}

					colIndex = x;

					rowIndex = y;

					// Down and Left
					while (indicesCheck(board, ++rowIndex, --colIndex)) {

						if (this.getBoardCell(rowIndex, colIndex) == color) {
							this.board[rowIndex][colIndex] = BoardCell.EMPTY;
							this.score += 1;
						} else {
							break;
						}
					}

					colIndex = x;

					rowIndex = y;

					// Up and Right
					while (indicesCheck(board, --rowIndex, ++colIndex)) {

						if (this.getBoardCell(rowIndex, colIndex) == color) {
							this.board[rowIndex][colIndex] = BoardCell.EMPTY;
							this.score += 1;
						} else {
							break;
						}
					}

					colIndex = x;

					rowIndex = y;

					// Down and Right
					while (indicesCheck(board, ++rowIndex, ++colIndex)) {

						if (this.getBoardCell(rowIndex, colIndex) == color) {
							this.board[rowIndex][colIndex] = BoardCell.EMPTY;
							this.score += 1;
						} else {
							break;
						}
					}

					this.collapseRows(board);

					colIndex = x;

					rowIndex = y;

				} else {

					int nonEmptyCells = 0;

					for (int col = 0; col < this.getMaxCols(); col++) {

						if (this.board[rowIndex][col] != BoardCell.EMPTY) {
							nonEmptyCells++;
						}

					}

					if (nonEmptyCells == (this.getMaxCols() - 1)) {

						this.setRowWithColor(rowIndex, BoardCell.EMPTY);

					}

					this.score *= 2;

					this.collapseRows(board);

				}

			}

		}

	}

	private boolean indicesCheck(BoardCell[][] array, int x, int y) {

		boolean xChecker = false;
		boolean yChecker = false;

		if (x >= 0 && x < this.getMaxRows()) {
			xChecker = true;
		}

		if (y >= 0 && y < this.getMaxCols()) {
			yChecker = true;
		}

		return xChecker && yChecker;

	}

}