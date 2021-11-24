//
//  AchievementTestView.swift
//  campus-go
//
//  Created by Luiz Gustavo Silva Aguiar on 04/11/21.
//

import UIKit
import CoreData

class AchievementTestView: UITableViewController{
    var listAchievements = [Achievement]()
    let service = AchievementService()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Conquistas"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        fetchAchievement()
    }
    func fetchAchievement() {
        do {
            guard let list = try service.retrieve() else { return }
            listAchievements = list
        } catch {
            print(error)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listAchievements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Achievement", for: indexPath)
        cell.textLabel?.text = listAchievements[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do{
                try service.delete(uid: listAchievements[indexPath.row].uid!)
                listAchievements.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                print(error)
            }
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ac = UIAlertController(title: "Editar", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let uid = listAchievements[indexPath.row].uid!
        let editAction = UIAlertAction(title: "concluir", style: .default) { [weak self, weak ac] action in
            guard let conquista = ac?.textFields?[0].text else { return }
            do{
                try self?.service.update(condition: nil, name: conquista, xpPoints: nil, uid: uid )
                self?.listAchievements[indexPath.row].name = conquista
            } catch {
                print(error)
            }
        }
        ac.addAction(editAction)
        present(ac, animated: true)
        tableView.reloadData()
    }
    @objc func addTapped() {
        let ac = UIAlertController(title: "Nova conquista", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "adicionar", style: .default) { [weak self, weak ac] action in
            guard let conquista = ac?.textFields?[0].text else { return }
            self?.submit(conquista)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    func submit(_ conquista: String){
        do{
            guard let novaConquista = try service.create(condition: "n sei", name: conquista, xpPoints: 2000) else { return }
            listAchievements.insert(novaConquista, at: 0)
        } catch {
            print(error)
        }

        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
}
