package model;

/**
 * This class represents the logic of a game where a board is updated on each
 * step of the game animation. The board can also be updated by selecting a
 * board cell.
 * 
 * @author Department of Computer Science, UMCP
 */

public abstract class Game {

	protected BoardCell[][] board;
	private int maxRows;
	private int maxCols;

	/**
	 * Defines a board with BoardCell.EMPTY cells
	 * 
	 * @param maxRows maximum number of rows
	 * @param maxCols maximum number of columns
	 */
	public Game(int maxRows, int maxCols) {

		this.maxRows = maxRows;
		this.maxCols = maxCols;
		this.board = new BoardCell[maxRows][maxCols];

		for (int row = 0; row < maxRows; row++) {
			for (int col = 0; col < maxCols; col++) {
				board[row][col] = BoardCell.EMPTY;
			}
		}

	}

	/**
	 * 
	 * @return maximum number of rows
	 */
	public int getMaxRows() {

		return this.maxRows;

	}

	/**
	 * 
	 * @return maximum number of columns
	 */
	public int getMaxCols() {

		return this.maxCols;

	}

	/**
	 * Initializes the cell with the specified rowIndex and colIndex with the
	 * BoardCell color
	 * 
	 * @param rowIndex
	 * @param colIndex
	 * @param boardCell
	 */
	public void setBoardCell(int rowIndex, int colIndex, BoardCell boardCell) {

		board[rowIndex][colIndex] = boardCell;

	}

	/**
	 * Returns the BoardCell associated with the specified rowIndex and colIndex
	 * 
	 * @param rowIndex
	 * @param colIndex
	 * @return BoardCell
	 */
	public BoardCell getBoardCell(int rowIndex, int colIndex) {

		return this.board[rowIndex][colIndex];

	}

	/**
	 * Initializes a row with index rowIndex with the specified BoardCell color
	 * 
	 * @param rowIndex
	 * @param cell
	 */
	public void setRowWithColor(int rowIndex, BoardCell cell) {

		for (int col = 0; col < this.getMaxCols(); col++) {

			board[rowIndex][col] = cell;

		}

	}

	/**
	 * Initializes a column with index colIndex with the specified BoardCell color
	 * 
	 * @param colIndex
	 * @param cell
	 */
	public void setColWithColor(int colIndex, BoardCell cell) {

		for (int row = 0; row < this.getMaxRows(); row++) {

			board[row][colIndex] = cell;

		}

	}

	/**
	 * Initializes the board with the specified BoardCell color
	 * 
	 * @param cell
	 */
	public void setBoardWithColor(BoardCell cell) {

		for (int row = 0; row < this.getMaxRows(); row++) {

			for (int col = 0; col < this.getMaxCols(); col++) {

				board[row][col] = cell;

			}
		}
	}

	public abstract boolean isGameOver();

	public abstract int getScore();

	/**
	 * Advances the animation one step.
	 */
	public abstract void nextAnimationStep();

	/**
	 * Adjust the board state according to the current board state and the cell with
	 * rowIndex and colIndex
	 * 
	 * @param rowIndex
	 * @param colIndex
	 */
	public abstract void processCell(int rowIndex, int colIndex);
}