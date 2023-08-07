package processor;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.TreeMap;

public class MyThread implements Runnable {

	String fileName;
	TreeMap<String, Integer> client;
	TreeMap<String, Double> itemTotalPrice;
	TreeMap<String, Integer> itemTotalQuantity;
	TreeMap<String, Double> inventory;

	public MyThread(String fileName, TreeMap<String, Double> inventory, 
			TreeMap<String, Integer> client,
			TreeMap<String, Double> itemTotalPrice, TreeMap<String, Integer> 
			itemTotalQuantity) {

		this.fileName = fileName;
		this.inventory = inventory;
		this.client = client;
		this.itemTotalPrice = itemTotalPrice;
		this.itemTotalQuantity = itemTotalQuantity;
	}

	public void run() {

		File order = new File(fileName);

		try {
			Scanner scanner = new Scanner(order);
			scanner.nextLine();
			while (scanner.hasNextLine()) {
				String line = scanner.nextLine();
				String[] parts = line.split(" ");

				int quantity = (client.get(parts[0]) == null ? 0 : 
					client.get(parts[0]));
				quantity += 1;
				client.put(parts[0], quantity);

				synchronized (itemTotalQuantity) {
					int grandQuantity = (itemTotalQuantity.get(parts[0]) == null
							? client.get(parts[0]) 
							: (itemTotalQuantity.get(parts[0]) + 1));
					itemTotalQuantity.put(parts[0], grandQuantity);
				}

				synchronized (itemTotalPrice) {
					double price = inventory.get(parts[0]);
					double grandPrice = (itemTotalPrice.get(parts[0]) == null ?
							0.00 : itemTotalPrice.get(parts[0]));
					grandPrice += price;
					itemTotalPrice.put(parts[0], grandPrice);
				}

			}
			scanner.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}

	}

}
