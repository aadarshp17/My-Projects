package processor;

import java.io.*;
import java.text.NumberFormat;
import java.util.*;

public class OrdersProcessor {

	public static void main(String[] args) {

		Scanner sc = new Scanner(System.in);

		System.out.print("Enter item's data file name: ");
		String itemsfileName = sc.next();

		System.out.print("Enter 'y' for multiple threads, any other "
				+ "character otherwise: ");
		String multipleThreads = sc.next();

		System.out.print("Enter the number of orders to process: ");
		int numOrders = sc.nextInt();

		System.out.print("Enter order's base filename: ");
		String baseFileName = sc.next();

		System.out.print("Enter result's filename: ");
		String resultsFileName = sc.next();

		sc.close();

		ArrayList<String> allFiles = new ArrayList<>();

		ArrayList<String> clientIds = new ArrayList<>();

		for (int i = 1; i <= numOrders; i++) {

			String fileName = "";
			String clientId = "";

			fileName = baseFileName + i + ".txt";

			allFiles.add(fileName);

			File file = new File(allFiles.get(i - 1));

			try (BufferedReader br = new BufferedReader(new FileReader(file))) {
				String line;
				while ((line = br.readLine()) != null) {
					if (line.startsWith("ClientId:")) {
						clientId = line.split(":")[1].trim();
						clientIds.add(clientId);
						break;
					}
				}
			} catch (IOException e) {
				e.printStackTrace();
			}

			System.out.println("Reading order for client with id: " + clientId);

		}

		ArrayList<TreeMap<String, Integer>> allClients = new ArrayList<>();
		TreeMap<String, Double> inventory = new TreeMap<>();
		TreeMap<String, Double> itemTotalPrice = new TreeMap<>();
		TreeMap<String, Integer> itemTotalQuantity = new TreeMap<>();
		
		long startTime = System.currentTimeMillis();
		
		File file = new File(itemsfileName);

		try {
			Scanner scanner = new Scanner(file);
			while (scanner.hasNextLine()) {
				String line = scanner.nextLine();
				String[] parts = line.split(" ");
				inventory.put(parts[0], Double.parseDouble(parts[1]));
			}
			scanner.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}

		if (multipleThreads.equals("y")) {

			Thread[] allThreads = new Thread[numOrders];

			for (int i = 0; i < numOrders; i++) {
				TreeMap<String, Integer> client = new TreeMap
						<String, Integer>();
				allClients.add(client);
				allThreads[i] = new Thread(
						new MyThread(allFiles.get(i), inventory, client, 
								itemTotalPrice, itemTotalQuantity));

			}

			for (Thread thread : allThreads) {

				thread.start();

			}

			for (Thread thread : allThreads) {

				try {
					thread.join();
				} catch (InterruptedException e) {
					e.printStackTrace();
				}

			}

		} else {

			for (int i = 0; i < allFiles.size(); i++) {

				TreeMap<String, Integer> client = new TreeMap<>();

				File order = new File(allFiles.get(i));

				try {
					Scanner scanner = new Scanner(order);
					scanner.nextLine();
					while (scanner.hasNextLine()) {
						String line = scanner.nextLine();
						String[] parts = line.split(" ");

						int quantity = (client.get(parts[0]) == null ? 0 : 
							client.get(parts[0]));
						quantity += 1;
						double price = inventory.get(parts[0]);

						client.put(parts[0], quantity);

						int grandQuantity = (itemTotalQuantity.get(parts[0]) == 
								null ? client.get(parts[0])
								: (itemTotalQuantity.get(parts[0]) + 1));

						itemTotalQuantity.put(parts[0], grandQuantity);

						double grandPrice = (itemTotalPrice.get(parts[0]) == 
								null ? 0.00 : itemTotalPrice.get(parts[0]));
						grandPrice += price;
						itemTotalPrice.put(parts[0], grandPrice);

					}
					scanner.close();
				} catch (FileNotFoundException e) {
					e.printStackTrace();
				}

				allClients.add(client);

			}

		}

		Set<String> allItemsSet = inventory.keySet();
		ArrayList<String> allItems = new ArrayList<>();

		for (String item : allItemsSet) {
			allItems.add(item);
		}

		String orderDetails = "";
		int clientNum = 0;
		for (int j = 0; j < allClients.size(); j++) {

			double orderTotal = 0.0;
			orderDetails += "----- Order details for client with Id: " + 
					clientIds.get(clientNum++) + " -----";

			for (int item = 0; item < allItems.size(); item++) {
				if (allClients.get(j).containsKey(allItems.get(item))) {
					orderDetails += "\n" + "Item's name: " + allItems.get(item) 
							+ ", Cost per item: "
							+ NumberFormat.getCurrencyInstance().format
							(inventory.get(allItems.get(item)))
							+ ", Quantity: " + allClients.get(j)
							.get(allItems.get(item)) + ", Cost: "
							+ NumberFormat.getCurrencyInstance()
							.format((inventory.get((allItems.get(item)))
									* (allClients.get(j).get(allItems
											.get(item)))));
					orderTotal += (inventory.get((allItems.get(item))) 
							* (allClients.get(j).get(allItems.get(item))));
				}
			}
			orderDetails += "\n" + "Order Total: " + NumberFormat.
					getCurrencyInstance().format(orderTotal) + "\n";

		}
		String summary = "***** Summary of all orders *****";
		double grandTotal = 0.0;

		for (int item = 0; item < allItems.size(); item++) {

			summary += "\n" + "Summary - Item's name: " + allItems.get(item) + 
					", Cost per item: "
					+ NumberFormat.getCurrencyInstance().format(inventory.
					get(allItems.get(item))) + ", Number sold: "
					+ itemTotalQuantity.get(allItems.get(item)) +
					", Item's Total: "
					+ NumberFormat.getCurrencyInstance().format(itemTotalPrice
					.get(allItems.get(item)));

			grandTotal += itemTotalPrice.get(allItems.get(item));
		}

		summary += "\n" + "Summary Grand Total: " + NumberFormat.
				getCurrencyInstance().format(grandTotal) + "\n";

		orderDetails += summary;

		try {
			BufferedWriter writer = new BufferedWriter(
					new FileWriter(resultsFileName));
			writer.write(orderDetails);
			writer.close();
		} catch (IOException e) {
			System.out.println(e.getStackTrace());
		}

		long endTime = System.currentTimeMillis();

		System.out.println("Processsing time (msec): " + (endTime - startTime));

		System.out.println("Results can be found in the file: "
				+ resultsFileName);

	}

}