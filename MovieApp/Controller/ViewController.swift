//
//  ViewController.swift
//  MovieApp
//
//  
//

import UIKit
import Kingfisher
import Network
import CoreData


//---------Net Availability----------------//
class NetworkReachability {

    var pathMonitor: NWPathMonitor!
    var path: NWPath?
    lazy var pathUpdateHandler: ((NWPath) -> Void) = { path in
        self.path = path
        if path.status == NWPath.Status.satisfied {
            print("Connected")
        } else if path.status == NWPath.Status.unsatisfied {
            print("unsatisfied")
        } else if path.status == NWPath.Status.requiresConnection {
            print("requiresConnection")
        }
    }

    let backgroudQueue = DispatchQueue.global(qos: .background)

    init() {
        pathMonitor = NWPathMonitor()
        pathMonitor.pathUpdateHandler = self.pathUpdateHandler
        pathMonitor.start(queue: backgroudQueue)
    }

    func isNetworkAvailable() -> Bool {
        if let path = self.path {
            if path.status == NWPath.Status.satisfied {
                return true
            }
        }
        return false
    }
}


class ViewController: UIViewController {
    
    var networkReach = NetworkReachability()
    var tableView = UITableView()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var limit = 5
    var totalmovies = 0
    var index = 0
    var moviesArr : [MoviesDatabase] = []
    var movies:Movies1?
    var movieList:[MovieList] = []
    var movieData:[MovieList] = []
    var movieData1:[MoviesDatabase] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ((networkReach.isNetworkAvailable()) == true){
            fetchAPI()
            print("fetch api called")
        }else{
            fetchMoviesData()
            print("fetch database called")
        }
        
        setTableView()
        
        self.title = "Movies"
        let nextMovieList = UIBarButtonItem(image: UIImage(named: "nextpage"), style: .plain, target: self, action: #selector(gotoNext))
        self.navigationItem.rightBarButtonItem = nextMovieList
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        self.navigationItem.largeTitleDisplayMode = .never
    
    }

//---------------------fetchData from Json Url----------------------//
    func fetchAPI(){
        let str = "https://task.auditflo.in/1.json"
        let url = URL(string: str)
        
        URLSession.shared.dataTask(with: url!) { [unowned self](data, response, error) in
            if(error == nil){
                do{
                    self.movies = try JSONDecoder().decode(Movies1.self, from: data!)
                    self.movieList = self.movies!.movieList
                    print("\(self.movieList)")
                    totalmovies = movieList.count
                    while index < limit{
                    self.movieData.append(movieList[index])
                        index=index+1
                    }
                    saveData(movieslist: movieList)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
        
    }
    //------fetchData from Local DataBase-----------//
    func fetchMoviesData(){
        do{
            moviesArr = try context.fetch(MoviesDatabase.fetchRequest())
            print("movearr data 11111\(moviesArr)")
            tableView.reloadData()
            
        }catch let error{
            print(error.localizedDescription)
        }
        
    }

    func setTableView(){
        tableView.frame = self.view.frame
        tableView.backgroundColor = UIColor.clear
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        tableView.register(Movies1TableViewCell.self, forCellReuseIdentifier: "cell")
        }
    
    @objc func gotoNext(){
        let vc = SecondViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
//--------------save data into core data-------------//
    func saveData(movieslist: [MovieList]){
        
        var moviesDatalist : Array<MoviesDatabase> = Array()
        moviesDatalist.removeAll()
        for i in movieList{
            var moviesDataobj = MoviesDatabase(context: context)
            moviesDataobj.title = i.title
            moviesDataobj.year = i.year
            moviesDataobj.imdbid = i.imdbid
            moviesDataobj.runtime = i.runtime
            moviesDataobj.cast = i.cast
            moviesDataobj.movieposter =  Data(i.moviePoster.utf8)
            moviesDatalist.append(moviesDataobj)
            
           
        }
        do{
            try context.save()
            print("saved")
            
        }catch let error{
            print(error.localizedDescription)
        }
    }
}

extension ViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ((networkReach.isNetworkAvailable()) == true){
        return movieData.count
        }else{
            return moviesArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Movies1TableViewCell
        if ((networkReach.isNetworkAvailable()) == true){
        let obj = movieData[indexPath.row]
        cell.movieImage.kf.setImage(with: URL(string: obj.moviePoster))
        cell.namelbl.text = obj.title
        cell.yearlbl.text = obj.year
        cell.runtimelbl.text = obj.runtime
        cell.castlbl.text = obj.cast
        
        return cell
        }else{
            let obj1 = moviesArr[indexPath.row]
            if let data = obj1.value(forKey: "movieposter") as? Data{
               
                cell.movieImage.image = UIImage(data: data)
                
            }else{
                cell.movieImage.image = UIImage(named: "img1")
            }
            
        cell.namelbl.text = obj1.title
        cell.yearlbl.text = obj1.year
        cell.runtimelbl.text = obj1.runtime
        cell.castlbl.text = obj1.cast
        return cell
    }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
        let remainingcount = movieList.count  -  limit
        if remainingcount > 0 {
        if indexPath.row  == movieData.count - 1
        {
           var index = movieData.count
            if remainingcount < 5  {
                limit = index + remainingcount
            }else{
            limit = index + 5;
            }
            while index < limit {
                movieData.append(movieList[index])
                index=index+1
            }
            self.perform(#selector(loadTable), with: nil, afterDelay: 10)
    }
    }
    }
    @objc func loadTable(){
            self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 208
    }
}
