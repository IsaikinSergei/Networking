//
//  CoursesViewController.swift
//  Networking
//
//  Created by Sergei Isaikin on 05.03.2021.
//

import UIKit

class CoursesViewController: UIViewController {
    
    private var courses = [Course]()
    private var courseName: String?
    private var courseURL: String?

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
        
    }
    
    func fetchData() {
        
//        let jsonUrlString = "https://swiftbook.ru//wp-content/uploads/api/api_course"
        let jsonUrlString = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
//        let jsonUrlString = "https://swiftbook.ru//wp-content/uploads/api/api_website_description"
//        let jsonUrlString = "https://swiftbook.ru//wp-content/uploads/api/api_missing_or_wrong_fields"
        
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                self.courses = try decoder.decode([Course].self, from: data)
                
                // перезагружаем таблицу в основном потоке асинхронно
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print("Error serialization json", error)
            }
            
        } .resume()
    }
    
    private func configureCell(cell: TableViewCell, for indexPath: IndexPath) {
        
        let course = courses[indexPath.row]
        cell.courseNameLabel.text = course.name
        
        if let numberOfLessons = course.numberOfLessons {
            cell.numberOfLessons.text = "Number of lessons: \(numberOfLessons)"
        }
        
        if let numberOfTests = course.numberOfTests {
            cell.numberOfTests.text = "Number of tests: \(numberOfTests)"
        }
        
        // url адрес и данные по этому адресу проверяем и получаем в глобальном потоке асинхронно
        DispatchQueue.global().async {
            guard let imageUrl = URL(string: course.imageUrl!) else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            
            // обновление интерфейса (картинка) запускаем в основном потоке асинхронно
            DispatchQueue.main.async {
                cell.courseImage.image = UIImage(data: imageData)
            }
        }
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webViewController = segue.destination as! WebViewController
        webViewController.selectedCourse = courseName
        
        if let url = courseURL {
            webViewController.courseURL = url
        }
    }
}

// MARK: - TableViewDataSource

extension CoursesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        
        configureCell(cell: cell, for: indexPath)
        
        return cell
    }
}

// MARK: - TableViewDelegate

extension CoursesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let course = courses[indexPath.row]
        
        courseURL = course.link
        courseName = course.name
        
        performSegue(withIdentifier: "Description", sender: self)
    }
}
