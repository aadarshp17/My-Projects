package tests;

import java.io.*;
import java.util.*;
import javax.swing.JOptionPane;

public class TestingSupport {
	private static boolean GENERATE_EXPECTED_RESULTS_FILE = false;
	public static String EXPECTED_RESULTS_DIR = "expectedResults/";
	public static String EXPECTED_RESULTS_EXT = "ExpectedResults.txt";
	public static String RESULTS_DIR = "results/";
	public static String RESULTS_EXT = "Results.txt";

	private static InputStream NORMAL_INPUT = System.in;
	private static PrintStream NORMAL_OUTPUT = System.out;

	/**
	 * Redirects standard input to specified file.
	 * 
	 * @param fileName
	 */
	public static void redirectStandardInputToFile(String fileName) {
		InputStream myInput = null;
		try {
			myInput = new FileInputStream(fileName);
		} catch (FileNotFoundException e) {
			System.err.println("File not found.");
		}
		System.setIn(myInput);
	}

	/**
	 * Redirects standard output to returned stream. After running a program, 
	 * call
	 * toString on stream to get output generated by program.
	 * 
	 * @return stream
	 */
	public static ByteArrayOutputStream redirectStandardOutputToByteArrayStream() {
		ByteArrayOutputStream newOutput = new ByteArrayOutputStream();
		PrintStream printStream = new PrintStream(newOutput);
		System.setOut(printStream);

		return newOutput;
	}

	/**
	 * Restores System.in and System.out.
	 * 
	 * @param filename
	 * @param results
	 * @return
	 */
	public static void restoreStandardIO() {
		System.setIn(NORMAL_INPUT);
		System.setOut(NORMAL_OUTPUT);
	}

	/**
	 * Verifies that filename has the same contents as that present in the results
	 * string. It linearizes the file contents and remove blanks. It also remove
	 * blanks from results.
	 * 
	 * @param filename
	 * @param results
	 * @return
	 */
	public static boolean correctResults(String filename, String results) {
		String officialResults = "";
		try {
			BufferedReader fin = new BufferedReader(new FileReader(filename));

			String line;
			while ((line = fin.readLine()) != null) {
				officialResults += line + "\n";
			}

			fin.close();
		} catch (IOException e) {
			System.err.println("File opening failed.");
			return false;
		}

		results = removeBlanks(results);
		officialResults = removeBlanks(officialResults);

		if (results.equals(officialResults)) {
			return true;
		}

		return false;
	}

	/**
	 * Removes all blank characters in a string.
	 * 
	 * @param src
	 * @return
	 */
	public static String removeBlanks(String src) {
		return normalize(src);
	}

	/**
	 * Removes all blank characters in a string.
	 * 
	 * @param src
	 * @return
	 */
	public static String normalize(String in) {
		StringTokenizer st = new StringTokenizer(in);
		StringBuffer retVal = new StringBuffer();

		while (st.hasMoreTokens()) {
			retVal.append(st.nextToken());
		}

		return retVal.toString();
	}

	/**
	 * Places tests results in a file if the GENERATE_EXPECTED_RESULTS_FILE flag is
	 * set.
	 * 
	 * @param results
	 * @param expectedResultsFilename
	 */
	public static void generateExpectedResultsFile(String results, String expectedResultsFilename) {
		/* Official use only (we used this to generate official result) */
		if (GENERATE_EXPECTED_RESULTS_FILE) {
			String message;
			if (!writeToFile(expectedResultsFilename, results)) {
				message = "File copying failed";
			} else {
				message = expectedResultsFilename + " created";
			}
			JOptionPane.showMessageDialog(null, message);
		}
	}

	/**
	 * Writes a string to a file and generates a confirmation message.
	 * 
	 * @param filename
	 * @param data
	 * @return
	 */
	public static boolean writeToFile(String filename, String data) {
		try {
			FileWriter output = new FileWriter(filename);
			output.write(data);
			output.close();
			System.out.println(filename + " has test results (Refresh Eclipse folder to see file)");
		} catch (IOException exception) {
			System.err.println("ERROR: Writing to file " + filename + " failed.");
			return false;
		}
		return true;
	}

	/**
	 * Verifies whether two files have the same contents after removing spaces.
	 * 
	 * @param firstFile
	 * @param secondFile
	 * @return
	 */
	public static boolean sameContents(String firstFile, String secondFile) {
		try {
			if (removeBlanks(fileData(firstFile)).equals(removeBlanks(fileData(secondFile)))) {
				return true;
			}
		} catch (IOException e) {
			e.printStackTrace();
			return false;
		}
		return false;
	}

	/**
	 * Returns a string with a file contents.
	 * 
	 * @param fileName
	 * @return
	 * @throws IOException
	 */
	public static String fileData(String fileName) throws IOException {
		StringBuffer stringBuffer = new StringBuffer();
		FileReader fileReader = new FileReader(fileName);
		BufferedReader bufferedReader = new BufferedReader(fileReader);
		Scanner fileScanner = new Scanner(bufferedReader);

		while (fileScanner.hasNextLine()) {
			stringBuffer.append(fileScanner.nextLine());
		}
		fileScanner.close();

		return stringBuffer.toString();
	}

	/**
	 * Makes a copy of a file.
	 * 
	 * @param sourceFileName
	 * @param targetFileName
	 * 
	 * @return
	 */
	public static boolean copyfile(String sourceFileName, String targetFileName) {
		File sourceFile = new File(sourceFileName);

		if (!sourceFile.exists()) {
			System.err.println(sourceFileName + " does not exist.");
			return false;
		}
		try {
			InputStream inputStream = new FileInputStream(sourceFileName);
			OutputStream outputStream = new FileOutputStream(targetFileName);

			int n;
			while ((n = inputStream.read()) != -1) {
				outputStream.write(n);
			}

			inputStream.close();
			outputStream.close();
		} catch (Exception e) {
			System.err.println("In copyfile " + e.getMessage());
			return false;
		}

		return true;
	}

	/**
	 * Verifies the file filename has the same contents as that present in the
	 * results string. The match must be exact. It will return false if a \n ends
	 * the file.
	 * 
	 * @param filename
	 * @param results
	 * @return
	 */
	public static boolean exactCorrectResults(String filename, String results) {
		StringBuffer officialResults = null;

		try {
			BufferedReader input = new BufferedReader(new FileReader(filename));

			String line;
			boolean firstTime = true;
			while ((line = input.readLine()) != null) {
				if (firstTime) {
					firstTime = false;
					officialResults = new StringBuffer(line);
				} else {
					officialResults.append("\n").append(line);
				}
			}
			input.close();
		} catch (IOException e) {
			System.err.println("File opening failed.");
			return false;
		}

		return results.equals(officialResults.toString());
	}

	public static boolean isResultCorrect(String testName, String results, boolean ignoreBlankChars) {
		String expectedResultsFileName = EXPECTED_RESULTS_DIR + testName + EXPECTED_RESULTS_EXT;
		String resultsFileName = RESULTS_DIR + testName + RESULTS_EXT;

		/* Official results generated when GENERATE_EXPECTED_RESULTS_FILE set */
		/* Otherwise no operation takes place */
		TestingSupport.generateExpectedResultsFile(results, expectedResultsFileName);

		/* Writing tests results to a file (used by student to check their results) */
		TestingSupport.writeToFile(resultsFileName, results);

		/* Verifying whether expected results were generated */
		if (ignoreBlankChars) {
			return correctResults(expectedResultsFileName, results);
		} else {
			return exactCorrectResults(expectedResultsFileName, results);
		}
	}
}