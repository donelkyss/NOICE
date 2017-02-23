//
//  ChatViewController.swift
//  NoIce
//
//  Created by Done Santana on 9/2/17.
//  Copyright © 2017 Done Santana. All rights reserved.
//

import UIKit

class ChatViewController: UITableViewController {
    
    var controlador = ViewController()
    
    @IBOutlet var ChatOpenTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(myvariables.chatsOpen.count)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myvariables.chatsOpen.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OpenChat", for: indexPath)
        // Configure the cell...
        
        if myvariables.chatsOpen[indexPath.row].EmailEmisor == myvariables.userperfil.Email{
            cell.imageView?.image = myvariables.chatsOpen[indexPath.row].DestinoImagen
        }else{
            cell.imageView?.image = myvariables.chatsOpen[indexPath.row].EmisorImagen
        }
        cell.imageView?.layer.cornerRadius = 10//(cell.imageView?.frame.width)!/2
        cell.imageView?.clipsToBounds = true
        cell.textLabel?.text = "Clic to open the chat"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "MSGView") as! MSGViewController
        
        vc.chatIDOpen = myvariables.chatsOpen[indexPath.row].ChatID
        vc.CargarMensajes()
        if myvariables.userperfil.Email == myvariables.chatsOpen[indexPath.row].EmailEmisor{
            vc.destinoChat = "E"
        }else{
           vc.destinoChat = "D"
        }
        self.navigationController?.show(vc, sender: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
