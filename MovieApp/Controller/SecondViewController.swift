//
//  SecondViewController.swift
//  MovieApp
//
//  
//

import UIKit
import Kingfisher
import Network
import CoreData



class SecondViewController: UIViewController {
    
    var networkReach = NetworkReachability()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var moviesArr2 : [MoviesDatabase2] = []
        var secondtableView = UITableView()
        var limit = 5
        var totalmovies = 0
        var index = 0
        var movies:Movies2?
      var movieList2:[MovieList2] = []
      var movieData2:[MovieList2] = []
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            if ((networkReach.isNetworkAvailable()) == true){
                fetchAPI()
                print("fetch api called")
            } else {
                fetchMoviesData2()
                print("fetch database called")
            }
            

            setTableView()
            
            self.view.backgroundColor = .darkGray
            self.navigationItem.title = "Movies List"
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .always
        }

       
        func fetchAPI(){
            let str = "https://task.auditflo.in/2.json"
            let url = URL(string: str)
            
            URLSession.shared.dataTask(with: url!) { [unowned self](data, response, error) in
                if(error == nil){
                    do{
                        
                        self.movies = try JSONDecoder().decode(Movies2.self, from: data!)
                        self.movieList2 = self.movies!.movieList2
                        print("\(self.movieList2)")
                        saveData(movieslist2: movieList2)
                        totalmovies = movieList2.count
                        while index < limit{
                        self.movieData2.append(movieList2[index])
                            index=index+1
                        }
                        
                        DispatchQueue.main.async {
                            self.secondtableView.reloadData()
                        }
                    }catch let error {
                        print(error.localizedDescription)
                    }
                }
            
            }.resume()
        
        }
    
func fetchMoviesData2(){
    do{
        moviesArr2 = try context.fetch(MoviesDatabase2.fetchRequest())
        print("movearr data 11111\(moviesArr2)")
        secondtableView.reloadData()
        
    }catch let error{
        print(error.localizedDescription)
    }
}
    
        func setTableView(){
            secondtableView.frame = self.view.frame
            secondtableView.backgroundColor = UIColor.clear
            secondtableView.dataSource = self
            secondtableView.delegate = self
            self.view.addSubview(secondtableView)
            secondtableView.register(Movies2TableViewCell.self, forCellReuseIdentifier: "cell")
            }
    
    
    func saveData(movieslist2: [MovieList2]){
        
        var moviesDatalist2 : Array<MoviesDatabase2> = Array()
        moviesDatalist2.removeAll()
        for i in movieList2{
            var moviesDataobj1 = MoviesDatabase2(context: context)
            moviesDataobj1.title = i.title
            moviesDataobj1.year = i.year
            moviesDataobj1.imdbid = i.imdbid
            moviesDataobj1.runtime = i.runtime
            moviesDataobj1.cast = i.cast
            moviesDataobj1.movieposter =  Data(i.moviePoster.utf8)
            moviesDatalist2.append(moviesDataobj1)
           
        }
        do{
            try context.save()
            print("saved")
            
        }catch let error{
            print(error.localizedDescription)
        }
    }

    }

    extension SecondViewController: UITableViewDataSource,UITableViewDelegate{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if ((networkReach.isNetworkAvailable()) == true){
            return movieData2.count
            }else{
                return moviesArr2.count
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Movies2TableViewCell
            
            
            if ((networkReach.isNetworkAvailable()) == true){
                let obj = movieData2[indexPath.row]
                print("rows----\(indexPath.row ))")
                cell.movieImage.kf.setImage(with: URL(string: obj.moviePoster))
                cell.titlelbl.text = obj.title
                cell.yearlbl.text = obj.year
                cell.runtimelbl.text = obj.runtime
                cell.castlbl.text = obj.cast
                
                return cell
            }else{
                let obj1 = moviesArr2[indexPath.row]
                if let data = obj1.value(forKey: "movieposter") as? Data{
                   
                    cell.movieImage.image = UIImage(data: data)
                    
                }else{
                    cell.movieImage.image = UIImage(named: "img1")
                }
                
            cell.titlelbl.text = obj1.title
            cell.yearlbl.text = obj1.year
            cell.runtimelbl.text = obj1.runtime
            cell.castlbl.text = obj1.cast
            return cell
        }
        }
        
    
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           
            let remainingcount = movieList2.count  -  limit
            if remainingcount > 0{
    
            if indexPath.row  == movieData2.count - 1
           
            {
               var index = movieData2.count
    
               
                if remainingcount < 5  {
                    limit = index + remainingcount
                    
                }else{
                limit = index + 5;
                }
              
                while index < limit {
                    movieData2.append(movieList2[index])
                    index=index+1
                }
                self.perform(#selector(loadTable), with: nil, afterDelay: 10)
        }
        }

        }
        @objc func loadTable(){
                self.secondtableView.reloadData()
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 208
        }
    }
   
   


